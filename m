Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751096AbdEKATU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 20:19:20 -0400
To: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: qgroup: direct writes returns -EDQUOT too soon
Message-ID: <a82823d1-b034-88bc-f748-9d8440dddf1e@suse.de>
Date: Wed, 10 May 2017 19:19:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Here is a sample script to recreate the issue:
mkfs.btrfs -f /dev/vdb
mount /dev/vdb /mnt
btrfs quota enable /mnt
btrfs sub create /mnt/tmp
btrfs qgroup limit 200M /mnt/tmp
btrfs quota rescan -w /mnt
cd /mnt/tmp
for i in {1..5}; do
	sync
	dd if=/dev/zero of=/mnt/tmp/file-$i oflag=direct
	sync
done

btrfs qgroup show -pcref /mnt/tmp


Output:

Create subvolume '/mnt/tmp'
quota rescan started
dd: writing to '/mnt/tmp/file-1': Disk quota exceeded
11991+0 records in
11990+0 records out
6138880 bytes (6.1 MB, 5.9 MiB) copied, 2.40459 s, 2.6 MB/s
dd: writing to '/mnt/tmp/file-2': Disk quota exceeded
11807+0 records in
11806+0 records out
6044672 bytes (6.0 MB, 5.8 MiB) copied, 2.11256 s, 2.9 MB/s
dd: writing to '/mnt/tmp/file-3': Disk quota exceeded
11628+0 records in
11627+0 records out
5953024 bytes (6.0 MB, 5.7 MiB) copied, 2.53767 s, 2.3 MB/s
dd: writing to '/mnt/tmp/file-4': Disk quota exceeded
11080+0 records in
11079+0 records out
5672448 bytes (5.7 MB, 5.4 MiB) copied, 2.3697 s, 2.4 MB/s
dd: writing to '/mnt/tmp/file-5': Disk quota exceeded
11358+0 records in
11357+0 records out
5814784 bytes (5.8 MB, 5.5 MiB) copied, 2.10354 s, 2.8 MB/s

qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/257        28.84MiB     28.84MiB    200.00MiB         none ---     ---

The files created are only 5-6MB when the subvolume size is 200m. Each
of the attempts, including the first attempt, returns EDQUOT at around
5-6 MB.


-- 
Goldwyn
