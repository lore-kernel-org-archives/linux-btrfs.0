Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58023 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbbDXEaS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 00:30:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlVFk-0007z1-Uk
	for linux-btrfs@vger.kernel.org; Fri, 24 Apr 2015 06:30:13 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 06:30:12 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 06:30:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help needed when btrfs raid5 crashed
Date: Fri, 24 Apr 2015 04:30:06 +0000 (UTC)
Message-ID: <pan$62985$4316c7f3$e6b138d7$3fa1e338@cox.net>
References: <935962336.145772.1429810256346.JavaMail.open-xchange@oxbaltgw03.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- - posted on Thu, 23 Apr 2015 19:30:56 +0200 as excerpted:

> Hello,
> 
> I had a 3 disk raid5 system with btrfs installed. Unfortunately one of
> the disks crashed. Now I cannot mount the system any more, not even with
> the degraded option. I suspect the failed disk to have a hw failure. I
> Think part of the problem might be that I configured the system to not
> only have the data and metadata, but also the system data in raid
> config. Is there any chance that I might get my data back from the file
> system?
> 
> Currently the system does not boot any more. It was a debian testing
> system with btrfs version 3.17. The kernel was originally
> 3.16.0-4-amd64, but now I also have 3.19.0-trunk-amd64 installed.
> 
> When I run btrfs fi show, I get an error message:
> Check tree block failed, want=<big number>, have=<another big number>
> read block failed check_tree_block Couldn' t read chunk root warning,
> device 2 is missing
> 
> Sorry, I cannot copy/paste as the machine does not boot anymore.
> 
> Can anyone give me some help or can explain to me what other kind of
> info you need? Thanks.

Full recovery support for btrfs raid5 is very *VERY* new.  Kernel 3.19 
was the first version that was supposed to have it at all, and due to the 
newness, it could be expected to be buggy, so you should really have 4.0 
and be prepared to upgrade kernels pretty quickly for a few releases 
until the raid56 mode support matures a bit.  Before 3.19, normal raid56 
modes runtime was there, but support for recovery wasn't complete, so in 
effect you were running a slow raid0, with effectively no available 
protection against device failure at all (parity was calculated and 
written, the runtime side, but the code to use it for recovery was 
incomplete).

So first off, for btrfs raid5 recovery, forget kernels previous to 3.19 
and preferably use 4.0.  Second, try a similarly current userspace.  I'm 
not actually sure on userspace raid5 status, but 3.17 is certainly not 
current userspace, and given the newness of raid5 recovery support, I'd 
strongly recommend 3.19 or 3.19.1 (current as of two days ago at least) 
userspace as well, just to be sure.

Beyond that... I'm running raid1 mode here and have only followed raid56 
mode development at a certain distance, so my help will be limited.  
However...

Third, I'm not sure if the wiki (https://btrfs.wiki.kernel.org) has been 
well updated for raid56 or not, but the user-level guy with the most 
testing and experience with it (pre-full-recovery-support, at least) is 
Marc MERLIN, and there should be a link from the wiki's raid56 discussion 
to his blog, which has FAR more detail, altho as I said, some of it may 
be a bit dated now if he hasn't updated.  But that's likely to be some of 
the better help you can get.

Forth... those "big numbers" you mentioned are probably generation aka 
transaction-id numbers.  The generation/transid is a monotonically 
increasing number bumped every time the root block is updated, which is 
every 30 seconds (by default) if anything has changed on the btrfs.  So 
on an active btrfs around for any length of time, yes, it'll be a "big 
number".  But because it's monotonically increasing, the difference 
between the wanted and have values can give you a hint at how bad the 
situation is.  If wanted is only a bit higher, the generations are fairly 
close and the chances of recovery are reasonably good.  If wanted is a 
LOT higher, then you may well still be able to recover, but the number of 
files that may revert to old copies is higher.  If wanted is LOWER than 
have, you probably hit the bug from a couple kernels ago that was 
resetting generation.  That's an entirely different situation with its 
own recovery scenario.

Fifth, on the wiki there's a (somewhat dated last I looked) writeup on 
using btrfs-find-root and btrfs restore, to try to recover files from an 
unmounted filesystem, writing them to some other location as it finds 
them.  This tool doesn't write anything to the damaged btrfs, so unlike 
other tools, has no chance of making the damage worse.  You can use it to 
pull files off the filesystem, if you don't have a current backup (which 
you certainly should have had of btrfs raid5, given that before 3.19 it 
was effectively btrfs raid0, if you placed any value on the data at all, 
but unfortunately, people often learn about the importance of backups the 
hard way).  The general idea is that you find a good generation using 
find-root, and then feed that to restore if the current generation isn't 
usable, to get as current a valid version of your files as possible.

*BUT*, I'm not entirely sure of btrfs restore's ability to work with 
raid5, that being so new.  Hopefully it works and you're good, but...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

