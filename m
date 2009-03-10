From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:3546 write_extent_buffer()
Date: Tue, 10 Mar 2009 14:48:26 +0300
Message-ID: <a4423d670903100448tc34f1d4v80cd3cf541820983@mail.gmail.com>
References: <a4423d670811201350le43f908m6fd59b72efa9ecf4@mail.gmail.com>
	 <1227218291.9895.0.camel@think.oraclecorp.com>
	 <a4423d670811201402y4e9582dfr88816ecb65120dd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670811201402y4e9582dfr88816ecb65120dd7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/11/21 Alexander Beregalov <a.beregalov@gmail.com>:
> 2008/11/21 Chris Mason <chris.mason@oracle.com>:
>> On Fri, 2008-11-21 at 00:50 +0300, Alexander Beregalov wrote:
>>> Hi
>>>
>>> I try to run btrfs (Linus's-git + btrfs-unstable) on sparc64:
>>>
>>
>> On sparc64, you'll have to set the sectorsize to your page size. =C2=
=A0What
>> is the output from mkfs.btrfs?
>
> fs created label (null) on /dev/sdb1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0nodesize 8192 leafsize 8192 sectorsize 819=
2 size 19.00GB
> Btrfs v0.16-20-g49bc666
>
>
> Page size is 8kb
>

Hi Chris

The warning still persists
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
