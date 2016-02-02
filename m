Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9625 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbcBBCzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 21:55:19 -0500
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Al <6401e46d@opayq.com>, <linux-btrfs@vger.kernel.org>
References: <loom.20160116T132316-196@post.gmane.org>
 <pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
 <loom.20160120T143906-108@post.gmane.org> <56A0956B.7060706@cn.fujitsu.com>
 <loom.20160121T152848-821@post.gmane.org>
 <CAJCQCtQr18LnkrxpnBR0MrTjLGuUd=wPsa9+NoW-TfrycT8Zvw@mail.gmail.com>
 <loom.20160122T122307-195@post.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56B01A85.80507@cn.fujitsu.com>
Date: Tue, 2 Feb 2016 10:55:01 +0800
MIME-Version: 1.0
In-Reply-To: <loom.20160122T122307-195@post.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You're right, I misunderstood the mail and get a little emotional.

And sorry for that inappropriate reply.


BTW, the new patchset will be sent to btrfs mail list in coming hour, if 
you're interested in inband de-dup, you can try the following github 
repos to build and test in-band de-dup:

Kernel
https://github.com/adam900710/linux.git wang_dedup

Btrfs-progs
https://github.com/adam900710/btrfs-progs.git dedup

And if you have any concern on the implementation or the dedup related 
Document, I'm happy to hear.
(I was a little emotional just because some unexpected bugs that time.)

Thanks,
Qu


Al wrote on 2016/01/22 11:33 +0000:
> With respect Chris, if you intentionally ignore all of the other context
> clues ("keep up the great work", "looking forward to using it"), you could
> come to that conclusion. You'd have to try really really hard.
>
> I wasn't criticising your buddy in anyway, quite the opposite. Can we move
> on, now? There are better ways of spending our time.
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


