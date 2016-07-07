Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:32785 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbcGGSZr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 14:25:47 -0400
Received: by mail-oi0-f43.google.com with SMTP id u201so34380712oie.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 11:25:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eefaeb0f-9eb0-bd2c-3ce5-5eb28bb43c68@fastmail.fm>
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
 <87efcca5-6871-2dde-e2df-40602f1a24c2@gmail.com> <eefaeb0f-9eb0-bd2c-3ce5-5eb28bb43c68@fastmail.fm>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jul 2016 12:25:37 -0600
Message-ID: <CAJCQCtS5wFT1q5Wrsg1ARQ0qOcmFfqG1=BdqJZ=GoZ1L+UO2AA@mail.gmail.com>
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: Francesco Turco <fturco@fastmail.fm>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 8:55 AM, Francesco Turco <fturco@fastmail.fm> wrote:

> I'm not sure. Commands don't fail explicitely when I use ext4, but I
> agree with you that I may get corruption silently nonetheless.

Use XFS v5 format which is the default in xfsprogs 3.2.3 and later. It
at least checksums metadata.

> Perhaps I
> should try to rule out an hardware problem by filling my USB flash drive
> with a large random file and then checking if its SHA-1 checksum
> corresponds to the original copy on the hard disk. But first I probably
> should backup the current Btrfs filesystem with the dd command. Can I
> proceed?

https://btrfs.wiki.kernel.org/index.php/Gotchas


>> Just to clarify, you're using BTRFS on top of disk encryption (LUKS? Or
>> is it just raw encryption, or even something completely different?), on
>> a USB flash drive (not a USB to SATA adapter with an SSD or HDD in it),
>> correct?
>
> I'm using a btrfs filesystem on a GUID partition encrypted with LUKS.
> It's a Kingston USB flash drive connected directly to my desktop machine
> via USB. It's definitively not a SSD or a HDD, and I'm not using any
> adapter.

First definitely check to make sure it's not fake. It's a well known
brand and there's a lot of incentive to make fake Kingston devices. I
have a Kingston DTR500 and have used it in the same use case you have,
Btrfs on LUKS, for maybe 6 months with no corruptions. In my case I
formatted with -M (mixed bg), and it was with kernels older than 4.x,
but otherwise sounds the same. Granted, individual units of the same
model can have big differences let alone between models. But if it's a
Btrfs bug, it might be a regression.

I wonder if this might be a use case for one of the integrity check
mount options? It slows things down a lot but the extra checking might
help pin point at least the moment something bad is happening.


-- 
Chris Murphy
