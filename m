Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbcEKBRM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 21:17:12 -0400
Subject: Re: [PATCH RFC v2 00/16] Introduce low memory usage btrfsck mode
To: <dsterba@suse.cz>, <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1461914350-19875-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160510124429.GR29353@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <58406785-15b7-2888-124f-03a01a6a7d9a@cn.fujitsu.com>
Date: Wed, 11 May 2016 09:17:06 +0800
MIME-Version: 1.0
In-Reply-To: <20160510124429.GR29353@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/10 14:44 +0200:
> On Fri, Apr 29, 2016 at 03:18:54PM +0800, Qu Wenruo wrote:
>> The branch can be fetched from my github:
>> https://github.com/adam900710/btrfs-progs.git low_mem_fsck_rebasing
> ...
>> Changelog:
>>   v1.1:
>>     Fix a typo which makes keyed data backref check always fail
>>   v2:
>>     Don't return minus value with error bits. (Suggested by Josef)
>>     Follow kernel code styling. (Suggested by Josef)
>>     Enhance check on data backref count. (Slow down check speed though)
>
> Is the branch low_mem_fsck_rebasing supposed to track the latest
> version? I still see the negative values for error flags there.

Sorry, forgot to update github repo.
Updated now.

>
> I guess last thing you'd like to see commented in this patchset is
> message formatting but it's consistently not matching the preferred
> style everywhere, so please don't start the message with capitals, eg.:
>
> 	error("Block group[%llu %llu] relat..."
>
> Testing the branch on the images in repository reported no problems
> which is enough to add the branch to integration, but otherwise I'll
> wait for Josef's review.
>
>
That's completely OK, review from Josef will definitely improve the code 
quality.

And for message format, I'll change them in next iteration

Thanks,
Qu


