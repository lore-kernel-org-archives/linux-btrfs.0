From: Andrew Guertin <andrew.guertin@uvm.edu>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 07:45:23 -0400
Message-ID: <4E4CFB53.1020208@uvm.edu>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4BD272.8000704@uvm.edu> <20110817145509.GA23804@hendrix.borisch.local> <4E4C7BCD.6090004@oracle.com> <4E4CB4D9.4060509@gmail.com> <4E4CBF43.60207@uvm.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4CBF43.60207@uvm.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2011 03:29 AM, Andrew Guertin wrote:
> I have not seen slowdowns on 2.6.38. More specifically, I observe the
> following behaviors after commit 4e69b59:
> 
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
> 
> I wasn't taking notes or anything though, so I'm not 100% certain I was
> observing or interpreting or remembering everything correctly.

I've investigated a little more, and have a few things to add:

Before commit 4e69b59:

* In the IO spikes where [btrfs-submit-0] and [btrfs-transacti] are at
the top of iotop, there is no short burst of cpu activity preceding them

* When running gentoo's emerge --sync (which IIRC is mainly an rsync of
~200MB of small files), output appears to pause during these spikes. I
wasn't able to tell if output stopped entirely or just slowed down.

--Andrew
