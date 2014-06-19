Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:50769 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaFSBLK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:11:10 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 5375B3EE0C3
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:11:08 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 99C8CAC0130
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:11:06 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3F75B1DB802C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:11:06 +0900 (JST)
Message-ID: <53A2389F.6050404@jp.fujitsu.com>
Date: Thu, 19 Jun 2014 10:10:55 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Adam Buchbinder <abuchbinder@google.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Fix undefined behavior in radix-tree.c.
References: <1402694330-21211-1-git-send-email-abuchbinder@google.com> <53A12FAE.7060307@jp.fujitsu.com> <20140618144342.GV1903@twin.jikos.cz>
In-Reply-To: <20140618144342.GV1903@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David, Adam,

(2014/06/18 23:43), David Sterba wrote:
> On Wed, Jun 18, 2014 at 03:20:30PM +0900, Satoru Takeuchi wrote:
>> Hi Adam,
>>
>> (2014/06/14 6:18), Adam Buchbinder wrote:
>>> When running with UndefinedBehaviorSanitizer, the tests produce the following
>>> error:
>>>
>>>     radix-tree.c:836:30: runtime error: shift exponent 18446744073709551613
>>>     is too large for 64-bit type 'unsigned long'
>>>
>>> (That's a negative shift exponent represented as an unsigned long.)
>>>
>>> Even though the value is discarded in those cases, it's still undefined
>>> behavior; see the C99 standard, section 6.5.7, paragraph three: "If the
>>> value of the right operand is negative [...] the behavior is undefined."
>>>
>>> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
>>
>> It looks good to me.
>>
>> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>
> Thank you both.
>
> The file is taken from kernel/lib/radix-tree.c and has diverged a bit so
> it could be missing more bugfixes.

I confirmed the kenel doesn't have such problem.

lib/radix-tree.c (kernel code):
===============================================================================
static __init unsigned long __maxindex(unsigned int height)
{
         unsigned int width = height * RADIX_TREE_MAP_SHIFT;
         int shift = RADIX_TREE_INDEX_BITS - width;

         if (shift < 0)
                 return ~0UL;
         if (shift >= BITS_PER_LONG)
                 return 0UL;
         return ~0UL >> shift;
}
===============================================================================

It's fixed at 430d275a399.

===============================================================================
commit 430d275a399175c7c0673459738979287ec1fd22
Author: Peter Lund <firefly@vax64.dk>
Date:   Tue Oct 16 23:29:35 2007 -0700

     avoid negative (and full-width) shifts in radix-tree.c
...
===============================================================================

Adam, David, how about import this patch from kernel, rather than
writing btrfs-progs's own patch?

P.S.
I consider It's better to regularly sync such utility code with
the newest kernel code for the long term...

Thanks,
Satoru

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

