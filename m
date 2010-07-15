From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [BUG] btrfs hangup when we run the "sync" command
Date: Thu, 15 Jul 2010 11:18:51 +0800
Message-ID: <4C3E7E1B.5000002@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Yan Zheng <zheng.yan@oracle.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, everyone

I found btrfs will hangup when we run the sync command on my
x86_64 box. 

The reproduce steps is following:
# mkfs.btrfs -s 8192 -l 8192 -n 8192 /dev/sda1
# mount /dev/sda1 /mnt
# echo 1234567 > /mnt/aaa
# sync
(btrfs hangs up)

It seems that the btrfs doesn't support the sectorsize which is
greater than the page size just like ext2/3/4, though we can use
mkfs.btrfs to make a filesystem with a big sectorsize. Am I right?

If yes, we must do more check in the mkfs.btrfs.

Thanks
Miao Xie
