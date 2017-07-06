Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44227 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdGFJ1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 05:27:04 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dT33k-0002ir-QV
        for linux-btrfs@vger.kernel.org; Thu, 06 Jul 2017 11:26:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Chunk root problem
Date: Thu, 6 Jul 2017 09:26:45 +0000 (UTC)
Message-ID: <pan$67634$d61b94ed$6d687910$d4bb6b04@cox.net>
References: <CABRvOkNWpaKB=mAEF9UvUUveFLBQroTWLpC5H=Fqc+okQ_BU3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Brady posted on Wed, 05 Jul 2017 22:10:35 -0600 as excerpted:

> My system suddenly decided it did not want to mount my BTRFS setup. I
> recently rebooted the computer. When it came back, the file system was
> in read only mode. I gave it another boot, but now it does not want to
> mount at all. Anything I can do to recover? This is a Rockstor setup
> that I have had running for about a year.
> 
> uname -a
> Linux hobonas 4.10.6-1.el7.elrepo.x86_64 #1 SMP Sun Mar 26
> 12:19:32 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs --version
> btrfs-progs v4.10.1

FWIW, open ctree failed is the btrfs-generic error, but the transid 
faileds may provide some help.

Addressing the easy answer first...

What btrfs raid mode was it configured for?  If raid56, you want the 
brand new 4.12 kernel at least, as there were serious bugs in previous 
kernels' raid56 mode.  DO NOT ATTEMPT A FIX OF RAID56 MODE WITH AN 
EARLIER KERNEL, IT'S VERY LIKELY TO ONLY CAUSE FURTHER DAMAGE!  But if 
you're lucky, kernel 4.12 can auto-repair it.

With those fixes the known bugs are fixed, but we'll need to wait a few 
cycles to see what the reports are.  Even then, however, due to the 
infamous parity-raid write hole and the fact that the parity isn't 
checksummed, it's not going to be as stable as raid1 or raid10 mode.  
Parity-checksumming will take a new implementation and I'm not sure if 
anyone's actually working on that or not.  But at least until we see how 
stable the newer raid56 code is, 2-4 kernel cycles, it's not recommended 
except for testing only, with even more backups than normal.

If you were raid1 or raid10 mode, the raid mode is stable so it's a 
different issue.  I'll let the experts take it from here.  Single or 
raid0 mode would of course be similar, but without the protection of the 
second copy, making it less resilient.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

