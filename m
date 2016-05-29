Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16702 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932137AbcE2MVc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 08:21:32 -0400
Date: Sun, 29 May 2016 08:21:03 -0400
From: Chris Mason <clm@fb.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs for 4.7, part 2
Message-ID: <20160529122103.GA8726@clm-mbp.masoncoding.com>
References: <cover.1464254502.git.dsterba@suse.com>
 <20160527001414.opeu5ffezblckpd4@floor.thefacebook.com>
 <20160527111822.GV29147@twin.jikos.cz>
 <20160527143527.bctpuav5la3vchu4@floor.thefacebook.com>
 <20160527154210.illgoqxoyjhj7dbp@floor.thefacebook.com>
 <57492925.7070000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <57492925.7070000@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 28, 2016 at 01:14:13PM +0800, Anand Jain wrote:
>
>
>On 05/27/2016 11:42 PM, Chris Mason wrote:
>>>I'm getting errors from btrfs fi show -d, after the very last round of
>>>device replaces.  A little extra debugging:
>>>
>>>bytenr mismatch, want=4332716032, have=0
>>>ERROR: cannot read chunk root
>>>ERROR reading /dev/vdh
>>>failed /dev/vdh
>>>
>>>Which is cute because the very next command we run fscks /dev/vdh and
>>>succeeds.
>
>Checked the code paths both btrfs fi show -d and btrfs check,
>both are calling flush during relative open_ctree in progs.
>
>However the flush is called after we have read superblock. That
>means the read_superblock during 'show' cli (only) will read superblock
>without flush, and 'check' won't, because 011 calls 'check' after
>'show'. But it still does not explain the above error, which is
>during open_ctree not at read superblock. Remains strange case as
>of now.

It's because we're just not done writing it out yet when btrfs fi show is run.
I think replace is special here.

>
>Also. I can't reproduce.
>

I'm in a relatively new test rig using kvm, which probably explains why
I haven't seen it before.  You can probably make it easier by adding
a sleep inside the actual __free_device() func.

>>>So the page cache is stale and this isn't related to any of our patches.
>>
>>close_ctree() calls into btrfs_close_devices(), which calls
>>btrfs_close_one_device(), which uses:
>>
>>call_rcu(&device->rcu, free_device);
>>
>>close_ctree() also does an rcu_barrier() to make sure and wait for
>>free_device() to finish.
>>
>>But, free_device() just puts the work into schedule_work(), so we don't
>>know for sure the blkdev_put is done when we exit.
>
> Right, saw that before. Any idea why its like that ? Or if it
> should be fixed?

It's just trying to limit the work that is done from call_rcu, and it should
definitely be fixed.  It might cause EBUSY or other problems.  Probably
easiest to add a counter or completion object that gets changed by the
__free_device function.

-chris
