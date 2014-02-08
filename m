Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58110 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaBHDHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 22:07:02 -0500
Received: by mail-pb0-f53.google.com with SMTP id md12so4018571pbc.40
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 19:07:00 -0800 (PST)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs send
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <52F2A370.2080509@fb.com>
Date: Sat, 8 Feb 2014 11:06:56 +0800
Cc: <linux-btrfs@vger.kernel.org>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Message-Id: <E2D932EC-EEEA-46DA-92D8-CEA762893951@gmail.com>
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com> <52E94FEA.5060404@fb.com> <EA799A56-E02C-4D2E-957A-99CE1ED9CDB4@gmail.com> <52EA78E3.9060009@fb.com> <98BBA3BC-1CB6-4840-A5AF-6CE9C76B72AA@gmail.com> <52EA7C78.2030509@fb.com> <2DED49DB-B86D-46FB-B05C-3FB5E655749C@gmail.com> <15132D45-7C4B-41FD-A240-43BCFE314726@gmail.com> <52F00AAE.6070509@fb.com> <15BD028C-7568-4ACF-84D1-CA39092AD285@gmail.com> <52F244DE.9030108@fb.com> <2ECC0789-2FE8-4644-B439-35B682502867@gmail.com> <52F2A370.2080509@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

[..SNIP..]

>> Yeah, very reasonable, if you don't mind, i would give a patch for this issue.
> Go for it, you'll be faster than I will be, all I do is run xfstests and
> try to reproduce things that will never reproduce for me.

So Finally, i've figured everything out.

Previous send is almostly safe is because we deal every item by transaction protection, 
and we will search next item from root again next time (see btrfs_search_slot_for_read())
And we will check root's @ctransid to make sure root did not change during send. (For readonly root,
usually it should not except snapshot-aware defrag, ok we should fix it!!)

Since we kicked off transaction from send, life will become a little complex,we should take care of
everything can change readonly snapshot, from i can say now:

1. snapshot @send_root will cow everything
2. snapshot-aware defrag also work for readonly root.
3. balance, device resize, add,remove, scrub(repair mode)

So there are two ideas in my mind:

#Approach 1
convert to previous ways that means add transaction protection for send. and Filipe's optimizations
for send search should be reverted, this way is simple and make codes less complex, but we will involve
transaction protection.

#Approach 2.
Add a local flag to root structure to sync snapshot with send.
Add a global flag to sync balance's etc options with send
don't defray readonly snapshot for snapshot-aware defrag.

Approach 2 will make it safe to avoid transaction from send, but it add complexity to codes.Personally,
i do not like approach 2 very much because it make btrfs codes more *ugly*  and make it *harder* to maintain.

Anyway, I am ok to implement  both ways, Tell me if you have any better ideas or which approach is your
appreciated way to fix the issue^_^

Thanks,
Wang
> 
> Josef

