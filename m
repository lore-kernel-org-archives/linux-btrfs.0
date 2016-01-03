Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59310 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcACJ5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 04:57:22 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: John Center <jlcenter15@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs scrub failing
Date: Sun, 03 Jan 2016 10:57:19 +0100
Message-ID: <1759616.kJsmo6qFWb@merkaba>
In-Reply-To: <CAPgWCbQE4aJEQ_vR2vu_ad1v2dH6A=50iUSGnQgNeA4Qo68iSQ@mail.gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com> <3194509.MCEib7paxX@merkaba> <CAPgWCbQE4aJEQ_vR2vu_ad1v2dH6A=50iUSGnQgNeA4Qo68iSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 2. Januar 2016, 18:27:16 CET schrieb John Center:
> 😂Hi Martin,
> 
> > On Jan 2, 2016, at 6:41 AM, Martin Steigerwald <martin@lichtvoll.de>
> 
> wrote:
> > Am Samstag, 2. Januar 2016, 11:35:51 CET schrieb Martin Steigerwald:
> >> Am Freitag, 1. Januar 2016, 20:04:43 CET schrieb John Center:
> >>> Hi Duncan,
> >>> 
> >>>> On Fri, Jan 1, 2016 at 12:05 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> >>> 
> >>>> John Center posted on Fri, 01 Jan 2016 11:41:20 -0500 as excerpted:
> >>> Where do I go from here?
> >> 
> >> These and the other errors point at an issue with the filesystem
> 
> structure.
> 
> >> As I never had to deal with that, I can only give generic advice:
> >> 
> >> 1) Use latest stable btrfs-progs.
> 
> I'm in the process of creating a live USB to boot with.  Since I'm running
> mdadm (imsm) I need to purge dmraid & install mdadm to assemble the drives
> first.  I also need to put the latest version of btrfs-progs on it, too.
>  (As a side note, things have been getting flaky with my workstation, so I
> guess I'm either going to fix this or rebuild it.  I have the data files
> backed up, it's just a pain to have to recreate the system again.)

I think you could even just run a GRML from USB stick and grab the sources via 
git clone and compile them there. Shouldn´t take long. I use:

git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

which has 4.3.1.

> >> 2) Umount the filesystem and run
> >> 
> >> btrfs check (maybe with -p)
> >> 
> >> When it finds some errors, proceed with the following steps:
> >> 
> >> Without --repair or some of the other options that modify things it is
> 
> read
> 
> >> only.
> >> 
> >> 3) If you can still access all the files, first thing to do is: rsync or
> >> otherwise backup them all to a different location, before attempting
> >> anything to repair the issue.
> >> 
> >> 4) If you can´t access some files, you may try to use btrfs restore for
> >> restoring them.
> >> 
> >> 5) Then, if you made sure you have an up-to-date backup run
> >> 
> >> btrfs --repair
> > 
> > Before doing that, review:
> > 
> > https://btrfs.wiki.kernel.org/index.php/Btrfsck
> > 
> > to learn about other options.
> 
> Ok, so "btrfs check -p" first to understand how bad the filesystem is
> corrupted.
> Should I then try to do a recovery mount, or should I run "btrfs check
> --repair -p" to try & fix it?  I'm not sure what a "mount -o ro,recovery"
> does.

Well, if "btrfs check -p" confirms that something needs fixing, you make sure 
you have a working backup *first*, either by rsync or btrfs restore if some 
files are inaccesible, but from what I remember you are able to access all 
files?

Then I´d say give btrfs check --repair a try.

I don´t know much about that mount -o ro,recovery does but from what I 
gathered so far I thought it is only needed when you *can´t* mount the 
filesystem anymore.

> If I have to reformat & reinstall Ubuntu, are there any recommended
> mkfs.btrfs options I should use?  Something that might help prevent
> problems in the future? 😂

Lol. :)

As far as I see mkfs.btrfs from btrfs-tools 4.3.1 already sets extref and 
skinny-metadata as well as 16 KiB node and leaf size by default, so as I 
recreated my /daten BTRFS filesystem due to the extent type mismatch errors 
(see other thread) I used use mkfs.btrfs -L daten to set a label.

Thanks,
-- 
Martin
