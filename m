From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Can we set sectorsize to any number greater than pagesize
Date: Fri, 25 Jun 2010 17:38:34 +0800
Message-ID: <4C24791A.3070908@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, everyone!

mkfs.btrfs just does the following check for sectorsize when we use it to make
a btrfs.
  sectorsize = max(sectorsize, (u32)getpagesize());

Does that mean we can set sectorsize to any number greater than pagesize?
If not, I think we should do more check for sectorsize in mkfs.btrfs.

