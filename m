Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35767 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbcE2GYD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 02:24:03 -0400
Received: by mail-lf0-f45.google.com with SMTP id w16so48422916lfd.2
        for <linux-btrfs@vger.kernel.org>; Sat, 28 May 2016 23:24:02 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Ferry Toth <ftoth@exalondelft.nl>, linux-btrfs@vger.kernel.org
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org> <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
 <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
 <CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
 <1c1358af-4549-618a-c408-b93832d33225@gmail.com> <nhnfu8$igq$1@ger.gmane.org>
 <9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <574A8AFF.7020606@gmail.com>
Date: Sun, 29 May 2016 09:23:59 +0300
MIME-Version: 1.0
In-Reply-To: <9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

20.05.2016 20:59, Austin S. Hemmelgarn пишет:
> On 2016-05-20 13:02, Ferry Toth wrote:
>> We have 4 1TB drives in MBR, 1MB free at the beginning, grub on all 4,
>> then 8GB swap, then all the rest btrfs (no LVM used). The 4 btrfs
>> partitions are in the same pool, which is in btrfs RAID10 format. /boot
>> is in subvolume @boot.
> If you have GRUB installed on all 4, then you don't actually have the
> full 2047 sectors between the MBR and the partition free, as GRUB is
> embedded in that space.  I forget exactly how much space it takes up,
> but I know it's not the whole 1023.5K  I would not suggest risking usage
> of the final 8k there though.

If you mean grub2, required space is variable and depends on where
/boot/grub is located (i.e. which drivers it needs to access it).
Assuming plain btrfs on legacy BIOS MBR, required space is around 40-50KB.

Note that grub2 detects some post-MBR gap software signatures and skips
over them (space need not be contiguous). It is entirely possible to add
bcache detection if enough demand exists.
