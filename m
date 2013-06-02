Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [212.13.216.74] ([212.13.216.74]:44849 "EHLO mail.39.gs"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab3FBQRP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Jun 2013 12:17:15 -0400
Received: from mail.39.gs (localhost [127.0.0.1])
	by mail.39.gs (Postfix) with ESMTPA id 651298882F
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Jun 2013 17:17:11 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 02 Jun 2013 17:17:11 +0100
From: Tim Eggleston <lists@timeggleston.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: RAID10 total capacity incorrect
Message-ID: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I have a 4-device RAID10 array of 2TB drives on btrfs. It works great. I 
recently added an additional 4 drives to the array. There is only about 
2TB in use across the whole array (which should have an effective 
capacity of about 8TB). However I have noticed that when I issue btrfs 
filesystem df against the mountpoint, in the "total" field, I get the 
same value as the "used" field:

root@mckinley:/# btrfs fi df /mnt/shares/btrfsvol0
Data, RAID10: total=2.06TB, used=2.06TB
System, RAID10: total=64.00MB, used=188.00KB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=3.00GB, used=2.29GB

Here's my btrfs filesystem show:

root@mckinley:/# btrfs fi show
Label: 'btrfsvol0'  uuid: 1a735971-3ad7-4046-b25b-e834a74f2fbb
	Total devices 8 FS bytes used 2.06TB
	devid    7 size 1.82TB used 527.77GB path /dev/sdk1
	devid    8 size 1.82TB used 527.77GB path /dev/sdg1
	devid    6 size 1.82TB used 527.77GB path /dev/sdi1
	devid    5 size 1.82TB used 527.77GB path /dev/sde1
	devid    4 size 1.82TB used 527.77GB path /dev/sdj1
	devid    2 size 1.82TB used 527.77GB path /dev/sdf1
	devid    1 size 1.82TB used 527.77GB path /dev/sdh1
	devid    3 size 1.82TB used 527.77GB path /dev/sdc1

This is running the Ubuntu build of kernel 3.9.4 and btrfs-progs from 
git (v0.20-rc1-324-g650e656).

Am I being an idiot and missing something here? I must admit that I 
still find the df output a bit cryptic (entirely my failure to 
understand, nothing else), but on another system with only a single 
device the "total" field returns the capacity of the device.

Cheers!

  ---tim

