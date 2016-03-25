Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32851 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbcCYBoi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 21:44:38 -0400
Subject: Re: [PATCH v8 25/27] btrfs: dedupe: Add support for compression and
 dedpue
To: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1458610552-9845-26-git-send-email-quwenruo@cn.fujitsu.com>
 <20160324203504.m2b3lybguuf5r2hd@floor.thefacebook.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F497FF.3010705@cn.fujitsu.com>
Date: Fri, 25 Mar 2016 09:44:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160324203504.m2b3lybguuf5r2hd@floor.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2016/03/24 16:35 -0400:
> On Tue, Mar 22, 2016 at 09:35:50AM +0800, Qu Wenruo wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> The basic idea is also calculate hash before compression, and add needed
>> members for dedupe to record compressed file extent.
>>
>> Since dedupe support dedupe_bs larger than 128K, which is the up limit
>> of compression file extent, in that case we will skip dedupe and prefer
>> compression, as in that size dedupe rate is low and compression will be
>> more obvious.
>>
>> Current implement is far from elegant. The most elegant one should split
>> every data processing method into its own and independent function, and
>> have a unified function to co-operate them.
>
> I'd leave this one out for now, it looks like we need to refine the
> pipeline from dedup -> compression and this is just more to carry around
> until the initial support is in.  Can you just decline to dedup
> compressed extents for now?

Yes, completely no problem.
Although this patch seems works well yet, but I also have planned to 
rework current run_delloc_range() to make it more flex and clear.

So the main object of the patch is more about raising attention for such 
further re-work.

And now it has achieved its goal.

Thanks,
Qu
>
> -chris
>
>


