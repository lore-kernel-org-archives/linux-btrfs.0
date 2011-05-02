From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: btrfs raid health status
Date: Mon, 2 May 2011 15:07:54 +0200
Message-ID: <BANLkTikkK=Y7yZ5u_mH7AQTkV_sd9u0FiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm playing with mkfs.btrfs -m raid1 -d raid1. I put som data there
and now I write random data on one of physical disks directly.

Filesystem and file contents looks fine but I cannot see any errors,
is there any way to see that one disk from raid1 is failing?

Thanks

Roman Kapusta
