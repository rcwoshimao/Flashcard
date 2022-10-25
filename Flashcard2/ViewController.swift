//
//  ViewController.swift
//  Flashcard2
//
//  Created by Rebecca Chen on 2022/9/27.
//

import UIKit
struct Flashcard{
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var frontLabel: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        frontLabel.layer.cornerRadius = 20.0;
        backLabel.layer.cornerRadius = 20.0;
        backLabel.clipsToBounds = true;
        frontLabel.clipsToBounds = true;
        view.isUserInteractionEnabled = true;
        
        //read saved flashcards
        readSavedFlashcards()
        
        //add our initial flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Brazil?", answer: "Brazilia")
        }else{
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    @IBAction func didTapOnFlashCard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.frontLabel.isHidden = !self.frontLabel.isHidden
        })
        
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //decrease current index
        currentIndex = currentIndex - 1;
        //decrease current label
        updateLabels()
        //Update buttons
        updateNextPrevButtons()
        animateCardIn()
        print("Did tap on prev")
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //increase current index
        currentIndex = currentIndex + 1;
        //increase current label
        updateLabels()
        //Update buttons
        updateNextPrevButtons()
        animateCardOut()
        print("Did tap on next")
    }
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = question
        backLabel.text = answer
        //adding flashcard in the flashcard rray
        flashcards.append(flashcard)
        
        //logging into console
        print("Executed")
        print("We now have \(flashcards.count) flashcards!")
        
        //update current index
        currentIndex = flashcards.count-1
        print("Our current index is \(currentIndex)")
        //update buttons
        updateNextPrevButtons()
        //update labels
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashCardsController = self
    }
    
    func updateNextPrevButtons(){
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        }else{
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
        
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map{(card) -> [String: String] in return ["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards");
        print("Save all flashcards to disk ran!")
    }
    
    func readSavedFlashcards(){
        print("Read saved cards ran!")
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            //in here we know for sure there is a dictionary array.
            let savedCards = dictionaryArray.map{ dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            //put all these cards in our flashcard array
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    func animateCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            
        }, completion: { finished in
            
            self.updateLabels()
            
            self.animateCardIn()
        })
    }
    
    func animateCardIn(){
        card.transform = CGAffineTransform.init(translationX: 300, y: 0)
        
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity
        }
    }
    
}
