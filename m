Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20931 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756418AbcBQH0u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 02:26:50 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: =?UTF-8?Q?=c3=81ngel_Gonz=c3=a1lez?= <angel@fs.16bits.net>,
        "inux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1447365063.7045.7.camel@scientia.net>
 <1455581697.6951.9.camel@fs.16bits.net> <56C27D8F.2000006@cn.fujitsu.com>
 <1455661288.1700.8.camel@fs.16bits.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56C420A3.1000508@cn.fujitsu.com>
Date: Wed, 17 Feb 2016 15:26:27 +0800
MIME-Version: 1.0
In-Reply-To: <1455661288.1700.8.camel@fs.16bits.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Ángel González wrote on 2016/02/16 23:21 +0100:
>
>
>>> Which should be my next steps?
>>>
>>
>> Try btrfs-progs 4.4 to see if all these false alert goes a way.
>>
>> Thanks,
>> Qu
>
> Thanks!
> Those "errors" are indeed gone after updating btrfs-progs from 4.3.1 to
> 4.4. Sorry for the fuss.
>
>
> It's strange though if it was supposed to only happen with non-skinny
> metadata, since I didn't manually specify any flags, and supposedly
> skinny is the default since 3.18 (the btrfs partition was created with
> a newer version).

If you're really interesting in whether your fs has skinny metadata 
enabled, you can check btrfs-show-super output.

Like the following output indicates skinny metadata:
------
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA ) <<<Here
------

Even it has skinny metadata, it's still possible that some metadata are 
still in old format if you used btrfstune to convert an old fs to skinny 
metadata.

But anyway, it's always good to see the problem solved.

Thanks,
Qu

>
>
> Thanks for your support
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


