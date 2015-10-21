Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32865 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbbJURrB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 13:47:01 -0400
Received: by wijp11 with SMTP id p11so106545270wij.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 10:46:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
References: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
	<CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
Date: Wed, 21 Oct 2015 19:46:59 +0200
Message-ID: <CANznX5Hdh045SsM3bXNEk-0q0iJUxhxH5_0itHxZFbmWDNQkkg@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: "Janos Toth F." <toth.f.janos@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried several things, including the degraded mount option. One example:

# mount /dev/sdb /data -o ro,degraded,nodatasum,notreelog
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

# cat /proc/kmsg
<6>[  262.616929] BTRFS info (device sdd): allowing degraded mounts
<6>[  262.616943] BTRFS info (device sdd): setting nodatasum
<6>[  262.616949] BTRFS info (device sdd): disk space caching is enabled
<6>[  262.616953] BTRFS: has skinny extents
<6>[  262.652671] BTRFS: bdev (null) errs: wr 858, rd 8057, flush 280,
corrupt 0, gen 0
<3>[  262.697162] BTRFS (device sdd): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[  262.697633] BTRFS (device sdd): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[  262.697660] BTRFS: Failed to read block groups: -5
<3>[  262.709885] BTRFS: open_ctree failed
<6>[  267.197365] BTRFS info (device sdd): allowing degraded mounts
<6>[  267.197385] BTRFS info (device sdd): setting nodatasum
<6>[  267.197397] BTRFS info (device sdd): disabling tree log
<6>[  267.197406] BTRFS info (device sdd): disk space caching is enabled
<6>[  267.197412] BTRFS: has skinny extents
<6>[  267.232809] BTRFS: bdev (null) errs: wr 858, rd 8057, flush 280,
corrupt 0, gen 0
<3>[  267.246167] BTRFS (device sdd): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[  267.246706] BTRFS (device sdd): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[  267.246727] BTRFS: Failed to read block groups: -5
<3>[  267.261392] BTRFS: open_ctree failed

On Wed, Oct 21, 2015 at 6:09 PM, Janos Toth F. <toth.f.janos@gmail.com> wrote:
> I went through all the recovery options I could find (starting from
> read-only to "extraordinarily dangerous"). Nothing seemed to work.
>
> A Windows based proprietary recovery software (ReclaiMe) could scratch
> the surface but only that (it showed me the whole original folder
> structure after a few minutes of scanning and the "preview" of some
> some plaintext files was promising but most of the bigger files seemed
> to be broken).
>
> I used this as a bulk storage for backups and all the things I didn't
> care to keep in more than one copies but that includes my
> "scratchpad", so I cared enough to use RAID5 mode and to try restoring
> some things.
>
> Any last ideas before I "ata secure erase" and sell/repurpose the disks?
