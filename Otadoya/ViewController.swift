//
//  ViewController.swift
//  Otadoya
//
//  Created by Dmitry Pilikov on 19/01/17.
//  Copyright © 2017 Dmitry Pilikov. All rights reserved.
//

import UIKit
import AVFoundation

var currientIndex = 0



class ViewController: UIViewController {
    var audioPlayer = AVAudioPlayer()
    let opacityAnimation = OpacityAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            
            var array = ["sbA", "sbB", "sbV", "sbG", "sbD", "sbE", "sbEE", "sbJ", "sbZ", "sbI", "sbII", "sbK", "sbL", "sbM", "sbN", "sbO", "sbP", "sbR", "sbS", "sbT", "sbU", "sbF", "sbH", "sbC", "sbCH", "sbSH", "sbSHH", "sbHard", "sbIII", "sbSoft", "sbEEE", "sbYU", "sbYA", "sb1", "sb2", "sb3", "sb4", "sb5", "sb6", "sb7", "sb8", "sb9", "sb10"]
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: array[randomIndex]) as! ViewController
            
            self.present(resultViewController, animated:true, completion:nil)
            var audioFilePath = Bundle.main.path(forResource: "spring", ofType: "wav")
            
            var audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
                
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = opacityAnimation
        var audioFilePath = Bundle.main.path(forResource: "dzin", ofType: "wav")
        
            var audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }    }

}
