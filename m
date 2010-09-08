From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: btrfs on LVM: Out of space
Date: Wed, 8 Sep 2010 22:53:39 +0800
Message-ID: <AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Marcel Lohmann <marcel.lohmann@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Have you ever tried with 'mkfs.btrfs -m single /dev/xxxx'?
As you had a RAID1 based on LVM, you don't have to keep
the default duplicated metadata profile in Btrfs.

-zyh

2010/9/8 Marcel Lohmann <marcel.lohmann@googlemail.com>:
> Hi,
>
> I'm really new to btrfs and wanted to give it a try. But now I have
> some strange behavior with a "full disk". My setup is currently as
> follows:
> An LVM volume group that is configured as RAID1. In that there is a
> logical volume of 130 GB in size. So physically 2x130 GB as of RAID 1=
,
> but logically you can use 130 GB.
> In that complete logical volume I created a btrfs partition. And
> btrfs-show displays 130GB space. Fine.
> Then I started to fill that volume with thousands of files until it
> was unexpectedly "full". But I am sure that there is far less than
> 130GB in files! Now btrfs-show says that I used 130GB of 130GB, while
> df -h shows 38GB of free space. And as I know, df -h has problems to
> determine the real space. So I used "btrfs filesystem df /mountpoint"
> to give me the actual numbers. And that tells me:
> Data: total=3D23.97GB, used=3D23.97GB
> Metadata: total=3D53.01GB, used=3D33.98GB
> System: total=3D12.00MB, used=3D16.00KB
> So what does that mean? I have 130GB disk capacity and I can only use
> 1/5 of that for real data? That can't be true. Even if there is a
> problem with the RAID recognition (but RAID should be invisible for
> btrfs) then I would have 65GB of "available" space, but btrfs
> currently uses 77GB already.
>
> What did I do wrong, or how can I solve that? The kernel is the
> "official" 2.6.35-20-server that ships with Ubuntu 10.10 beta. With
> Ubuntu 10.04 I had the same problem, but there was no "btrfs" command
> and the buggy "df -h" so I thought the new kernel would solve the
> problem. But it does not solve it.
>
> Marcel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
