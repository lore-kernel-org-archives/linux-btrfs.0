Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34959 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbcF0W6j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 18:58:39 -0400
Received: by mail-oi0-f52.google.com with SMTP id r2so221243113oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 15:58:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 16:58:37 -0600
Message-ID: <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Chris Murphy <lists@colorremedies.com>
Cc: Saint Germain <saintger@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 4:55 PM, Chris Murphy <lists@colorremedies.com> wrote:

>> BTRFS info (device sdb1): dev_replace from /dev/sda1 (devid 1) to /dev/sdd1 started
>> scrub_handle_errored_block: 166 callbacks suppressed
>> BTRFS warning (device sdb1): checksum error at logical 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode 3434831, offset 479232, length 4096, links 1 (path: user/.local/share/zeitgeist/activity.sqlite-wal)
>> btrfs_dev_stat_print_on_error: 166 callbacks suppressed
>> BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14221, gen 24
>> scrub_handle_errored_block: 166 callbacks suppressed
>> BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445255168 on dev /dev/sda1
>
> Shoot. You have a lot of these. It looks suspiciously like you're
> hitting a case list regulars are only just starting to understand

Forget this part completely. It doesn't affect raid1. I just re-read
that your setup is not raid1, I don't know why I thought it was raid5.

The likely issue here is that you've got legit corruptions on sda (mix
of slow and flat out bad sectors), as well as a failing drive.

This is also safe to issue:

smartctl -l scterc /dev/sda
smartctl -l scterc /dev/sdb
cat /sys/block/sda/device/timeout
cat /sys/block/sdb/device/timeout




-- 
Chris Murphy
