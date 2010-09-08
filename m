From: Marcel Lohmann <marcel.lohmann@googlemail.com>
Subject: btrfs on LVM: Out of space
Date: Wed, 8 Sep 2010 13:18:51 +0200
Message-ID: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm really new to btrfs and wanted to give it a try. But now I have
some strange behavior with a "full disk". My setup is currently as
follows:
An LVM volume group that is configured as RAID1. In that there is a
logical volume of 130 GB in size. So physically 2x130 GB as of RAID 1,
but logically you can use 130 GB.
In that complete logical volume I created a btrfs partition. And
btrfs-show displays 130GB space. Fine.
Then I started to fill that volume with thousands of files until it
was unexpectedly "full". But I am sure that there is far less than
130GB in files! Now btrfs-show says that I used 130GB of 130GB, while
df -h shows 38GB of free space. And as I know, df -h has problems to
determine the real space. So I used "btrfs filesystem df /mountpoint"
to give me the actual numbers. And that tells me:
Data: total=23.97GB, used=23.97GB
Metadata: total=53.01GB, used=33.98GB
System: total=12.00MB, used=16.00KB
So what does that mean? I have 130GB disk capacity and I can only use
1/5 of that for real data? That can't be true. Even if there is a
problem with the RAID recognition (but RAID should be invisible for
btrfs) then I would have 65GB of "available" space, but btrfs
currently uses 77GB already.

What did I do wrong, or how can I solve that? The kernel is the
"official" 2.6.35-20-server that ships with Ubuntu 10.10 beta. With
Ubuntu 10.04 I had the same problem, but there was no "btrfs" command
and the buggy "df -h" so I thought the new kernel would solve the
problem. But it does not solve it.

Marcel
