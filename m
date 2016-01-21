Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40277 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbcAUIX3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 03:23:29 -0500
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Al <6401e46d@opayq.com>, <linux-btrfs@vger.kernel.org>
References: <loom.20160116T132316-196@post.gmane.org>
 <pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
 <loom.20160120T143906-108@post.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56A0956B.7060706@cn.fujitsu.com>
Date: Thu, 21 Jan 2016 16:23:07 +0800
MIME-Version: 1.0
In-Reply-To: <loom.20160120T143906-108@post.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Al wrote on 2016/01/20 14:43 +0000:
> Duncan <1i5t5.duncan <at> cox.net> writes:
>
>>
>> Al posted on Sat, 16 Jan 2016 12:27:16 +0000 as excerpted:
>>
>
> That it does, Duncan, thank you!
>
> I was suggesting, albeit implicitly, that unless you're really short of
> block dev space (!), which is a pretty naff dedup strategy, dedup isn't time
> critical AFAIC(See). My server memory is not huge and I'd happily let it
> chug away dedup'ing than have the whole thing run like a dog for lack of memory.
>
> I'm looking forward to using it; keep up the very good work.
>

The design of providing two backends is for different use case.

If you don't thinkg inmemory is good, then just use ondisk.
Even inmemory doesn't seems useful for you, there is still some cases 
that you doesn't know.

The design of inmemory is not to save your block dev space, but to limit 
the overhead of write to a consist value.

If one day you just want to write 64K data, but you need to randomly 
read 128K metadata and found a hash miss, and do the real write, then 
you may understand the meaning of inmemory backend.



To conclude, something meaningless to you doesn't mean it's meaningless 
for everyone.
If you really think the design is naff, I'm very glad if you can provide 
a better one.

Thanks,
Qu

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


