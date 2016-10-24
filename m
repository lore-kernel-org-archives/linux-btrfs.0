Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16700 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756012AbcJXBQF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Oct 2016 21:16:05 -0400
Subject: Re: How to recover a filesystem without formatting nor using the
 btrfs check command.
To: none <ytrezq@sdf-eu.org>, <linux-btrfs@vger.kernel.org>
References: <580944C7.103@sdf-eu.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8c5ae48c-4af6-42d9-be0f-06d232764ff2@cn.fujitsu.com>
Date: Mon, 24 Oct 2016 09:15:57 +0800
MIME-Version: 1.0
In-Reply-To: <580944C7.103@sdf-eu.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You could try to use --mode lowmem, which doesn't ever use any loop to 
get next block, but iterating trees.

Current in mainline btrfs-progs, the low memory mode code only checks 
extent/chunk trees, file/subvolume trees are still checked by original mode.

You could try the devel branch from David, which now contains the full 
low memory mode check code:
https://github.com/kdave/btrfs-progs/tree/devel

Although low memory mode doesn't support repair yet, it would give us 
enough info on what's corrupted, so we can later fix it by hand or 
enhance original mode.

Thanks,
Qu

At 10/24/2016 03:42 AM, none wrote:
> Hello,
> I have the following bug
> https://bugzilla.kernel.org/show_bug.cgi?id=178781 in btrfs check, is
> there a way to recover my filesystem in clean state without formatting
> or using btrsfck ? Of course, the point is no longer need the files
> which are damaged.
> So is there a way to recover a btrfs filesystem by deleting the
> corrupted data instead of trying to restore it ?
>
> btrfs fi df /mnt/Opera_Mobile_Emulator_12.1_Linux
> Data, single: total=66.01GiB, used=0.00B
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=5.00GiB, used=28.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=4.00MiB, used=0.00B
>
> btrfs progs version 4.7.3 from Devuan
>
> Label: 'backup'  uuid: 56040bbb-ed5c-47f2-82e2-34457bd7b4f3
>         Total devices 1 FS bytes used 44.00KiB
>         devid    1 size 298.91GiB used 76.04GiB path
> /dev/mapper/isw_bdffeeeijj_Volume0p7
>
> uname -a
> Linux localhost 4.5.0-0.bpo.1-amd64 #1 SMP Debian 4.5.1-1~bpo8+1
> (2016-04-20) x86_64 GNU/Linux
>
> Result of btrfs-image on /dev/mapper/isw_bdffeeeijj_Volume0p7 :
> https://web.archive.org/web/20161020220914/https://filebin.net/7ni8kfpog1dxw4jc/btrfs-image_capture.xz
>
>
> Thanks,
>


