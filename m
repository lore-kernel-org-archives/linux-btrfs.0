Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20603 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbcE1FO7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 May 2016 01:14:59 -0400
Subject: Re: [PULL] Btrfs for 4.7, part 2
To: Chris Mason <clm@fb.com>, dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1464254502.git.dsterba@suse.com>
 <20160527001414.opeu5ffezblckpd4@floor.thefacebook.com>
 <20160527111822.GV29147@twin.jikos.cz>
 <20160527143527.bctpuav5la3vchu4@floor.thefacebook.com>
 <20160527154210.illgoqxoyjhj7dbp@floor.thefacebook.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57492925.7070000@oracle.com>
Date: Sat, 28 May 2016 13:14:13 +0800
MIME-Version: 1.0
In-Reply-To: <20160527154210.illgoqxoyjhj7dbp@floor.thefacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/27/2016 11:42 PM, Chris Mason wrote:
> On Fri, May 27, 2016 at 10:35:27AM -0400, Chris Mason wrote:
>> On Fri, May 27, 2016 at 01:18:22PM +0200, David Sterba wrote:
>>> On Thu, May 26, 2016 at 08:14:14PM -0400, Chris Mason wrote:
>>>> On Thu, May 26, 2016 at 11:27:06AM +0200, David Sterba wrote:
>>>>> Hi,
>>>>>
>>>>> please pull a few more patches that did not go to pull #1 for 4.7, minor
>>>>> cleanups and fixes. Thanks.
>>>>
>>>> Thanks Dave!  Trying to figure out why we're failing btrfs/011, but I
>>>> don't see how it could be related to this bunch.  I'll nail it down.
>>>
>>> 011 passes here, there are some unrelated soft-failures (mismatching
>>> output with new progs). I'm now testing a branch without "btrfs: scrub:
>>> Set bbio to NULL before calling btrfs_map_block", that seems to be the
>>> only likely offender.
>>
>> I'm getting errors from btrfs fi show -d, after the very last round of
>> device replaces.  A little extra debugging:
>>
>> bytenr mismatch, want=4332716032, have=0
>> ERROR: cannot read chunk root
>> ERROR reading /dev/vdh
>> failed /dev/vdh
 >>
>> Which is cute because the very next command we run fscks /dev/vdh and
>> succeeds.

Checked the code paths both btrfs fi show -d and btrfs check,
both are calling flush during relative open_ctree in progs.

However the flush is called after we have read superblock. That
means the read_superblock during 'show' cli (only) will read superblock
without flush, and 'check' won't, because 011 calls 'check' after
'show'. But it still does not explain the above error, which is
during open_ctree not at read superblock. Remains strange case as
of now.

Also. I can't reproduce.

>> So the page cache is stale and this isn't related to any of our patches.
>
> close_ctree() calls into btrfs_close_devices(), which calls
> btrfs_close_one_device(), which uses:
>
> call_rcu(&device->rcu, free_device);
>
> close_ctree() also does an rcu_barrier() to make sure and wait for
> free_device() to finish.
>
> But, free_device() just puts the work into schedule_work(), so we don't
> know for sure the blkdev_put is done when we exit.

  Right, saw that before. Any idea why its like that ? Or if it
  should be fixed?

> It's been this way for a while, so its not holding up my pull request to
> Linus.  But I'll fix it up.

  Yes. Its been like that.

Thanks, Anand


> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
