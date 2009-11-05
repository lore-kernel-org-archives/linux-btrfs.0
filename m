From: miyamoto moesasji <miyamoto.31b@gmail.com>
Subject: Re: Unexpected ENOSPC on a SSD-drive after day of uptime, =?utf-8?b?a2VybmVsCTIuNi4zMi1yYzU=?=
Date: Thu, 5 Nov 2009 20:55:12 +0000 (UTC)
Message-ID: <loom.20091105T214826-537@post.gmane.org>
References: <fe72f2c80911051238y299bab12g5f4b878851a25f13@mail.gmail.com> <20091105210234.GD22737@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


> Hmm looks like quite a bit of your fs got taken up for metadata.  Perhaps try
> running btrfsctl -b /usr and see if that frees up some space for you. 
Thanks,

1) The btrfsctl does not have the -b option on my system, is that an option
that only is only enabled with the debug-utilities?

2) I would find it surprising if it is meta-data just looking at the numbers.
Below is the output of btrfs-show for all partitions with btrfs.

Label: none  uuid: a12ac0e9-cbea-4acf-bb26-181146940714
        Total devices 1 FS bytes used 89.53MB
        devid    1 size 8.00GB used 5.63GB path /dev/sda5

Label: none  uuid: 59997df9-c5a3-431f-b0a0-95b9e3b1afff
        Total devices 1 FS bytes used 150.14MB
        devid    1 size 4.00GB used 2.04GB path /dev/sda2

Label: none  uuid: 558766bb-5e0d-48dd-9a13-7117f3047710
        Total devices 1 FS bytes used 180.94MB
        devid    1 size 20.00GB used 5.04GB path /dev/sda6

Label: none  uuid: 0a89100d-096d-4c67-b3c7-745c9b7c3dc5
        Total devices 1 FS bytes used 10.60GB
        devid    1 size 20.00GB used 20.00GB path /dev/sda3

Label: none  uuid: 3cac73e5-e998-49bf-b8ee-ba953c92bc0b
        Total devices 1 FS bytes used 28.00KB
        devid    1 size 32.00GB used 2.04GB path /dev/sdb2

As an example the /var (dev/sda5) has only 89MB in use, while btrfs-show
demonstrates 5.63GB being used of the 8GB. It almost looks as if files that are
overwritten don't get removed from the space being in use. 




