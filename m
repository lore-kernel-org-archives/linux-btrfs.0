Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33883 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160998AbcE2RxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 13:53:06 -0400
Received: by mail-oi0-f48.google.com with SMTP id b65so241943574oia.1
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 10:53:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <574A8AFF.7020606@gmail.com>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
	<nhedk2$dpq$1@ger.gmane.org>
	<0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
	<20160517203335.5ff99a05@jupiter.sol.kaishome.de>
	<nhir96$8n4$1@ger.gmane.org>
	<20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
	<e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
	<CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
	<1c1358af-4549-618a-c408-b93832d33225@gmail.com>
	<nhnfu8$igq$1@ger.gmane.org>
	<9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com>
	<574A8AFF.7020606@gmail.com>
Date: Sun, 29 May 2016 11:53:05 -0600
Message-ID: <CAJCQCtRnLekmARtLNySDofJah12CpKO0VpKygwf7NfQJzS8URg@mail.gmail.com>
Subject: Re: Hot data tracking / hybrid storage
From: Chris Murphy <lists@colorremedies.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Ferry Toth <ftoth@exalondelft.nl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 29, 2016 at 12:23 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 20.05.2016 20:59, Austin S. Hemmelgarn пишет:
>> On 2016-05-20 13:02, Ferry Toth wrote:
>>> We have 4 1TB drives in MBR, 1MB free at the beginning, grub on all 4,
>>> then 8GB swap, then all the rest btrfs (no LVM used). The 4 btrfs
>>> partitions are in the same pool, which is in btrfs RAID10 format. /boot
>>> is in subvolume @boot.
>> If you have GRUB installed on all 4, then you don't actually have the
>> full 2047 sectors between the MBR and the partition free, as GRUB is
>> embedded in that space.  I forget exactly how much space it takes up,
>> but I know it's not the whole 1023.5K  I would not suggest risking usage
>> of the final 8k there though.
>
> If you mean grub2, required space is variable and depends on where
> /boot/grub is located (i.e. which drivers it needs to access it).
> Assuming plain btrfs on legacy BIOS MBR, required space is around 40-50KB.
>
> Note that grub2 detects some post-MBR gap software signatures and skips
> over them (space need not be contiguous). It is entirely possible to add
> bcache detection if enough demand exists.

Might not be a bad idea, just to avoid it getting stepped on and
causing later confusion. If it is stepped on I don't think there's
data loss except possibly in the case where there's an unclean
shutdown where the SSD has bcache data that hasn't been committed to
the HDD?

But I'm skeptical of bcache using a hidden area historically for the
bootloader, to put its device metadata. I didn't realize that was the
case. Imagine if LVM were to stuff metadata into the MBR gap, or
mdadm. Egads.


-- 
Chris Murphy
