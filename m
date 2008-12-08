From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: btrfs: Problem with multi device mounting
Date: Mon, 8 Dec 2008 09:01:11 +0800
Message-ID: <3d0408630812071701w4be6bdc6h806f50600bcd0cf6@mail.gmail.com>
References: <b82a89170812070935p36a2285ft30d475198206f89f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Niraj kumar" <niraj17@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b82a89170812070935p36a2285ft30d475198206f89f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/12/8 Niraj kumar <niraj17@gmail.com>:
> Hi,
>
> This problem happens when mkfs.btrfs has been executed while
> btrfs module was not loaded into the kernel.
>
> I am using the latest commit on btrfs-unstable.
> Commit:
> c99e905c945c462085c6d64646dc5af0c0a16815
>
> Steps to reproduce:
>
> 1) Create a btrfs filesystem while the btrfs module is not yet loaded.
>
> [root@f10-vm1 ~]# uname -a
> Linux f10-vm1 2.6.28-rc5 #9 SMP Thu Dec 4 18:09:37 IST 2008 i686 i686
> i386 GNU/Linux
> [root@f10-vm1 ~]# rmmod btrfs
>
> [root@f10-vm1 ~]# /home/niraj/btrfs/bin/mkfs.btrfs /dev/sdb1 /dev/sdb2
> adding device /dev/sdb2 id 2
> fs created label (null) on /dev/sdb1
>        nodesize 4096 leafsize 4096 sectorsize 4096 size 4.00GB
> Btrfs v0.16-25-gd45ee76
>
> 2) Try to mount it (this automatically loads btrfs module) :
>
> [root@f10-vm1 ~]# mount -t btrfs /dev/sdb1 /f1
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>       missing codepage or helper program, or other error
>       In some cases useful info is found in syslog - try
>       dmesg | tail  or so
>
>
> Here is the relevant dmesg output:
> Btrfs loaded
> device fsid 514ee5004d4b722d-ae7cc1f744a0b49f devid 1 transid 9 /dev/sdb1
> btrfs: failed to read the system array on sdb1
> btrfs: open_ctree failed
>
>
> Let me know if I can provide more information.
>
Please execute 'btrfsctl -a' before mount.

Yan Zheng
