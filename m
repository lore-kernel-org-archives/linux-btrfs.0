Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57348 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL3Vin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 16:38:43 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 3100E41C43
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 22:38:40 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rNN0bU_hcLMu for <linux-btrfs@vger.kernel.org>;
	Tue, 30 Dec 2014 22:38:38 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 22:38:38 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 30 Dec 2014 22:38:38 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs progs release 3.18
Message-ID: <09d8530e73aed4552f1b3a6297c20360@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> * filesystem usage - give an overview of fs usage in a way (道, みち, 
> michi) that's more
> * device usage - more detailed information about per-device allocations
>   * same restrictions as for 'fi usage'

Interesting.

Used these to create a filesystem, with btrfs-progs v3.17.3:

# mkfs.btrfs -O skinny-metadata -d raid1 -m raid1 /dev/sda4 /dev/sdb4 -f


Now, with btrfs-progs 3.18 and these new options I can see that the fs 
is partially single, not RAID-1 - how come?

# btrfs fil us /srv
Overall:
     Device size:                   5.25TiB
     Device allocated:            510.04GiB
     Device unallocated:            4.76TiB
     Used:                        505.39GiB
     Free (estimated):              2.38TiB      (min: 2.38TiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:8.00MiB, Used:0.00B
    /dev/sda4       8.00MiB

Data,RAID1: Size:252.00GiB, Used:250.56GiB
    /dev/sda4     252.00GiB
    /dev/sdb4     252.00GiB

Metadata,single: Size:8.00MiB, Used:0.00B
    /dev/sda4       8.00MiB

Metadata,RAID1: Size:3.00GiB, Used:2.13GiB
    /dev/sda4       3.00GiB
    /dev/sdb4       3.00GiB

System,single: Size:4.00MiB, Used:0.00B
    /dev/sda4       4.00MiB

System,RAID1: Size:8.00MiB, Used:64.00KiB
    /dev/sda4       8.00MiB
    /dev/sdb4       8.00MiB

Unallocated:
    /dev/sda4       2.38TiB
    /dev/sdb4       2.38TiB


root@backup01 ~ # btrfs dev us /srv
/dev/sda4, ID: 1
    Device size:             2.63TiB
    Data,single:             8.00MiB
    Data,RAID1:            252.00GiB
    Metadata,single:         8.00MiB
    Metadata,RAID1:          3.00GiB
    System,single:           4.00MiB
    System,RAID1:            8.00MiB
    Unallocated:             2.38TiB

/dev/sdb4, ID: 2
    Device size:             2.63TiB
    Data,RAID1:            252.00GiB
    Metadata,RAID1:          3.00GiB
    System,RAID1:            8.00MiB
    Unallocated:             2.38TiB


-- 
Tomasz Chmielewski
http://www.sslrack.com

