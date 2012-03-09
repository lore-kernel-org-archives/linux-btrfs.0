From: Daniel J Blueman <daniel@quora.org>
Subject: btrfs_search_slot BUG...
Date: Fri, 9 Mar 2012 12:25:24 +0800
Message-ID: <CAMVG2suFfpjC_n8SpaDRLAZpWGFAPdoT+ESOkrNuoH0WoH8juQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When testing out 16KB blocks with direct I/O [1] on 3.3-rc6, we
quickly see btrfs_search_slot returning positive numbers, popping an
assertion [2].

Are >4KB block sizes known broken for now?

Thanks,
  Daniel

--- [1]

mkfs.btrfs -m raid1 -d raid1 -l 16k -n 16k /dev/sda /dev/sdb
mount /dev/sda /store && cd /store
fio /usr/share/doc/fio/examples/iometer-file-access-server

--- [2]

kernel BUG at /home/apw/COD/linux/fs/btrfs/extent-tree.c:1481!
-- 
Daniel J Blueman
