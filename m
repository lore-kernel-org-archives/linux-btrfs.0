From: youagree <n3ocort3x@gmail.com>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 09:55:56 +0200
Message-ID: <j2igev$9nk$1@dough.gmane.org>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4BD272.8000704@uvm.edu> <20110817145509.GA23804@hendrix.borisch.local> <4E4C7BCD.6090004@oracle.com> <4E4CB4D9.4060509@gmail.com> <4E4CBF43.60207@uvm.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4CBF43.60207@uvm.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2011 09:29 AM, Andrew Guertin wrote:
> * Many processes occasionally hang for a short time
> * When this happens, my cpu monitor shows a short burst of cpu activity
> (100% of 1 core) followed by a longer period of IO
> * When this happens, iotop shows [btrfs-submit-0] and [btrfs-transacti]
> at the top of the list
> * Behavior slowly increases in duration (and frequency?) over time, and
> goes away with a reboot
> * Heavy IO makes behavior appear faster
> 
> ... and the following behaviors before commit 4e69b59:
> 
> * Occasional spikes of IO on cpu monitor concurrent with
> [btrfs-submit-0] and [btrfs-transacti] at top of iotop
> * No hangs, even when that occurs

Yes, exactly that happened in my case too. Yours is a much more precise
description! I did not diagnose 2.6.38 further because I just wanted to
establish a known-good version and at first sight (2 days uptime) my HDD
behavior showed that it cannot be good if _any_ HDD thrashing appears at
all in the first place...

I was able to work with the computer during those IO spikes on 2.6.38
too, although it was observable that the HDD is being thrased
(meanwhile, LED was almost constant lit). But it didn't cause other
programs to be unresponsive, I confirm...


> I wasn't taking notes or anything though, so I'm not 100% certain I was
> observing or interpreting or remembering everything correctly.
> 
> --Andrew
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


