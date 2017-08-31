Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:59400 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751080AbdHaMQX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 08:16:23 -0400
Date: Thu, 31 Aug 2017 17:16:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: mount time for big filesystems
Message-ID: <20170831171621.2605458b@natsu>
In-Reply-To: <d4214656-ec36-4a1e-7c4d-a528c0ae61be@gmail.com>
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
 <20170831163656.6be88191@natsu>
 <d4214656-ec36-4a1e-7c4d-a528c0ae61be@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 31 Aug 2017 07:45:55 -0400
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> If you use dm-cache (what LVM uses), you need to be _VERY_ careful and 
> can't use it safely at all with multi-device volumes because it leaves 
> the underlying block device exposed.

It locks the underlying device so it can't be seen by Btrfs and cause problems.

# btrfs dev scan
Scanning for Btrfs filesystems

# btrfs fi show
Label: none  uuid: 62ff7619-8202-47f6-8c7e-cef6f082530e
	Total devices 1 FS bytes used 112.00KiB
	devid    1 size 16.00GiB used 2.02GiB path /dev/mapper/vg-OriginLV

# ls -la /dev/mapper/
total 0
drwxr-xr-x  2 root root     140 Aug 31 12:01 .
drwxr-xr-x 16 root root    2980 Aug 31 12:01 ..
crw-------  1 root root 10, 236 Aug 31 11:59 control
lrwxrwxrwx  1 root root       7 Aug 31 12:01 vg-CacheDataLV_cdata -> ../dm-1
lrwxrwxrwx  1 root root       7 Aug 31 12:01 vg-CacheDataLV_cmeta -> ../dm-2
lrwxrwxrwx  1 root root       7 Aug 31 12:06 vg-OriginLV -> ../dm-0
lrwxrwxrwx  1 root root       7 Aug 31 12:01 vg-OriginLV_corig -> ../dm-3

# btrfs dev scan /dev/dm-0
Scanning for Btrfs filesystems in '/dev/mapper/vg-OriginLV'

# btrfs dev scan /dev/dm-3
Scanning for Btrfs filesystems in '/dev/mapper/vg-OriginLV_corig'
ERROR: device scan failed on '/dev/mapper/vg-OriginLV_corig': Device or resource busy

-- 
With respect,
Roman
