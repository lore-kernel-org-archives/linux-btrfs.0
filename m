Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9248 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752113AbcHOCME (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 22:12:04 -0400
Subject: Re: btrfs quota issues
To: Rakesh Sankeshi <rakesh.sankeshi@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fe8222d8-6463-8b4d-0613-b3639455463d@cn.fujitsu.com>
Date: Mon, 15 Aug 2016 10:11:55 +0800
MIME-Version: 1.0
In-Reply-To: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/12/2016 01:32 AM, Rakesh Sankeshi wrote:
> I set 200GB limit to one user and 100GB to another user.
>
> as soon as I reached 139GB and 53GB each, hitting the quota errors.
> anyway to workaround quota functionality on btrfs LZO compressed
> filesystem?
>

Please paste "btrfs qgroup show -prce <mnt>" output if you are using 
btrfs qgroup/quota function.

And, AFAIK btrfs qgroup is applied to subvolume, not user.

So did you mean limit it to one subvolume belongs to one user?

Thanks,
Qu

>
>
> 4.7.0-040700-generic #201608021801 SMP
>
> btrfs-progs v4.7
>
>
> Label: none  uuid: 66a78faf-2052-4864-8a52-c5aec7a56ab8
>
> Total devices 2 FS bytes used 150.62GiB
>
> devid    1 size 1.00TiB used 78.01GiB path /dev/xvdc
>
> devid    2 size 1.00TiB used 78.01GiB path /dev/xvde
>
>
> Data, RAID0: total=150.00GiB, used=149.12GiB
>
> System, RAID1: total=8.00MiB, used=16.00KiB
>
> Metadata, RAID1: total=3.00GiB, used=1.49GiB
>
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> Filesystem      Size  Used Avail Use% Mounted on
>
> /dev/xvdc       2.0T  153G  1.9T   8% /test_lzo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


