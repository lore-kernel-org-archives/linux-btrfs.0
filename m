From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.38-rc6] create->rebalance->mount crash...
Date: Sat, 26 Feb 2011 12:16:15 +0800
Message-ID: <AANLkTinxLfdYWaab621yOg+M2xKnb=xVgXrmG0NJ7Srd@mail.gmail.com>
References: <AANLkTik-WE+1FYAE6D--fN9GJpThCXwxgejiOsiTk_3k@mail.gmail.com>
	<4D665396.2040105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D665396.2040105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 24 February 2011 20:48, liubo <liubo2009@cn.fujitsu.com> wrote:
> On 02/24/2011 04:13 PM, Daniel J Blueman wrote:
>> When creating a filesystem (single or redundant) with BTRFS and
>> subsequently executing a balance [1], we see a kernel oops at the ne=
xt
>> mount [2].
>>
>
> Hi, Daniel,
>
> After digging this, I've come up with a patch on this, would you plea=
se test
> it on your box? =A0Hopes that this is helpful, Thanks.
>
> From: Liu Bo <liubo2009@cn.fujitsu.com>
>
> [PATCH] btrfs: fix OOPS of empty filesystem after balance
>
> btrfs will exclude unused block groups via a thread.
> When a empty filesystem is balanced, the block group with tag "DATA" =
may be dropped,
> and after umount, this will lead to OOPS when we mount it again.

[snip]

Thanks, Bo; the patch addresses the oops.

Daniel

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
