Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35174 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbcF0XGV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 19:06:21 -0400
Received: by mail-wm0-f54.google.com with SMTP id v199so117929326wmv.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 16:06:21 -0700 (PDT)
Received: from system (dslb-094-217-100-036.094.217.pools.vodafone-ip.de. [94.217.100.36])
        by smtp.gmail.com with ESMTPSA id t190sm8210581wmt.24.2016.06.27.16.06.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2016 16:06:19 -0700 (PDT)
Date: Tue, 28 Jun 2016 01:06:18 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160628010618.58e235fa@system>
In-Reply-To: <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
	<20160628002602.022258bf@system>
	<CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
	<CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Jun 2016 16:58:37 -0600, Chris Murphy
<lists@colorremedies.com> wrote :

> On Mon, Jun 27, 2016 at 4:55 PM, Chris Murphy
> <lists@colorremedies.com> wrote:
> 
> >> BTRFS info (device sdb1): dev_replace from /dev/sda1 (devid 1)
> >> to /dev/sdd1 started scrub_handle_errored_block: 166 callbacks
> >> suppressed BTRFS warning (device sdb1): checksum error at logical
> >> 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode
> >> 3434831, offset 479232, length 4096, links 1 (path:
> >> user/.local/share/zeitgeist/activity.sqlite-wal)
> >> btrfs_dev_stat_print_on_error: 166 callbacks suppressed BTRFS
> >> error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0,
> >> corrupt 14221, gen 24 scrub_handle_errored_block: 166 callbacks
> >> suppressed BTRFS error (device sdb1): unable to fixup (regular)
> >> error at logical 93445255168 on dev /dev/sda1
> >
> > Shoot. You have a lot of these. It looks suspiciously like you're
> > hitting a case list regulars are only just starting to understand
> 
> Forget this part completely. It doesn't affect raid1. I just re-read
> that your setup is not raid1, I don't know why I thought it was raid5.
> 
> The likely issue here is that you've got legit corruptions on sda (mix
> of slow and flat out bad sectors), as well as a failing drive.
> 
> This is also safe to issue:
> 
> smartctl -l scterc /dev/sda
> smartctl -l scterc /dev/sdb
> cat /sys/block/sda/device/timeout
> cat /sys/block/sdb/device/timeout
> 

My setup is indeed RAID1 (and not RAID5)

root@system:/# smartctl -l scterc /dev/sda
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local
build) Copyright (C) 2002-14, Bruce Allen, Christian Franke,
www.smartmontools.org

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

root@system:/# smartctl -l scterc /dev/sdb
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local
build) Copyright (C) 2002-14, Bruce Allen, Christian Franke,
www.smartmontools.org

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

root@system:/# cat /sys/block/sda/device/timeout
30
root@system:/# cat /sys/block/sdb/device/timeout
30
