Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49415 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbbKNBWv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 20:22:51 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1447365063.7045.7.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56468CE4.2010605@gmx.com>
Date: Sat, 14 Nov 2015 09:22:44 +0800
MIME-Version: 1.0
In-Reply-To: <1447365063.7045.7.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年11月13日 05:51, Christoph Anton Mitterer 写道:
> Hey.
>
> I get these errors on fsck'ing a btrfs:
> bad extent [5993525264384, 5993525280768), type mismatch with chunk
> bad extent [5993525280768, 5993525297152), type mismatch with chunk
> bad extent [5993525297152, 5993525313536), type mismatch with chunk

> bad extent [5993529442304, 5993529458688), type mismatch with chunk
> bad extent [5993529458688, 5993529475072), type mismatch with chunk

> bad extent [5993530015744, 5993530032128), type mismatch with chunk

> bad extent [5993530359808, 5993530376192), type mismatch with chunk
> bad extent [5993530376192, 5993530392576), type mismatch with chunk
> bad extent [5993530392576, 5993530408960), type mismatch with chunk
> bad extent [5993530408960, 5993530425344), type mismatch with chunk

> bad extent [5993531260928, 5993531277312), type mismatch with chunk

> bad extent [5993531310080, 5993531326464), type mismatch with chunk

Manually checked they all.

Strangely, they are all OK... although it's a good news for you.

They are all tree blocks and are all in metadata block group.
It seems to be a btrfsck false alert, but the result is very strange.

If type is wrong, all the extents inside the chunk should be reported as 
mismatch type with chunk.
And according to the dump result, the reported ones are not continuous 
even they have adjacent extents but adjacent ones are not reported.

So there must be some other bug in btrfsck, especially for 
no-skinny_metadata case to trigger the false alert.

Did you have any smaller btrfs with the same false alert?
Although I'll check the code to find what's wrong, but if you have any 
small enough image, debugging will be much much faster.

Thanks,
Qu

>
> What do they mean? And how to correct it without data loss (cause this
> would be critical/precious data)?
>
> Oddly, I've fsck'ed the very same fs last time I've unmounted it (with
> no errors)... and now this.
> The only difference would be newer kernel and btrfsprogs.
>
>
> Thanks,
> Chris.
>
