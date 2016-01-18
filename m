Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14845 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbcARDQz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 22:16:55 -0500
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <loom.20160116T132316-196@post.gmane.org>
 <569C41B1.1090206@cn.fujitsu.com>
 <pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <569C58FB.70407@cn.fujitsu.com>
Date: Mon, 18 Jan 2016 11:16:11 +0800
MIME-Version: 1.0
In-Reply-To: <pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Duncan wrote on 2016/01/18 03:10 +0000:
> Qu Wenruo posted on Mon, 18 Jan 2016 09:36:49 +0800 as excerpted:
>
>>> dedup'ing data immediately when written to high-write-count data is
>>> counter productive because no sooner has it been deduped then it is
>>> rendered obsolete by another COW write.
>>
>> And it seems that you are not familiar how kernel is caching data for
>> filesystem.
>> There is already kernel page cache for such case.
>> No matter how many times you write, as long as you're doing buffered
>> write the the data is not written to disk but cached by kernel, until
>> either you triggered a manual sync or memory pressure hits threshold.
>
> Not contradicting in general, but checking my own understanding here...
>
> Doesn't the kernel write cache get synced by timeout as well as memory
> pressure and manual sync, with the timeouts found in
> /proc/sys/vm/dirty_*_centisecs, with defaults of 5 seconds background and
> 30 seconds higher priority foreground expiry?
>
> Regardless, I agree, the kernel page-cache seriously mitigates the stated
> concerns.
>
Yep, I forgot timeout. It can also be specified by per fs mount option 
"commit=".

But I never /proc/sys/vm/dirty_* interface before... I'd better check 
the code or add some debug pr_info to learn such behavior.

Thanks for pointing out this,
Qu


