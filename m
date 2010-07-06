From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Subject: dumpe2fs -h ./test.img or xfs_db -c 'freesp -m binmult' ./test.img
 analog
Date: Tue, 06 Jul 2010 17:19:34 +0400
Message-ID: <1278422374.6236.47.camel@work.selfip.ru>
Reply-To: v.tolstov@selfip.ru
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I'm new with btrfs, i have loop image file with btrfs on it.
If i use ext3 or xfs i can get free blocks by 
dumpe2fs -h ./test.img or 
xfs_db -c 'freesp -m binmult' ./test.img analog
commands

How can i check free blocks in btrfs image file?

-- 
Vasiliy G Tolstov <v.tolstov@selfip.ru>
Selfip.Ru

