From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: Re: [BUG] btrfs hangup when we run the "sync" command
Date: Thu, 15 Jul 2010 16:14:31 +0800
Message-ID: <AANLkTinkuiT9tBiALkCIDMs9d9J9FT9sl9GEyRogq09S@mail.gmail.com>
References: <4C3E7E1B.5000002@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C3E7E1B.5000002@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/7/15 Miao Xie <miaox@cn.fujitsu.com>:
> Hi, everyone
>
> I found btrfs will hangup when we run the sync command on my
> x86_64 box.
>
> The reproduce steps is following:
> # mkfs.btrfs -s 8192 -l 8192 -n 8192 /dev/sda1
> # mount /dev/sda1 /mnt
> # echo 1234567 > /mnt/aaa
> # sync
> (btrfs hangs up)
>
> It seems that the btrfs doesn't support the sectorsize which is
> greater than the page size just like ext2/3/4, though we can use
> mkfs.btrfs to make a filesystem with a big sectorsize. Am I right?
>
> If yes, we must do more check in the mkfs.btrfs.
>

yes, btrfs doesn't support the sectorsize > PAGE_size.
