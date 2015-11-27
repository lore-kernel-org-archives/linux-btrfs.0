Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43203 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753559AbbK0Ake (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 19:40:34 -0500
Subject: Re: [PATCH v2] btrfs-progs: fsck: Fix a false alert where extent
 record has wrong metadata flag
To: Christoph Anton Mitterer <calestyo@scientia.net>, <dsterba@suse.cz>
References: <1448432346-2842-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151126142733.GR31035@twin.jikos.cz> <1448551221.8809.7.camel@scientia.net>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5657A673.7000107@cn.fujitsu.com>
Date: Fri, 27 Nov 2015 08:40:19 +0800
MIME-Version: 1.0
In-Reply-To: <1448551221.8809.7.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/26 16:20 +0100:
> Hey.
>
> I can confirm that the new patch fixes the issue on both test
> filesystems.
>
> Thanks for working that out. I guess there's no longer a need to keep
> that old filesystems now?!

Of course no need to keep.
But since there is no real error, feel free to keep using it or just re 
format it with skinny-metadata.

Thanks,
Qu

>
> Cheers,
> Chris.
>
> On Thu, 2015-11-26 at 15:27 +0100, David Sterba wrote:
>> On Wed, Nov 25, 2015 at 02:19:06PM +0800, Qu Wenruo wrote:
>>> In process_extent_item(), it gives 'metadata' initial value 0, but
>>> for
>>> non-skinny-metadata case, metadata extent can't be judged just from
>>> key
>>> type and it forgot that case.
>>>
>>> This causes a lot of false alert in non-skinny-metadata filesystem.
>>>
>>> Fix it by set correct metadata value before calling
>>> add_extent_rec().
>>>
>>> Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>
>> Patch replaced, thanks. The test image is pushed as well.


