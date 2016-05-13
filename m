Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33838 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbcEMBlr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 21:41:47 -0400
Received: by mail-oi0-f46.google.com with SMTP id k142so149016478oib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 18:41:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463075341.3636.56.camel@clone1.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	<97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
	<1463075341.3636.56.camel@clone1.com>
Date: Thu, 12 May 2016 19:41:41 -0600
Message-ID: <CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: Chris Murphy <lists@colorremedies.com>
To: "Richard A. Lochner" <lochner@clone1.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 11:49 AM, Richard A. Lochner <lochner@clone1.com> wrote:

> I suspected, and I still suspect that the error occurred upon a
> metadata update that corrupted the checksum for the file, probably due
> to silent memory corruption.  If the checksum was silently corrupted,
> it would be simply written to both drives causing this type of error.

Metadata is checksummed independently of data. So if the data isn't
updated, its checksum doesn't change, only metadata checksum is
changed.

>
> btrfs dmesg(s):
>
> [16510.334020] BTRFS warning (device sdb1): checksum error at logical
> 3037444042752 on dev /dev/sdb1, sector 4988789496, root 259, inode
> 1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
> [16510.334043] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 0, rd
> 0, flush 0, corrupt 5, gen 0
> [16510.345662] BTRFS error (device sdb1): unable to fixup (regular)
> error at logical 3037444042752 on dev /dev/sdb1
>
> [17606.978439] BTRFS warning (device sdb1): checksum error at logical
> 3037444042752 on dev /dev/sdc1, sector 4988750584, root 259, inode
> 1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
> [17606.978460] BTRFS error (device sdb1): bdev /dev/sdc1 errs: wr 0, rd
> 13, flush 0, corrupt 4, gen 0
> [17606.989497] BTRFS error (device sdb1): unable to fixup (regular)
> error at logical 3037444042752 on dev /dev/sdc1

This is confusing. Are these the same boot? The later time has a lower
corrupt count. Can you just 'dd if=sda4.img of=/dev/null' and report
all (new) messages in dmesg? It seems to me there should be pretty
much all the same monotonic-time for the problem with both devices.

Also what do you get for these for each device:

smartctl scterc -l /dev/sdX
cat /sys/block/sdX/device/timeout


-- 
Chris Murphy
