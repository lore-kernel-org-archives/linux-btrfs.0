Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:41714 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbLYF2N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 00:28:13 -0500
From: covici@ccs.covici.com
To: Duncan <1i5t5.duncan@cox.net>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs Check - "type mismatch with chunk"
In-reply-to: <pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com> <pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 25 Dec 2015 00:28:09 -0500
Message-ID: <9871.1451021289@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> wrote:

> Zach Fuller posted on Thu, 24 Dec 2015 13:15:22 -0600 as excerpted:
> 
> > I am currently running btrfs on a 2TB GPT drive. The drive is working
> > fine, still mounts correctly, and I have experienced no data corruption.
> > Whenever I run "btrfs check" on the drive, it returns 100,000+ messages
> > stating "bad extent [###, ###), type mismatch with chunk". Whenever I
> > try to run "btrfs check --repair" it says that it has fixed the errors,
> > but whenever I run "btrfs check" again, the errors return. Should I be
> > worried about data/filesystem corruption,
> > or are these errors meaningless?
> 
> > I have my data backed up on 2 different drives, so I can afford to lose
> > the entire btrfs drive temporarily.
> > 
> > Here is some info about my system:
> > 
> > $ uname -[r]
> > 4.2.5-1-ARCH
> > 
> > 
> > $ btrfs --version
> > btrfs-progs v4.3.1
> 
> While Chris's reply mentioning a patch is correct, that's not the whole 
> story and I suspect you have a problem, as the patch is in the userspace 
> 4.3.1 you're running.
> 
> How long have you had the filesystem?  Was it likely created with the 
> mkfs.btrfs from btrfs-progs v4.1.1 (July, 2015) as I suspect?  If so, you 
> have a problem, as that mkfs.btrfs was buggy and created invalid 
> filesystems.
> 
> As you have two separate backups and you're not experiencing corruption 
> or the like so far, you should be fine, but if the filesystem was created 
> with that buggy mkfs.btrfs, you need to wipe and recreate it as soon as 
> possible, because it's unstable in its current state and could fail, with 
> massive corruption, at any point.  Unfortunately, the bug created 
> filesystems so broken that (last I knew anyway, and your experience 
> agrees) there's no way btrfs check --repair can fix them.  The only way 
> to fix it is to blow away the filesystem and recreate it with a 
> mkfs.btrfs that doesn't have the bug that 4.1.1 did.  Your 4.3.1 should 
> be fine.
> 
> (The patch Chris mentioned was to btrfs check, as the first set of 
> patches to it to allow it to detect the problem triggered all sorts of 
> false-positives and pretty much everybody was flagged as having the 
> problem.  I believe that was patched in the 4.2 series, however, and 
> you're running 4.3.1, so you should have that patch and the reports 
> shouldn't be false positives.  Tho if you didn't create the filesystem 
> with the buggy mkfs.btrfs from v4.1.1, there's likely some other problem 
> to root out, but I'm guessing you did, and thus have the bad filesystem 
> the patched btrfs check is designed to report, and that report is indeed 
> valid.)

Hmmm, I just used the 4.1 mkfs.btrfs to create some of the file systems
I have, because that was on the cd I booted with because I had to do
this offline.  So, can I fix things, ro do I have to find a cd with the
4.3.1 programs, or can I put the mkfs.btrfs binary on a USB drive, copy
the files off, recreate the file systems and do a copy back? grrrr!

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
