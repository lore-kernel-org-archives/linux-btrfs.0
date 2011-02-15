From: Bert Wesarg <bert.wesarg@googlemail.com>
Subject: Excluding a device from storing snapshot data?
Date: Tue, 15 Feb 2011 23:58:37 +0100
Message-ID: <AANLkTik1u=zWwqMXT7tAqkwhY5Z0U2k8YjQBJx_VjSXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm currently envision a backup setup for my laptop which has a SSD. I
would like to use an external HDD und span a raid1 over these two
devices and also creating snapshots. What I would like to prevent, is
that these snapshots take storage space on the SSD, because SSD
storage is precious, while this isn't true for the external HDD. So I
would need to exclude the SSD device to store snapshot data, or to be
more precise, to store only one specific subvolume. Which can
obviously be changing, if I need to restore a previous snapshot. Is
this currently or actually possible?

Thanks.

Bert
