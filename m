From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: Mounting multiple regular files as a filesystem
Date: Mon, 15 Jun 2009 15:48:56 +0800
Message-ID: <3d0408630906150048r4f93a02cud633f78da46f0b02@mail.gmail.com>
References: <4A35DDD6.9020307@p-static.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Ravi Pinjala <ravi@p-static.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A35DDD6.9020307@p-static.net>
List-ID: <linux-btrfs.vger.kernel.org>

2009/6/15 Ravi Pinjala <ravi@p-static.net>:
> I'm trying to create a multi-device filesystem on top of regular files
> (not actual disks), and mount that to a loopback device. For a
> filesystem created on a single file, it works fine, but for a filesystem
> across multiple files, it doesn't.
>
>
>
> dd if=/dev/zero of=img1 bs=4096 count=65536
> dd if=/dev/zero of=img2 bs=4096 count=65536
> dd if=/dev/zero of=img3 bs=4096 count=65536
> dd if=/dev/zero of=img4 bs=4096 count=65536
>
> mkfs.btrfs img1
> mount -o loop -t btrfs img1 /mnt/test # works
>
> mkfs.btrfs img1 img2 img3 img4
> mount -o loop -t btrfs img1 /mnt/test # fails
>
>

Please setup loop devices for the image files manually. In this case,
'mount -o loop' can't do it for you.

For example:
mkfs.btrfs img1 img2 img3 img4
for i in `seq 1 4`; do losetup /dev/loop$ img$i; done
btrfsctl -a
mount -t btrfs /dev/loop1 /mnt/test

See below for more information:
http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

Yan, Zheng
