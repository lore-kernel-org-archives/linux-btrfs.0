Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45908 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATDN0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 22:13:26 -0500
Received: by mail-ie0-f172.google.com with SMTP id e14so7735647iej.17
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 19:13:26 -0800 (PST)
Message-ID: <52DC9453.4000705@gmail.com>
Date: Sun, 19 Jan 2014 22:13:23 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: George Eleftheriou <eleftg@gmail.com>, Ian Hinder <ian.hinder@aei.mpg.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
In-Reply-To: <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/19/2014 07:17 PM, George Eleftheriou wrote:
> I have been wondering the same thing for quite some time after
> having read this post (which makes a pretty clear case in favour of
> ECC RAM)...
> 
> hxxp://forums.freenas.org/threads/ecc-vs-non-ecc-ram-and-zfs.15449/
>
>  ... and the ZFS on Linux FAQ 
> hxxp://zfsonlinux.org/faq.html#DoIHaveToUseECCMemory
> 
> Moreover, the ZFS community seem to cite this article quite often: 
> hxxp://research.cs.wisc.edu/adsl/Publications/zfs-corruption-fast10.pdf
>
>  Without having further knowledge on that matter, I tend to
> believe (but I hope I'm wrong) that BTRFS is as vulnerable as ZFS
> to memory errors. Since I upgraded recently, it's a bit too late
> for purchasing ECC-capable infrastructure (change of CPU +
> motherboard + RAM) so I just chose to ignore this risk by
> performing a memtest86 right before every scrub (and having my
> regular backups ready). I've been using ZFS on Linux for almost 5
> months (having occasional issues with kernel updates) until last
> week that I finally switched to BTRFS and I'm happy.
AFAIK, ZFS does background data scrubbing without user intervention
(which on a separate note can make it a huge energy hog) to correct
on-disk errors.  For performance reasons though, it has no built-in
check to make sure that there really is an error, it just assumes that
if the checksum is wrong, the data on the disk must be wrong.  This is
fine for enterprise level hardware with ECC RAM, because the disk IS
more likely to be wrong in that case than the RAM is.  This assumption
falls apart though on commodity hardware (ie, no ECC RAM), hence the
warnings about using ZFS without ECC RAM.

BTRFS however works differently, it only scrubs data when you tell it
to.  If it encounters a checksum or read error on a data block, it
first tries to find another copy of that block elsewhere (usually on
another disk), if it still sees a wrong checksum there, or gets
another read error, or can't find another copy, then it returns a read
error to userspace, usually resulting in the program reading the data
crashing.  In most environments other than HA clustering, this is an
excellent compromise that still protects data integrity.

> As for the reliability of ECC RAM (from what I've read about it)
> it's just that it corrects single-bit errors and it immediately
> halts the system when it finds multi-bit errors.
> 
That is technically only true of server-grade ECC RAM, there are
higher order ECC memory systems that most people don't even know exist
(mostly because they are almost exclusively used in spacecraft,
nuclear reactors, and other high-radiation environments), and those
can correct multi-bit errors.  Statistically speaking though, the
chance with modern memory designs of getting more than one bit wrong
in the same cell is near zero unless the memory is failing, and of
course if the cell is failing, then ECC for that cell probably can't be
trusted either.  The solution to this of course is to replace any module
that has exceeded some percentage of the MTBF (I would usually say 80%,
but I have met people who replace them at 50%).
