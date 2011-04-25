From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writes got stuck
Date: Sun, 24 Apr 2011 23:28:27 -0600
Message-ID: <E23DF119-94DD-4B78-B1D8-E73BCD1598BB@colorremedies.com>
Mime-Version: 1.0 (Apple Message framework v1082.1)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


On Tue, 19 Apr 2011 05:08:05 -0700 Chris Mason wrote:

>  
> Excerpts from Cheng Shao's message of 2011-04-18 17:49:29 -0400:
> > Hi there,
> > 
> > I'm periodically having issues with btrfs running in a Ubuntu VM using
> > VirtualBox. After the VM has been running for a while (a couple days),
> > any write operation seems getting stuck. The read seems totally fine.
> > I tried a simple dd of a 4M file and it got stuck after writing 131K
> > worth of data.
> > 
> > I don't know if this is btrfs related, or it is due to some bug in
> > VritualBox. Could you guys provide information on how to debug this
> > (collecting logs, getting dumps etc.)? Thanks a lot!
> 
> Which kernel are you running?
> 

Not reproducible with Linux 2.6.38.2-9.fc15.x86_64, Fedora 15 beta2, VirtualBox 4.06 on a Mac OS X host. 

Unrelated to btrfs but related to VirtualBox write hang, I did experience numerous hangs during installation of F15, which were apparently* resolved with kernel parameter clocksource=jiffies which is not related to btrfs, and was not previously required for F14 with earlier versions of VirtualBox.


Chris Murphy


* I say apparently with a sample of 8 failures without the option and 1 success with the option.