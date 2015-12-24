Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60156 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbbLXXlQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 18:41:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aCFVS-0007pn-HC
	for linux-btrfs@vger.kernel.org; Fri, 25 Dec 2015 00:41:14 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 00:41:14 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 00:41:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs Check - "type mismatch with chunk"
Date: Thu, 24 Dec 2015 23:41:06 +0000 (UTC)
Message-ID: <pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zach Fuller posted on Thu, 24 Dec 2015 13:15:22 -0600 as excerpted:

> I am currently running btrfs on a 2TB GPT drive. The drive is working
> fine, still mounts correctly, and I have experienced no data corruption.
> Whenever I run "btrfs check" on the drive, it returns 100,000+ messages
> stating "bad extent [###, ###), type mismatch with chunk". Whenever I
> try to run "btrfs check --repair" it says that it has fixed the errors,
> but whenever I run "btrfs check" again, the errors return. Should I be
> worried about data/filesystem corruption,
> or are these errors meaningless?

> I have my data backed up on 2 different drives, so I can afford to lose
> the entire btrfs drive temporarily.
> 
> Here is some info about my system:
> 
> $ uname -[r]
> 4.2.5-1-ARCH
> 
> 
> $ btrfs --version
> btrfs-progs v4.3.1

While Chris's reply mentioning a patch is correct, that's not the whole 
story and I suspect you have a problem, as the patch is in the userspace 
4.3.1 you're running.

How long have you had the filesystem?  Was it likely created with the 
mkfs.btrfs from btrfs-progs v4.1.1 (July, 2015) as I suspect?  If so, you 
have a problem, as that mkfs.btrfs was buggy and created invalid 
filesystems.

As you have two separate backups and you're not experiencing corruption 
or the like so far, you should be fine, but if the filesystem was created 
with that buggy mkfs.btrfs, you need to wipe and recreate it as soon as 
possible, because it's unstable in its current state and could fail, with 
massive corruption, at any point.  Unfortunately, the bug created 
filesystems so broken that (last I knew anyway, and your experience 
agrees) there's no way btrfs check --repair can fix them.  The only way 
to fix it is to blow away the filesystem and recreate it with a 
mkfs.btrfs that doesn't have the bug that 4.1.1 did.  Your 4.3.1 should 
be fine.

(The patch Chris mentioned was to btrfs check, as the first set of 
patches to it to allow it to detect the problem triggered all sorts of 
false-positives and pretty much everybody was flagged as having the 
problem.  I believe that was patched in the 4.2 series, however, and 
you're running 4.3.1, so you should have that patch and the reports 
shouldn't be false positives.  Tho if you didn't create the filesystem 
with the buggy mkfs.btrfs from v4.1.1, there's likely some other problem 
to root out, but I'm guessing you did, and thus have the bad filesystem 
the patched btrfs check is designed to report, and that report is indeed 
valid.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

