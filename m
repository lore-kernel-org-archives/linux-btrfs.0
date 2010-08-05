From: adi <adalbert.buchacz@gmx.de>
Subject: Re: wanted X found X-1 but you got X-2
Date: Thu, 05 Aug 2010 18:04:47 +0200
Message-ID: <4C5AE11F.8060803@gmx.de>
References: <20100729131103.323870@gmx.net> <4C526516.30709@cn.fujitsu.com> <20100730071354.257500@gmx.net> <20100731163424.105410@gmx.net> <4C56199B.8090400@cn.fujitsu.com> <20100802193716.107960@gmx.net> <4C581477.4030907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, liubo2009@cn.fujitsu.com
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C581477.4030907@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

 Hi Miao,

ok, i'll try:

mkfs.ext3 /dev/sdaN
=C2=BBused it as root-file-system quite a while=C2=AB
tune2fs -O extents,uninit_bg,dir_index /dev/sdaN  (converted to ext4)
=C2=BBused it as root file system quite another while=C2=AB
btrfs-convert /dev/sdaN (converted to btrfs)
=C2=BBused it as root filesystem with "-compress" quite another while=C2=
=AB
installed tuxonice-patches on kernel
restart -> still works
suspend-to-disk
and from here on the bug appeared

hope, this helps,
Ciao, Adi


On 03.08.2010 15:07, Miao Xie wrote:
> Hi, Adi
>
> I don't know the detailed reproduce steps.Could you tell us the steps
> just  like this?
> # mkfs.btrfs /dev/sdaN
> # mount /dev/sdaN /mnt
> # dd ......
> # (suspend-to-disk)
> ...
>
> It is very useful for our analysis.
>
> Thanks
> Miao

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
