From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: cant mount degraded (it worked in kernel 2.6.38.8)
Date: Tue, 16 Aug 2011 11:25:36 +0800
Message-ID: <4E49E330.6060402@cn.fujitsu.com>
References: <CAJ1PRSnLKGkmbx3EY=DdSvont_3hUTmSzmmXpL4gi4Aw0KY4pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com" <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSnLKGkmbx3EY=DdSvont_3hUTmSzmmXpL4gi4Aw0KY4pQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

krzf83@gmail.com wrote:
> # uname -a
> Linux dhcppc1 3.0.1-xxxx-std-ipv6-64 #1 SMP Sun Aug 14 17:06:21 CEST
> 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> mkdir test5
> cd test5
> dd if=/dev/null of=img5 bs=1 seek=2G
> dd if=/dev/null of=img6 bs=1 seek=2G
> losetup /dev/loop2 img5
> losetup /dev/loop3 img6
> mkfs.btrfs -d raid1 -m raid1 /dev/loop2 /dev/loop3
> btrfs device scan
> btrfs filesystem show
> 
> Label: none  uuid: d7ba6c4e-04ed-49f5-88cd-8432c948e822
>         Total devices 2 FS bytes used 28.00KB
>         devid    1 size 2.00GB used 437.50MB path /dev/loop4
>         devid    2 size 2.00GB used 417.50MB path /dev/loop5
> 
> mkdir dir
> mount -t btrfs /dev/loop2 dir
> umount dir
> losetup -d /dev/loop3
> mount -t btrfs -o degraded /dev/loop2 dir
> 
> mount: wrong fs type, bad option, bad superblock on /dev/loop2,
>        missing codepage or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

It works on latest kernel (3.1.0-rc2)

--
Li Zefan
