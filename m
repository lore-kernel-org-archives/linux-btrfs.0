From: "Helmut Hullen" <Hullen@t-online.de>
Subject: device delete: more informations
Date: 05 Aug 2011 07:30:00 +0200
Message-ID: <BrHfkPBD1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I've made a 2-partitions system with

        mkfs.btrfs -P Probe -m raid1 -d raid0 /dev/sdb1

        mount LABEL=Probe /mnt/Probe

        btrfs device add /dev/sdb2 /mnt/Probe

"btrfs-show" (and other tests) showed that all worked well.

        btrfs device delete /dev/sdb2 /mnt/Probe

only showed "error" (I haven't noticed the long text, something like  
"can't delete"); but "dmesg" showed the reason:

  btrfs: unable to go below two devices on raid1

Could this message also shown in the "regular" error message?

Viele Gruesse!
Helmut
