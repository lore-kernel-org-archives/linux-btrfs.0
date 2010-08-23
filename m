From: Amr El-Sharnoby <a.elsharnoby@exa.com.sa>
Subject: du and find is much slower on btrfs than ext4
Date: Mon, 23 Aug 2010 16:02:14 +0200
Message-ID: <AANLkTikzPBYZEt_q5HUGUf1LM4ihQkA67ERoQ3ZAo8sr@mail.gmail.com>
References: <AANLkTintDx=zT7wARJ0UzchamAjfkZ3fcDyR5+-zYCes@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTintDx=zT7wARJ0UzchamAjfkZ3fcDyR5+-zYCes@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I've noticed that running "du -sch" on a btrfs takes much longer that
it on ext4 filesystem have the exact same copy of data ...
Also, running "find -type f" for example is much slower on btrfs that ext4 ...

I could reproduce this on;
1- a single 64GB Intel X-25E SSD
2- and on a 6 x 1TB SATA II disks on RAID-0

Notes:
1- Both filesystems have been recently populated with the same copy of data
2- I'm using -o compress for btrfs

Thanks

-- Amr H. El-Sharnoby --
