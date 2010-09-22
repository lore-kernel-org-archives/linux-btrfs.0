From: Marko Vendelin <marko.vendelin@gmail.com>
Subject: transforming RAID1 to RAID10
Date: Wed, 22 Sep 2010 09:21:28 +0300
Message-ID: <AANLkTimRXr79O_B=HzPDB_nuuW_wDOUtKCoq5fmcD2mu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Marko Vendelin <marko.vendelin@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dear BTRFS developers,

we would like to extend our FS storage by adding two more harddisks.
At present, BTRFS is using two partitions and running in RAID1 mode. I
would like to add two more harddisks (without partitioning them) as an
additional RAID1 pair to extend the storage. In other words, we would
have RAID1 (/dev/sdb,sdc) extended to RAID10 (sdb-sdc + sdd-sde). Is
it possible and, if it is, how can I do it? We are running Ubuntu
10.04.1 LTS x86_64.

Best,

Marko

PS: I am not subscribed to the list, please CC me.
