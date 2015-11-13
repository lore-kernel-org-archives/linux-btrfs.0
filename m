Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45935 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754394AbbKMCNj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 21:13:39 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1447365063.7045.7.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5645474D.8000804@cn.fujitsu.com>
Date: Fri, 13 Nov 2015 10:13:33 +0800
MIME-Version: 1.0
In-Reply-To: <1447365063.7045.7.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Latest fsck added a lot of more restrict check.

Like this one, if any extent type doesn't match with its chunk, like 
metadata extent in a data chunk, btrfsck will report like that.

The filesystem seems to be a converted one from ext*.
If so, there is no real 100% stable method to recovery it, as 
btrfs-convert has broken for some time, and will cause above problem.

But some user, like Roman Mamedov in the maillist, said a balance 
operation can solve it.
It's worthy trying but it may also cause unknown bugs.

Thanks,
Qu

Christoph Anton Mitterer wrote on 2015/11/12 22:51 +0100:
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
