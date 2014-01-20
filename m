Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47152 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaATARI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 19:17:08 -0500
Received: by mail-pd0-f171.google.com with SMTP id g10so5420613pdj.30
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 16:17:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
Date: Mon, 20 Jan 2014 01:17:08 +0100
Message-ID: <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
Subject: Re: btrfs and ECC RAM
From: George Eleftheriou <eleftg@gmail.com>
To: Ian Hinder <ian.hinder@aei.mpg.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been wondering the same thing for quite some time after having
read this post (which makes a pretty clear case in favour of ECC
RAM)...

hxxp://forums.freenas.org/threads/ecc-vs-non-ecc-ram-and-zfs.15449/

... and the ZFS on Linux FAQ
hxxp://zfsonlinux.org/faq.html#DoIHaveToUseECCMemory

Moreover, the ZFS community seem to cite this article quite often:
hxxp://research.cs.wisc.edu/adsl/Publications/zfs-corruption-fast10.pdf

Without having further knowledge on that matter, I tend to believe
(but I hope I'm wrong) that BTRFS is as vulnerable as ZFS to memory
errors. Since I upgraded recently, it's a bit too late for purchasing
ECC-capable infrastructure (change of CPU + motherboard + RAM) so I
just chose to ignore this risk by performing a memtest86 right before
every scrub (and having my regular backups ready). I've been using ZFS
on Linux for almost 5 months (having occasional issues with kernel
updates) until last week that I finally switched to BTRFS and I'm
happy.

As for the reliability of ECC RAM (from what I've read about it) it's
just that it corrects single-bit errors and it immediately halts the
system when it finds multi-bit errors.

On Sat, Jan 18, 2014 at 1:23 AM, Ian Hinder <ian.hinder@aei.mpg.de> wrote:
> Hi,
>
> I have been reading a lot of articles online about the dangers of using ZFS with non-ECC RAM.  Specifically, the fact that when good data is read from disk and compared with its checksum, a RAM error can cause the read data to be incorrect, causing a checksum failure, and the bad data might now be written back to the disk in an attempt to correct it, corrupting it in the process.  This would be exacerbated by a scrub, which could run through all your data and potentially corrupt it.  There is a strong current of opinion that using ZFS without ECC RAM is "suicide for your data".
>
> I have been unable to find any discussion of the extent to which this is true for btrfs.  Does btrfs handle checksum errors in the same way as ZFS, or does it perform additional checks before writing "corrected" data back to disk?  For example, if it detects a checksum error, it could read the data again to a different memory location to determine if the error existed in the disk copy or the memory.
>
> From what I've been reading, it sounds like ZFS should not be used with non-ECC RAM.  This is reasonable, as ZFS' resource requirements mean that you probably only want to run it on server-grade hardware anyway.  But with btrfs eventually being the default filesystem for Linux, that would mean that all linux machines, even cheap consumer-grade hardware, would need ECC RAM, or forego many of the advantages of btrfs.
>
> What is the situation?
>
> --
> Ian Hinder
> http://numrel.aei.mpg.de/people/hinder
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
