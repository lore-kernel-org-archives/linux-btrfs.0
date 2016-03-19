Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34751 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcCSXC6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 19:02:58 -0400
Received: by mail-ig0-f169.google.com with SMTP id av4so62503696igc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 16:02:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <trinity-168495fe-1b45-46b7-bd18-d68fb686437e-1458425733744@3capp-gmx-bs02>
References: <trinity-168495fe-1b45-46b7-bd18-d68fb686437e-1458425733744@3capp-gmx-bs02>
Date: Sat, 19 Mar 2016 17:02:57 -0600
Message-ID: <CAJCQCtQed4JJpoy-GSAJwOK+ueEBqDqkPCF_iNDiPi6ku6865A@mail.gmail.com>
Subject: Re: unable to mount btrfs partition, please help :(
From: Chris Murphy <lists@colorremedies.com>
To: Patrick Tschackert <Killing-Time@gmx.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 19, 2016 at 4:15 PM, Patrick Tschackert <Killing-Time@gmx.de> wrote:

> I'm growing increasingly desperate, can anyone help me? I'm thinking
> of trying one or more of the following, but would like an informed
> opinion:
> 1) btrfs check --fix-crc
> 2) btrfs-check --init-csum-tree
> 3) btrfs rescue chunk-recover
> 4) btrfs-check --repair
> 5) btrfs rescue zero-log

None of the above. Try 'btrfs check' without any options first.

To me it seems the problem is instigated by lower layers either not
completing critical writes at the time of the power failure, or didn't
rebuild correctly.

You should check the SCT ERC setting on each drive with 'smartctl -l
scterc /dev/sdX' and also the kernel command timer setting with 'cat
/sys/block/sdX/device/timeout' also for each device. The SCT ERC value
must be less than the command timer. It's a common misconfiguration
with raid setups.

After that's fixed you should do a scrub, and I'm thinking it's best
to do only a check, which means 'echo check >
/sys/block/mdX/md/sync_action' rather than issuing repair which
assumes data strips are correct and parity strips are wrong and
rebuilds all parity strips.


>
> $ uname -a
> Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
> (2016-02-29) x86_64 GNU/Linux

This is old. You should upgrade to something newer, ideally 4.5 but
4.4.6 is good also, and then oldest I'd suggest is 4.1.20.

>
> $ btrfs --version
> btrfs-progs v4.4

Good.

> $ btrfs fi show
> Label: none uuid: 9868d803-78d1-40c3-b1ee-a4ce3363df87
> Total devices 1 FS bytes used 16.07TiB
> devid 1 size 19.10TiB used 16.27TiB path /dev/mapper/storage
>
> excerpt from DMESG:
> [ 151.970916] BTRFS: device fsid 9868d803-78d1-40c3-b1ee-a4ce3363df87
> devid 1 transid 1322969 /dev/dm-0
> [ 163.105784] BTRFS info (device dm-0): disk space caching is enabled
> [ 165.304968] BTRFS: bad tree block start 4530277753793296986 36340960788480
> [ 165.305233] BTRFS: bad tree block start 4530277753793296986 36340960788480
> [ 165.305281] BTRFS: failed to read chunk tree on dm-0
> [ 165.331407] BTRFS: open_ctree failed

Yeah this isn't a good message typically. There's one surprising (to
me) case where someone had luck getting this fixed with btrfs-zero-log
which is unexpected. But I think it's very premature to make changes
to the file system until you have more information.

What do you get for
btrfs-find-root /dev/mdX
btrfs-show-super -fa /dev/mdX


-- 
Chris Murphy
