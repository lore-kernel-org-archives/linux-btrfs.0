From: Victor Roetman <victory747@gmail.com>
Subject: btrfs device scan
Date: Thu, 12 May 2011 12:26:05 +0800
Message-ID: <4DCB615D.60300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a couple computers running 2.6.38
(Ubuntu Natty 2.6.38-8-generic), and on both of them
"btrfs device scan" comes back with nothing other than
"failed to read /dev/sr0"

One computer has a btrfs RAID-1 volume, and the other has two separate
btrfs filesystems. The results are the same whether the filesystems are
mounted or not.

Why is "btrfs device scan" not scanning the devices?

vic
