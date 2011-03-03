From: Miao Xie <miaox@cn.fujitsu.com>
Subject: About btrfs chunk tree backups
Date: Thu, 03 Mar 2011 17:01:00 +0800
Message-ID: <4D6F58CC.9030003@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris and Josef

Recently, I am interested in chunk tree backups, which is described in
Project ideas web. But I found it is hard to be implemented.

The description said "make the mappings discoverable via a block device
scan so that we can recover from corrupted chunk trees", I think it is
hard to find the boundary of each stripe, which is the constituent of
the chunks, via a block device scan according to the current on-disk data
structures. And besides that, even though we find the stripes of each
chunks, we still don't know the order of the stripes in one chunk. So
I think chunk tree backups is hard to be implemented.

Maybe I made some mistakes in understanding this project idea?

Thanks
Miao

