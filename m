Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37735 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbcABKsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 05:48:19 -0500
Received: from merkaba.localnet (host-188-174-222-218.customer.m-online.net [188.174.222.218])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 199D224C
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 11:48:18 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs Check - "type mismatch with chunk"
Date: Sat, 02 Jan 2016 11:48:16 +0100
Message-ID: <4569077.c1v08b5nvL@merkaba>
In-Reply-To: <pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com> <pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 24. Dezember 2015, 23:41:06 CET schrieb Duncan:
> Zach Fuller posted on Thu, 24 Dec 2015 13:15:22 -0600 as excerpted:
> > I am currently running btrfs on a 2TB GPT drive. The drive is working
> > fine, still mounts correctly, and I have experienced no data corruption.
> > Whenever I run "btrfs check" on the drive, it returns 100,000+ messages
> > stating "bad extent [###, ###), type mismatch with chunk". Whenever I
> > try to run "btrfs check --repair" it says that it has fixed the errors,
> > but whenever I run "btrfs check" again, the errors return. Should I be
> > worried about data/filesystem corruption,
> > or are these errors meaningless?
> > 
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

I have this issue as well on one of the filesystems I just checked in order to 
describe to John how to have a go at fixing his filesystem. A tone of these 
with different numbers:

bad extent [347045888, 347062272), type mismatch with chunk

It doesn´t go away with running btrfs check --repair on it.

Last scrub was from yesterday and returned with 0 errors. I will rerun a scrub 
again after the repair attempt. And if its good I will play it safe and redo 
the filesystem from scratch.

It may have been I used a mkfs.btrfs from 4.1.1 for creating it. Would be good 
if it stored the version of the tool that created the fs into the fs itself to 
be able to know for sure. It is the youngest BTRFS filesystem on my laptop 
SSDs. I created it about April 2014 tough.

Thanks,
-- 
Martin
