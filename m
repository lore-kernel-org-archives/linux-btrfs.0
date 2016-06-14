Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcFNKwg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 06:52:36 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PULL] Btrfs for 4.7, part 2
To: Chris Mason <clm@fb.com>, dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1464254502.git.dsterba@suse.com>
 <20160527001414.opeu5ffezblckpd4@floor.thefacebook.com>
 <20160527111822.GV29147@twin.jikos.cz>
 <20160527143527.bctpuav5la3vchu4@floor.thefacebook.com>
 <20160527154210.illgoqxoyjhj7dbp@floor.thefacebook.com>
 <57492925.7070000@oracle.com> <20160529122103.GA8726@clm-mbp.masoncoding.com>
Message-ID: <1e7bc117-aaa3-c77f-b933-cd0c37b5ce68@oracle.com>
Date: Tue, 14 Jun 2016 18:52:03 +0800
MIME-Version: 1.0
In-Reply-To: <20160529122103.GA8726@clm-mbp.masoncoding.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Chris,

   Sorry for the delay due to vacation.

more below..

On 05/29/2016 08:21 PM, Chris Mason wrote:
> On Sat, May 28, 2016 at 01:14:13PM +0800, Anand Jain wrote:
>>
>>
>> On 05/27/2016 11:42 PM, Chris Mason wrote:
>>>> I'm getting errors from btrfs fi show -d, after the very last round of
>>>> device replaces.  A little extra debugging:
>>>>
>>>> bytenr mismatch, want=4332716032, have=0
>>>> ERROR: cannot read chunk root
>>>> ERROR reading /dev/vdh
>>>> failed /dev/vdh
>>>>
>>>> Which is cute because the very next command we run fscks /dev/vdh and
>>>> succeeds.
>>
>> Checked the code paths both btrfs fi show -d and btrfs check,
>> both are calling flush during relative open_ctree in progs.
>>
>> However the flush is called after we have read superblock. That
>> means the read_superblock during 'show' cli (only) will read superblock
>> without flush, and 'check' won't, because 011 calls 'check' after
>> 'show'. But it still does not explain the above error, which is
>> during open_ctree not at read superblock. Remains strange case as
>> of now.
>
> It's because we're just not done writing it out yet when btrfs fi show
> is run.
> I think replace is special here.
>
>>
>> Also. I can't reproduce.
>>
>
> I'm in a relatively new test rig using kvm, which probably explains why
> I haven't seen it before.  You can probably make it easier by adding
> a sleep inside the actual __free_device() func.
>
>>>> So the page cache is stale and this isn't related to any of our
>>>> patches.
>>>
>>> close_ctree() calls into btrfs_close_devices(), which calls
>>> btrfs_close_one_device(), which uses:
>>>
>>> call_rcu(&device->rcu, free_device);
>>>
>>> close_ctree() also does an rcu_barrier() to make sure and wait for
>>> free_device() to finish.
>>>
>>> But, free_device() just puts the work into schedule_work(), so we don't
>>> know for sure the blkdev_put is done when we exit.
>>
>> Right, saw that before. Any idea why its like that ? Or if it
>> should be fixed?
>
> It's just trying to limit the work that is done from call_rcu, and it
> should
> definitely be fixed.  It might cause EBUSY or other problems.  Probably
> easiest to add a counter or completion object that gets changed by the
> __free_device function.


yes indeed sleep made the problem to reproduce,

Also looks like this problem was identified by below
commit before, however the fix wasn't correct.
    ----
      commit bc178622d40d87e75abc131007342429c9b03351
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

      ::
      Adding an rcu_barrier() to btrfs_close_devices() causes unmount
      to wait
      until all blkdev_put()s are done, and the device is truly free once
      unmount complet
    ----

  As free_devces() spinoff __free_device() to make the actual
  bdev put we need to wait on __free_device(). But rcu_barrier()
  just waits for free_device() to complete, so at the end of
  rcu_barrier() the blkdev_put()  may not be completed.


  Wrote a new fix as in the patches,
   [PATH 2/2] btrfs: wait for bdev put

  For review comments.


Thanks, -Anand

> -chris
