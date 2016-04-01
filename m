Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51687 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbcDAMKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 08:10:18 -0400
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz> <56FDC0A2.1030909@cn.fujitsu.com>
 <20160401084418.GI6230@suse.cz> <56FE363E.5090202@cn.fujitsu.com>
 <20160401113913.GA9918@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56FE6514.10903@gmx.com>
Date: Fri, 1 Apr 2016 20:09:56 +0800
MIME-Version: 1.0
In-Reply-To: <20160401113913.GA9918@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/01/2016 07:39 PM, David Sterba wrote:
> On Fri, Apr 01, 2016 at 04:50:06PM +0800, Qu Wenruo wrote:
>>> After another look, why don't we use nodesize directly? Or stripesize
>>> where applies. With max_size == 0 the test does not make sense, we ought
>>> to know the alignment.
>>>
>> Yes, my first though is also to use nodesize directly, which should be
>> always correct.
>>
>> But the problem is, the related function call stack doesn't have any
>> member to reach btrfs_root or btrfs_fs_info.
>>
>> In the very beginning version of such crossing stripe check, I used to
>> add a btrfs_root/btrfs_fs_info parameter to the function.
>>
>> But the code change are too many, so I use 'max_size'.
>>
>> I can try to re-do such modification, but IIRC it didn't cause a good
>> result.
>
> Yes it would require refactoring, which would be good on itself, because
> add_extent_rec takes 12(!) parameters. Some of its callers would need to
> be updated, but it seems doable.

I'll try to refactor.
I though current extent-tree rework would change all these mess, but 
considering the case of btrfs-convert, I'd better refactor current code 
other than waiting other reviewers to appear.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
