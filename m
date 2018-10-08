Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6DAC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 13:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE69120652
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 13:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE69120652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=couderc.eu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbeJHVBq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:01:46 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:53748 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbeJHVBq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 17:01:46 -0400
Received: from mail.tol.fr (unknown [IPv6:2a01:e34:eeaf:c5f0:428d:5cff:fee6:854e])
        by smtp2-g21.free.fr (Postfix) with ESMTP id 99C812003ED
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 15:49:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.tol.fr (Postfix) with ESMTP id 34EE197805FC
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 15:49:55 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at sos.couderc.eu
Received: from mail.tol.fr ([127.0.0.1])
        by localhost (sos.couderc.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qwlqhMzDbHtY for <linux-btrfs@vger.kernel.org>;
        Mon,  8 Oct 2018 15:49:54 +0200 (CEST)
Received: from [192.168.163.11] (unknown [192.168.163.254])
        by mail.tol.fr (Postfix) with ESMTPSA id 9B0AA9780522
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 15:49:54 +0200 (CEST)
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Pierre Couderc <pierre@couderc.eu>
Subject: Which device is missing ?
Message-ID: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
Date:   Mon, 8 Oct 2018 15:49:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I ma trying to make a "RAID1" with /dev/sda2 ans /dev/sdb (or similar).

But I have stranges status or errors  about "missing devices" and I do 
not understand the current situation :


root@server:~# btrfs fi show
Label: none  uuid: 28c2b7ab-631c-40a3-bab7-00dac5dd20eb
         Total devices 1 FS bytes used 190.91GiB
         devid    1 size 1.82TiB used 196.02GiB path /dev/sda2

warning, device 1 is missing
Label: none  uuid: 2d45149a-fb97-4c2a-bae2-4cfe4e01a8aa
         Total devices 2 FS bytes used 116.18GiB
         devid    2 size 1.82TiB used 118.03GiB path /dev/sdb
         *** Some devices missing

root@server:~# fdisk -l
Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: CFF97102-D6B5-4126-B2B4-FA735598D1F0

Device       Start        End    Sectors  Size Type
/dev/sda1     2048    1050623    1048576  512M EFI System
/dev/sda2  1050624 3907026943 3905976320  1.8T Linux filesystem


Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


root@server:~# btrfs fi usage /
Overall:
     Device size:                   1.82TiB
     Device allocated:            196.02GiB
     Device unallocated:            1.63TiB
     Device missing:                  0.00B
     Used:                        191.84GiB
     Free (estimated):              1.63TiB      (min: 835.27GiB)
     Data ratio:                       1.00
     Metadata ratio:                   2.00
     Global reserve:              263.64MiB      (used: 0.00B)

Data,single: Size:192.01GiB, Used:189.98GiB
    /dev/sda2     192.01GiB

Metadata,DUP: Size:2.00GiB, Used:951.67MiB
    /dev/sda2       4.00GiB

System,DUP: Size:8.00MiB, Used:48.00KiB
    /dev/sda2      16.00MiB

Unallocated:
    /dev/sda2       1.63TiB
root@server:~#


