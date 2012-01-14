From: luvar@plaintext.sk
Subject: btrfs on ssd and hdd
Date: Sat, 14 Jan 2012 16:02:23 +0100 (GMT+01:00)
Message-ID: <772574965.1221326553343545.JavaMail.root@shiva>
References: <1289964295.1201326553279203.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289964295.1201326553279203.JavaMail.root@shiva>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I am using for my workspace btrfs filesystem on ssd disk. I do not thrust to my ssd and I want to have backup of all data on rotational hdd (raid5 of 5 disks). If I am not wrong, this can be done when I use btrfs on top of two phycical media (one ssd and second md device). This I think would work fine.

My question is, does btrfs recognize poor latency of md device and will preform most reads from ssd? (I want to set raid1 for metadata and also to data). (side question, should be ssd in parameters of mount?)

PS: Is this crazy idea, or normal (planned) usecase?

Thanks for clarification,
LuVar
