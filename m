Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB50C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 11:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF6E20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 11:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hshp9ZFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbfBNL7L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 06:59:11 -0500
Received: from mail-it1-f171.google.com ([209.85.166.171]:37958 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfBNL7K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 06:59:10 -0500
Received: by mail-it1-f171.google.com with SMTP id l66so3617124itg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 03:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2jaJLWKfVq3f0whhAlway/LI3B39hQnDiKs0sJnXCdA=;
        b=hshp9ZFhoe4a9+PncPdpN3FsS2vc1aTovWF08P6KwrStLOAqaxc9vKNKgBpxgVRxh7
         oe/53BXjKUj16OJSTI8dITEXDR5aZ6BcXfnE5PlRka5dPm8fOuCG+8fH+68PPCkt3El2
         Aq62OXAxUtjymd0C8qO94g2V6Qc3C5TISJl7dxDVFiuyKC/0dxCITgM33UwiMiQf08Fy
         Z8GRQO4iEYOhEme08uj+sEDCOnSor/r0OxBuO8UtoxDyoV20UlnUdUqr9lwk8e2Ut2kC
         kRJPizfO1GmsOdhFLDMgD3+VVnlb08YzpTncYm23JL63Bnh3CTMWu0JO3iM8dpD5yeuy
         xmTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2jaJLWKfVq3f0whhAlway/LI3B39hQnDiKs0sJnXCdA=;
        b=YZX0ejhMXmqLsCx0ShY+ZTShs/kIyboluJCwysitx1uNj5AHv18NKQH+glM0IOIseD
         Uv2dXH7DLlfUjzAVpP/g7ktPjsTNJ6F9caD50J8+29jWk7T1P3cO3nhy8BXpAiZT+uNj
         jxItmFe/oyHelUD/ivKONWXBPFHwNpdEV3MVWQ72ZJyG2dIEa0amWczMeLneLljrKADA
         J+QRpyh314LTFGx1p0dy2VJBOu7xJNotrnWbl4Ow/WkPZs18MQvz7KFNg4o0Z6GV8BDL
         vGseqne7+6ov684LGpAWkCc91baSy+M8U1s3Z+mQ9yGpEjPmfMwfuvsuqMiS7tBqOCUS
         sgMg==
X-Gm-Message-State: AHQUAuZniYehIeIK36pMtbI4vewE8AvIFUCh/q541x296YpNm3QdtNSW
        7TUN9YdbyQao7NLuV3GcsXd9TUUBX4Ib9dTREnFd2LPA
X-Google-Smtp-Source: AHgI3IZgj9GVE8/k6vhCZKsDvPc/7j6iduUUq8QYV9TJjZ+RY63con0hROXQ61ezdUEg/sN0N821KQzM4dlAsip2tSE=
X-Received: by 2002:a24:9a01:: with SMTP id l1mr1691152ite.113.1550145549985;
 Thu, 14 Feb 2019 03:59:09 -0800 (PST)
MIME-Version: 1.0
From:   Jesper Utoft <jesper.utoft@gmail.com>
Date:   Thu, 14 Feb 2019 12:58:57 +0100
Message-ID: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>
Subject: corrupt leaf: root=1 block=57567265079296 slot=83, bad key order
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello Fellow BTRFS users.

I have run into the bad key order issue.
corrupt leaf: root=1 block=57567265079296 slot=83, bad key order, prev
(18446744073709551605 0 57707594776576) current (18446726481523507189
0 57709742260224)
The lines repeats over and over..

I read a thread between Hugo Mills and Eric Wolf about a similar issue
and i have gathered the same info.

I understand that it probably is hardware related, i have been running
memtest for 60h+ to see if i could reproduce it.
I also tried to run btrfs check --recover but it did not help.

My questions is if it can be fixed? It looks like that all surrounding
blocks are empty space nodes, so could i reset the empty space using
mount option clear_cache?
If i have to copy the files out, can i then use btrfs send-recive or
should i copy the files using the ordinary cp command?
I hope you can help me, thanks in advance. Below is log snippets etc
that i hope can help with the debugging.

Failing OS: Ubuntu 16.04.5 LTS with the latest updates.

The rest is done from a liveOS Ubuntu 18.10.
Details:
ubuntu@ubuntu:/isodevice$ sudo uname -a
Linux ubuntu 4.18.0-10-generic #11-Ubuntu SMP Thu Oct 11 15:13:55 UTC
2018 x86_64 x86_64 x86_64 GNU/Linux
ubuntu@ubuntu:/isodevice$ sudo btrfs --version
btrfs-progs v4.16.1
ubuntu@ubuntu:/isodevice$ sudo btrfs fi show
Label: none  uuid: 90900a21-8a71-4301-b5c2-21dea31f1132
    Total devices 4 FS bytes used 6.61TiB
    devid    1 size 2.72TiB used 2.30TiB path /dev/sdc4
    devid    2 size 2.72TiB used 2.30TiB path /dev/sde4
    devid    3 size 2.72TiB used 2.30TiB path /dev/sda4
    devid    4 size 5.45TiB used 4.96TiB path /dev/sdb1

ubuntu@ubuntu:/isodevice$ btrfs fi df /mnt
Data, RAID1: total=4.36TiB, used=4.35TiB
Data, RAID5: total=2.25TiB, used=2.23TiB
System, RAID1: total=64.00MiB, used=832.00KiB
Metadata, RAID1: total=33.00GiB, used=31.43GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

DMESG:
[  451.381275] BTRFS info (device sdc4): disk space caching is enabled
[  451.531224] BTRFS info (device sdc4): bdev /dev/sdc4 errs: wr 0, rd
0, flush 0, corrupt 0, gen 19
[  451.531239] BTRFS info (device sdc4): bdev /dev/sde4 errs: wr 0, rd
0, flush 0, corrupt 0, gen 3
[  451.531249] BTRFS info (device sdc4): bdev /dev/sda4 errs: wr 0, rd
15, flush 0, corrupt 0, gen 16
[  493.187544] BTRFS info (device sdc4): checking UUID tree
[  550.070483] BTRFS critical (device sdc4): corrupt leaf: root=1
block=57567265079296 slot=83, bad key order, prev
(18446744073709551605 0 57707594776576) current (18446726481523507189
0 57709742260224)
[  550.070569] BTRFS warning (device sdc4): btrfs_uuid_scan_kthread failed -5

Debug info:
sudo btrfs inspect-internal dump-tree -b 57567265079296 --follow /dev/sda4
btrfs-progs v4.16.1
leaf 57567265079296 items 246 free space 47 generation 7325984 owner ROOT_TREE
leaf 57567265079296 flags 0x1(WRITTEN) backref revision 1
fs uuid 90900a21-8a71-4301-b5c2-21dea31f1132
chunk uuid b3eed334-68af-43e6-ae1e-c05e504f30cf
    item 0 key (FREE_SPACE UNTYPED 57557270921216) itemoff 16242 itemsize 41
        location key (74274 INODE_ITEM 0)
        cache generation 7325984 entries 308 bitmaps 8
    item 1 key (FREE_SPACE UNTYPED 57558344663040) itemoff 16201 itemsize 41
        location key (74275 INODE_ITEM 0)
        cache generation 7325984 entries 338 bitmaps 8
... [snip] ...
    item 81 key (FREE_SPACE UNTYPED 57705447292928) itemoff 12921 itemsize 41
        location key (74392 INODE_ITEM 0)
        cache generation 2530576 entries 0 bitmaps 0
    item 82 key (FREE_SPACE UNTYPED 57707594776576) itemoff 12880 itemsize 41
        location key (74393 INODE_ITEM 0)
        cache generation 2530576 entries 0 bitmaps 0
    item 83 key (18446726481523507189 UNKNOWN.0 57709742260224)
itemoff 12839 itemsize 41
    item 84 key (FREE_SPACE UNTYPED 57711889743872) itemoff 12798 itemsize 41
        location key (74395 INODE_ITEM 0)
        cache generation 2530576 entries 0 bitmaps 0
    item 85 key (FREE_SPACE UNTYPED 57714037227520) itemoff 12757 itemsize 41
        location key (74396 INODE_ITEM 0)
        cache generation 5542000 entries 0 bitmaps 0
... [snip] ...

If i read the block for slot 83 and also 82 and 84 i get:
ubuntu@ubuntu:/isodevice$ sudo btrfs inspect-internal dump-tree -b
57709742260224 --follow /dev/sda4
btrfs-progs v4.16.1
checksum verify failed on 57709742260224 found 957DA941 wanted 46464952
checksum verify failed on 57709742260224 found 957DA941 wanted 46464952
checksum verify failed on 57709742260224 found 1A43BFC8 wanted F8AC1E60
checksum verify failed on 57709742260224 found 1A43BFC8 wanted F8AC1E60
bytenr mismatch, want=57709742260224, have=41175219756947292
ERROR: failed to read 57709742260224
ubuntu@ubuntu:/isodevice$ sudo btrfs inspect-internal dump-tree -b
57711889743872 --follow /dev/sda4
btrfs-progs v4.16.1
checksum verify failed on 57711889743872 found 7C7F3E7E wanted D95F6073
checksum verify failed on 57711889743872 found 7C7F3E7E wanted D95F6073
checksum verify failed on 57711889743872 found 15984D09 wanted 72B7E0E4
checksum verify failed on 57711889743872 found 7C7F3E7E wanted D95F6073
bytenr mismatch, want=57711889743872, have=3894064465997382214
ERROR: failed to read 57711889743872
ubuntu@ubuntu:/isodevice$ sudo btrfs inspect-internal dump-tree -b
57707594776576 --follow /dev/sda4
btrfs-progs v4.16.1
checksum verify failed on 57707594776576 found FD8DDF70 wanted B48A9029
checksum verify failed on 57707594776576 found FD8DDF70 wanted B48A9029
checksum verify failed on 57707594776576 found F7A75766 wanted 563355DA
checksum verify failed on 57707594776576 found F7A75766 wanted 563355DA
bytenr mismatch, want=57707594776576, have=14084120062297221284
ERROR: failed to read 57707594776576
