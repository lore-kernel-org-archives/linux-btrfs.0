From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: Question: Build btrfs filesystem from specific directory.
Date: Sat, 12 Jun 2010 13:47:52 +0900
Message-ID: <AANLkTinZkD1HOCOk1DnFkCnGoXDCr7N4s4OCact1t_Pn@mail.gmail.com>
References: <AANLkTimbW5pNGsFxRZYRRjY0Ke-Wyb4aaBkUZgilVMlR@mail.gmail.com>
	<201006120633.12043.xengine@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Evgeny A. Marchenko" <xengine@mail.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006120633.12043.xengine@mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, Jun 12, 2010 at 11:33 AM, Evgeny A. Marchenko <xengine@mail.ru>=
 wrote:
>> I'm founding the solution to build btrfs filesystem image from
>> specific directory.
>> it's common concept at mobile build environment.
>> e.g., ubifs and cramfs support this feature.
>>
>> In case of ubifs
>> -r, -d, --root=3DDIR =A0 =A0 =A0 build file system from directory DI=
R
>> In case of cramfs
>> dirname =A0 =A0root of the filesystem to be compressed
>>
>> But btrfs doesn't support it.
> Maybe because btrfs is not a compressed read-only filesystem

It's just example. it's not matter to support compressed or not.

>
>> So does it have any plan to support this feature at btrfs?
> You can create file-backed loop device, mount it and copy the directo=
ry
> contents there. Than unmount the loop and voila - you have btrfs imag=
e

Right, I used it now, but some build machine doesn't have or support
btrfs, it mean can't mount btrfs as loopback.
I just want to create btrfs image from directory without any host
machine dependency such as kernel version and whatever.
To simply, just use the mkfs.btrfs itself.

Thank you,
Kyungmin Park
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
