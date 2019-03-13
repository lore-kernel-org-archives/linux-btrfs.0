Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCB2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 21:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982712087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 21:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfCMV6i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:58:38 -0400
Received: from europa.tomatom.cz ([87.236.196.214]:56354 "EHLO mail.tomatom.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfCMV6i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 17:58:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.tomatom.cz (Postfix) with ESMTP id 87733128EA9
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 22:00:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.tomatom.cz
Received: from mail.tomatom.cz ([127.0.0.1])
        by localhost (mail.tomatom.cz [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lSjdJW1Aw_D5 for <linux-btrfs@vger.kernel.org>;
        Wed, 13 Mar 2019 22:00:38 +0000 (UTC)
Received: from authenticated-user (mail.tomatom.cz [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jakub@husak.pro)
        by mail.tomatom.cz (Postfix) with ESMTPSA id 71179128CFE
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 22:00:38 +0000 (UTC)
Authentication-Results: mail.tomatom.cz; dmarc=none header.from=husak.pro
Authentication-Results: mail.tomatom.cz; dkim=none reason="no signature";
        dkim-adsp=none (unprotected policy); dkim-atps=neutral
From:   =?UTF-8?Q?Jakub_Hus=c3=a1k?= <jakub@husak.pro>
Subject: Balancing raid5 after adding another disk does not move/use any data
 on it
To:     linux-btrfs@vger.kernel.org
Message-ID: <d5061586-2395-3c92-d7c5-2691307a0fce@husak.pro>
Date:   Wed, 13 Mar 2019 22:58:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I added another disk to my 3-disk raid5 and ran a balance command. After 
few hours I looked to output of `fi usage` to see that no data are being 
used on the new disk. I got the same result even when balancing my raid5 
data or metadata.

Next I tried to convert my raid5 metadata to raid1 (a good idea anyway) 
and the new disk started to fill immediately (even though it received 
the whole amount of metadata with replicas being spread among the other 
drives, instead of being really "balanced". I know why this happened, I 
don't like it but I can live with it, let's not go off topic here :)).

Now my usage output looks like this:

# btrfs filesystem usage /mnt/data WARNING: RAID56 detected, not 
implemented Overall: Device size: 10.91TiB Device allocated: 316.12GiB 
Device unallocated: 10.61TiB Device missing: 0.00B Used: 58.88GiB Free 
(estimated): 0.00B (min: 8.00EiB) Data ratio: 0.00 Metadata ratio: 2.00 
Global reserve: 512.00MiB (used: 184.94MiB) Data,RAID5: Size:4.59TiB, 
Used:4.06TiB /dev/mapper/crypt-sdb 2.29TiB /dev/mapper/crypt-sdc 2.29TiB 
/dev/mapper/crypt-sde 2.29TiB Metadata,RAID1: Size:158.00GiB, 
Used:29.44GiB /dev/mapper/crypt-sdb 53.00GiB /dev/mapper/crypt-sdc 
53.00GiB /dev/mapper/crypt-sdd 158.00GiB /dev/mapper/crypt-sde 52.00GiB 
System,RAID1: Size:64.00MiB, Used:528.00KiB /dev/mapper/crypt-sdc 
32.00MiB /dev/mapper/crypt-sdd 64.00MiB /dev/mapper/crypt-sde 32.00MiB 
Unallocated: /dev/mapper/crypt-sdb 392.04GiB /dev/mapper/crypt-sdc 
392.01GiB /dev/mapper/crypt-sdd 2.57TiB /dev/mapper/crypt-sde 393.01GiB

I'm now running `fi balance -dusage=10` (and rising the usage limit). I 
can see that the unallocated space is rising as it's freeing the little 
used chunks but still no data are being stored on the new disk.

I it some bug? Is `fi usage` not showing me something (as it states 
"WARNING: RAID56 detected, not implemented")? Or is there just too much 
free space on the first set of disks that the balancing is not bothering 
moving any data?

If so, shouldn't it be really balancing (spreading) the data among all 
the drives to use all the IOPS capacity, even when the raid5 redundancy 
constraint is currently satisfied?

# uname -a Linux keeper 4.19.0-0.bpo.2-amd64 #1 SMP Debian 
4.19.16-1~bpo9+1 (2019-02-07) x86_64 GNU/Linux # btrfs --version 
btrfs-progs v4.17 # btrfs fi show Label: none uuid: 
xxxxxxxxxxxxxxxxxxxxxxxxxx Total devices 4 FS bytes used 4.09TiB devid 2 
size 2.73TiB used 2.34TiB path /dev/mapper/crypt-sdc devid 3 size 
2.73TiB used 2.34TiB path /dev/mapper/crypt-sdb devid 4 size 2.73TiB 
used 2.34TiB path /dev/mapper/crypt-sde devid 5 size 2.73TiB used 
158.06GiB path /dev/mapper/crypt-sdd # btrfs fi df . Data, RAID5: 
total=4.59TiB, used=4.06TiB System, RAID1: total=64.00MiB, 
used=528.00KiB Metadata, RAID1: total=158.00GiB, used=29.43GiB 
GlobalReserve, single: total=512.00MiB, used=0.00B

Thanks

Jakub

