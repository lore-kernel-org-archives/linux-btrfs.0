Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:54888 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaFSXvS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 19:51:18 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 161B33EE0C8
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Jun 2014 08:51:17 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 10ECAAC058C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Jun 2014 08:51:16 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id BBE421DB804B
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Jun 2014 08:51:15 +0900 (JST)
Message-ID: <53A37765.7020206@jp.fujitsu.com>
Date: Fri, 20 Jun 2014 08:51:01 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Adam Buchbinder <abuchbinder@google.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Fix undefined behavior in radix-tree.c.
References: <1402694330-21211-1-git-send-email-abuchbinder@google.com> <53A12FAE.7060307@jp.fujitsu.com> <20140618144342.GV1903@twin.jikos.cz> <53A2389F.6050404@jp.fujitsu.com> <20140619132845.GC1903@suse.cz>
In-Reply-To: <20140619132845.GC1903@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

(2014/06/19 22:28), David Sterba wrote:
> On Thu, Jun 19, 2014 at 10:10:55AM +0900, Satoru Takeuchi wrote:
>> It's fixed at 430d275a399.
>>
>> ===============================================================================
>> commit 430d275a399175c7c0673459738979287ec1fd22
>> Author: Peter Lund <firefly@vax64.dk>
>> Date:   Tue Oct 16 23:29:35 2007 -0700
>>
>>      avoid negative (and full-width) shifts in radix-tree.c
>> ...
>> ===============================================================================
>>
>> Adam, David, how about import this patch from kernel, rather than
>> writing btrfs-progs's own patch?
>
> Well, I think there's non-trivial time spent by Adam on the patch so I'd
> rather keep the credit, even if a patch that backports the fix from
> kernel would look cleaner in git log. Such things happen, sometimes it
> makes sense to replace patches or do changes inline.
>
> The progs development is moving forward quickly, a clean patch history
> is most useful when there is a separate stable branch that receives
> bugfixes as it helps the backporters to identify complete fixes. Not the
> case for progs right now.
>
>> I consider It's better to regularly sync such utility code with
>> the newest kernel code for the long term...
>
> Yes. The radix- or rb- tree code does not change often though, we can do
> a sync now and be fine for some time.

OK, I see. Thank you for your clear explanation.

Thanks,
Satoru



