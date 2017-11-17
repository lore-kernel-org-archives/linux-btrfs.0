Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mokrynskyi.com ([46.4.12.50]:54496 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbdKQPsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 10:48:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 83FD81332
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 15:41:47 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gMtr3hif9lAD for <linux-btrfs@vger.kernel.org>;
        Fri, 17 Nov 2017 15:41:47 +0000 (UTC)
Received: from [192.168.1.2] (bomann.znet.kiev.ua [176.122.88.128])
        by mx.mokrynskyi.com (Postfix) with ESMTPSA id 223C61328
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 15:41:47 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Unrecoverable scrub errors
Message-ID: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
Date: Fri, 17 Nov 2017 17:41:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

I'm a long-term btrfs user (permanently for my root partition and other stuff for ~3 years now, with compression, most of the way with RAID0 on various SSD, etc).

In simple words my setup consists of root partition and backup partition. There are automated snapshots on root partition which are then copied to online backup partition (send/receive, handled by "Just backup btrfs") and occasionally to offline backup partition (handled by "Btrfs sync subvolumes").

I've recently found that my online backup partition has some unrecoverable errors as reported after running scrub:

> scrub status for 82cfcb0f-0b80-4764-bed6-f529f2030ac5
>         scrub started at Fri Nov 17 15:05:12 2017 and finished after 02:07:30
>         total bytes scrubbed: 915.16GiB with 12 errors
>         error details: csum=12
>         corrected errors: 0, uncorrectable errors: 12, unverified errors: 0
dmesg (this is all related to mentioned errors):

> [551049.038718] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
> [551049.038720] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238048: metadata leaf (level 0) in tree 985
> [551049.038723] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> [551049.039634] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
> [551049.039635] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238176: metadata leaf (level 0) in tree 985
> [551049.039637] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
> [551049.413114] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551049.413473] BTRFS warning (device dm-2): checksum error at logical 470069477376 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238080: metadata leaf (level 0) in tree 985
> [551049.413473] BTRFS warning (device dm-2): checksum error at logical 470069477376 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238080: metadata leaf (level 0) in tree 985
> [551049.413475] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
> [551049.413685] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069477376 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551049.413910] BTRFS warning (device dm-2): checksum error at logical 470069493760 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238112: metadata leaf (level 0) in tree 985
> [551049.413911] BTRFS warning (device dm-2): checksum error at logical 470069493760 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238112: metadata leaf (level 0) in tree 985
> [551049.413912] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> [551049.414121] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069493760 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551049.414354] BTRFS warning (device dm-2): checksum error at logical 470069510144 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238144: metadata leaf (level 0) in tree 985
> [551049.414355] BTRFS warning (device dm-2): checksum error at logical 470069510144 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238144: metadata leaf (level 0) in tree 985
> [551049.414356] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
> [551049.414567] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069510144 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551049.479023] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551049.479989] BTRFS warning (device dm-2): checksum error at logical 470069542912 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238208: metadata leaf (level 0) in tree 985
> [551049.479993] BTRFS warning (device dm-2): checksum error at logical 470069542912 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 942238208: metadata leaf (level 0) in tree 985
> [551049.479997] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
> [551049.523539] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069542912 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551051.672589] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286624: metadata leaf (level 0) in tree 985
> [551051.672593] BTRFS warning (device dm-2): checksum error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286624: metadata leaf (level 0) in tree 985
> [551051.672597] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
> [551051.820776] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069460992 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551051.945310] BTRFS warning (device dm-2): checksum error at logical 470069477376 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286656: metadata leaf (level 0) in tree 985
> [551051.945314] BTRFS warning (device dm-2): checksum error at logical 470069477376 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286656: metadata leaf (level 0) in tree 985
> [551051.945318] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 8, gen 0
> [551052.112245] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286752: metadata leaf (level 0) in tree 985
> [551052.112247] BTRFS warning (device dm-2): checksum error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286752: metadata leaf (level 0) in tree 985
> [551052.112248] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 9, gen 0
> [551052.183671] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069477376 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551052.253278] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069526528 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> [551052.260305] BTRFS warning (device dm-2): checksum error at logical 470069493760 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286688: metadata leaf (level 0) in tree 985
> [551052.260307] BTRFS warning (device dm-2): checksum error at logical 470069493760 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1, sector 943286688: metadata leaf (level 0) in tree 985
> [551052.260308] BTRFS error (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
> [551052.300024] BTRFS error (device dm-2): unable to fixup (regular) error at logical 470069493760 on dev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
This is an online backup partition and I have an offline backup partition with the same data, so not very concerned about loosing any data here, but would like to repair it.

Are there any better options before resorting to `btrfsck --repair`? Maybe I can find snapshot that contains file with wrong checksum and remove corresponding snapshot or something like that?

> nazar-pc@nazar-pc ~> sudo btrfs filesystem show /media/Backup
> Label: 'Backup'  uuid: 82cfcb0f-0b80-4764-bed6-f529f2030ac5
>     Total devices 1 FS bytes used 896.20GiB
>     devid    1 size 1.00TiB used 920.09GiB path /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
>
> nazar-pc@nazar-pc ~> sudo btrfs filesystem df /media/Backup
> Data, single: total=879.01GiB, used=877.24GiB
> System, DUP: total=40.00MiB, used=128.00KiB
> Metadata, DUP: total=20.50GiB, used=18.96GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> nazar-pc@nazar-pc ~> btrfs --version
> btrfs-progs v4.13.3
>
> nazar-pc@nazar-pc ~> uname -a
> Linux nazar-pc 4.13.0-16-generic #19-Ubuntu SMP Wed Oct 11 18:35:14 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

-- 
Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

