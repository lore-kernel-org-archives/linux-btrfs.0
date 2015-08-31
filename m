Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53680 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751631AbbHaBNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 21:13:35 -0400
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150728145021.GI6306@twin.jikos.cz> <55BF15DF.9080805@cn.fujitsu.com>
 <20150827091407.GB11834@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55E3AA39.1060109@cn.fujitsu.com>
Date: Mon, 31 Aug 2015 09:13:29 +0800
MIME-Version: 1.0
In-Reply-To: <20150827091407.GB11834@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/08/27 11:14 +0200:
> On Mon, Aug 03, 2015 at 03:18:55PM +0800, Qu Wenruo wrote:
>>>> Implement details includes the following:
>>>> 1) LRU hash maps to limit the memory usage
>>>>      The hash -> extent mapping is control by LRU (or unlimited), to
>>>>      get a controllable memory usage (can be tuned by mount option)
>>>>      alone with controllable read/write overhead used for hash searching.
>>>
>>> In Liu Bo's series, I rejected the mount options as an interface and
>>> will do that here as well. His patches added a dedup ioctl to (at least)
>>> enable/disable the dedup.
>> BTW,　would you please give me some reason why that's not a good idea to
>> use mount option to trigger/change dedup options?
>
> That's the wrong interface to use for such actions.
>
But IMHO, deduplication is much like compression, we only need to 
execution extra hook to handle data at run_delalloc_range().

And even better than compression, inline dedup won't even cause any 
format change.
So I'd prefer to use mount option other than introduce a new ioctl 
interface.

Would you please explain more about why mount option is not a good idea 
in this use case?

Thanks,
Qu
