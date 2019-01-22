Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11F7C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 15:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878EE20879
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 15:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="ZOW8DbLZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfAVPKH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:10:07 -0500
Received: from mail.virtall.com ([46.4.129.203]:36932 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728959AbfAVPKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 10:10:07 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id E838758D5AF
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1548169804;
        bh=f5upkb1Nq096W0nAWRp3u6b/mjIgk4aS6yqh+XV+oUk=;
        h=Date:From:To:Subject;
        b=ZOW8DbLZSHlxz/XacuMXD9x6XIEFGgLi64oIdWyuDAlIsO6XqCEhsheuJrGCtTtm+
         FoQOpchjrLc9rPXgf4FFduAKbiCWdLmAV+vGta/C0win/FldcMTZ9T82rfG5XvjOty
         A92dMPLClGqbmwCgolLWGmqBEdeFaOczvIk1s8x+4y/LFiMRAlglzDeyBc6Svl1J6z
         BVVpv0/FQGrCQR7KEWHpIgDXJiZ2eBRXo8yY+B42dKjQgD1O9Ksya7Y/6Kgn79CzVr
         BFB/3ZbsNWbhUryurfdbUP5FdD4AgwqaeI9mRLe6SPnRufKG3ffhMyIe1UifhzWqPH
         TLFrK6aSoLAcg==
X-Fuglu-Suspect: 4feb3ddb409c4826b657503f0c3a6810
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 15:10:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Jan 2019 00:09:58 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     linux-btrfs@vger.kernel.org
Subject: 2 enospc errors during balance, with some 20+ TB free space
Message-ID: <24531c3802606e0a3bdfc4737697dcb1@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Tried to run metadata-only balance a btrfs filesystem with RAID-10 
metadata to RAID-1 metadata, it failed with "No space left on device".
Seriously, 20 TB of free disk space is not enough to convert some 25 GB 
of metadata to a different format? O_o

Kernel is 4.18.20.


# time btrfs balance start -mconvert=raid1 /data
ERROR: error during balancing '/data': No space left on device
There may be more info in syslog - try dmesg | tail

real    663m37.901s
user    0m0.000s
sys     6m36.804s


In dmesg:

[4020028.680326] BTRFS info (device sda2): found 62605 extents
[4020093.430147] BTRFS info (device sda2): relocating block group 
4778521264128 flags system|raid10
[4020286.363882] BTRFS info (device sda2): found 35 extents
[4020292.904640] BTRFS info (device sda2): 2 enospc errors during 
balance


# btrfs fi usage /data
WARNING: RAID56 detected, not implemented
Overall:
     Device size:                  35.80TiB
     Device allocated:             48.06GiB
     Device unallocated:           35.75TiB
     Device missing:                  0.00B
     Used:                         33.61GiB
     Free (estimated):                0.00B      (min: 8.00EiB)
     Data ratio:                       0.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID5: Size:6.71TiB, Used:6.33TiB
    /dev/sda2       2.24TiB
    /dev/sdb2       2.24TiB
    /dev/sdc2       2.24TiB
    /dev/sdd2       2.24TiB

Metadata,RAID1: Size:22.00GiB, Used:14.92GiB
    /dev/sda2      11.00GiB
    /dev/sdb2      11.00GiB
    /dev/sdc2      11.00GiB
    /dev/sdd2      11.00GiB

Metadata,RAID10: Size:2.00GiB, Used:1.88GiB
    /dev/sda2       1.00GiB
    /dev/sdb2       1.00GiB
    /dev/sdc2       1.00GiB
    /dev/sdd2       1.00GiB

System,RAID1: Size:32.00MiB, Used:592.00KiB
    /dev/sdb2      32.00MiB
    /dev/sdc2      32.00MiB

Unallocated:
    /dev/sda2       6.70TiB
    /dev/sdb2       6.70TiB
    /dev/sdc2       6.70TiB
    /dev/sdd2       6.70TiB


# df -h /data
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        36T  6.4T   28T  19% /data
