From: Andrew Guertin <andrew.guertin@uvm.edu>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 03:29:07 -0400
Message-ID: <4E4CBF43.60207@uvm.edu>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4BD272.8000704@uvm.edu> <20110817145509.GA23804@hendrix.borisch.local> <4E4C7BCD.6090004@oracle.com> <4E4CB4D9.4060509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: youagree <n3ocort3x@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4CB4D9.4060509@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2011 02:44 AM, youagree wrote:
> Also, a patch by Josef Bacik was an attempt for fixing this, but no one
> reported about testing it on an affected system, it did not eliminate
> the slowdowns for me:
>
> PLEASE TEST: Everybody who is seeing weird and long hangs
> news://news.gmane.org:119/4E36C47E.70309@redhat.com

I had not seen this (actually, I had skimmed it but not thought it was 
relevant). I will try it as soon as I get a chance.

> The HDD thrashing appeared on all other kernel versions I tried, higher
> than 2.6.37.
> Initially, I had been into looking for a latest known good kernel (to
> prepare a proper git bisect as cwillu advised) and at first I also felt
> like 2.6.38 does not show this miserable behaviour. But later it turned
> out this was only for approximately 2 days of uptime. Given enough time,
> the lock-ups appeared on 2.6.38 too. Although they were not that
> apparent than on later kernel versions, and the individual lockups took
> much less time with 2.6.38 running for 2 days (binary Sabayon Linux
> repository kernel).

I have not seen slowdowns on 2.6.38. More specifically, I observe the following 
behaviors after commit 4e69b59:

* Many processes occasionally hang for a short time
* When this happens, my cpu monitor shows a short burst of cpu activity (100% of 
1 core) followed by a longer period of IO
* When this happens, iotop shows [btrfs-submit-0] and [btrfs-transacti] at the 
top of the list
* Behavior slowly increases in duration (and frequency?) over time, and goes 
away with a reboot
* Heavy IO makes behavior appear faster

... and the following behaviors before commit 4e69b59:

* Occasional spikes of IO on cpu monitor concurrent with [btrfs-submit-0] and 
[btrfs-transacti] at top of iotop
* No hangs, even when that occurs

I wasn't taking notes or anything though, so I'm not 100% certain I was 
observing or interpreting or remembering everything correctly.

--Andrew
