Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4635 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab2IRDxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 23:53:19 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8I3rFgr023112
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 11:53:16 +0800
Message-ID: <5057F029.3000705@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 11:53:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <20120914135418.GM17430@twin.jikos.cz> <5056890C.5020208@cn.fujitsu.com> <20120917163112.GV17430@twin.jikos.cz>
In-Reply-To: <20120917163112.GV17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 17 Sep 2012 18:31:13 +0200, David Sterba wrote:
> On Mon, Sep 17, 2012 at 10:21:00AM +0800, Miao Xie wrote:
>> On fri, 14 Sep 2012 15:54:18 +0200, David Sterba wrote:
>>> On Thu, Sep 13, 2012 at 06:51:36PM +0800, Miao Xie wrote:
>>>> div_factor{_fine} has been implemented for two times, cleanup it.
>>>> And I move them into a independent file named math.h because they are
>>>> common math functions.
>>>
>>> You removed the sanity checks:
>>>
>>> -       if (factor <= 0)
>>> -               return 0;
>>> -       if (factor >= 100)
>>> -               return num;
>>
>> As inline functions, they should not contain complex checks, the caller should
>> make sure the parameters are right. I think.
> 
> It's compiler's job to decide whether a function should be inlined or
> not. The keyword/function attribute 'inline' is only a hint, unless
> always_inline is used and the author should be sure that it really has
> the expected outcome and that compiler is wrong here.

Right, but I think we should make the functions as simple as possible since
they are marked as inline, because the simple function is more likely to be inlined
than the complex one.

> I don't agree that each caller should do the checks, it only makes code
> harder to read and forces the authors to check for conditions that may
> not be apparent or are just ommitted.

Right. But for these functions, we are sure the value of the parameters is
in the right range in the most place, and all the place that we are sure the
value is right is in the hot path. The only place that we need check the
parameters is in slow path, this is also the reason why we make them inline.
so doing those checks just wastes time. We just need modify the caller.

Thanks
Miao

> If we need a function that does not check the boundaries, then of course
> go for it, but I don't see such case yet.
> 
>>> in new version. And I don't think it's necessary to add an extra include
>>> with a rather generic name and trivial code. A separate .h/.c with
>>> non-filesystem related support code like this looks more suitable.
>>>
>>> Do you intend to use the functions out of extent-tree.c ?
>>
>> They are used in both extent-tree.c and volumes.c from the outset, but they
>> were implemented in these two files severally.
> 
> Ah, I see.
> 
> david
> 


