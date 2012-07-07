Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24781 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2GGHdM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Jul 2012 03:33:12 -0400
Message-ID: <4FF7E8A7.5030705@cn.fujitsu.com>
Date: Sat, 07 Jul 2012 15:43:35 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: Zach Brown <zab@zabbo.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] Btrfs: use radix tree for checksum
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com> <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com> <4FD8BAC9.2020108@zabbo.net> <4FD9437C.3070009@cn.fujitsu.com> <20120706153701.GP7159@shiny>
In-Reply-To: <20120706153701.GP7159@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/2012 11:37 PM, Chris Mason wrote:

> On Wed, Jun 13, 2012 at 07:50:52PM -0600, Liu Bo wrote:
>> On 06/14/2012 12:07 AM, Zach Brown wrote:
>>
>>>>   int set_state_private(struct extent_io_tree *tree, u64 start, u64
>>>> private)
>>>>   {
>>> [...]
>>>> +    ret = radix_tree_insert(&tree->csum, (unsigned long)start,
>>>> +                   (void *)((unsigned long)private<<  1));
>>> Will this fail for 64bit files on 32bit hosts?
>>
>> In theory it will fail, but crc32c return u32, so private will be originally u32,
>> and it'd be ok on 32bit hosts.
> 
> The (unsigned long)start part looks wrong though.  This is the byte offset
> from 0, so on a 32 bit machine you won't be able to have large files.
> 
> The page cache also has this limitation, but it gains extra bits
> counting page indexes instead of byte indexes.
> 


I see.

> I've made that change here and I'm benchmarking it on my big flash ;)
> 


Thanks a lot. :)

I must note that this patchset is still very initial, and this week I've fixed
a deadlock bug hidden in the 4th patch (it can be triggered by xfstests 208).

I'm planning to set up a worker thread or just use 'endio_meta' thread for merge_state
and do more tuning work to lessen writer lock.

thanks,
liubo

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


