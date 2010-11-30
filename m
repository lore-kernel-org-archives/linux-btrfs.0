From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH 0/4] Add readonly support to replace BUG_ON phrase
Date: Tue, 30 Nov 2010 13:28:03 +0800
Message-ID: <4CF48B63.5040303@cn.fujitsu.com>
References: <4CEE31EF.1020102@cn.fujitsu.com> <20101129201017.GB2618@localhost.localdomain> <4CF45B8E.3070100@cn.fujitsu.com> <20101130023030.GA427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101130023030.GA427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2010 10:30 AM, Josef Bacik wrote:
> On Tue, Nov 30, 2010 at 10:03:58AM +0800, liubo wrote:
>> On 11/30/2010 04:10 AM, Josef Bacik wrote:
>>> On Thu, Nov 25, 2010 at 05:52:47PM +0800, Miao Xie wrote:
>>>> Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasant panic.
>>>> Meanwhile, they are very ugly and should be handled more propriately.
>>>>
>>>> There are mainly two ways to deal with these BUG_ON()s.
>>>>
>>>> 1. For those errors which can be handled well by callers, we just return their
>>>> error number to callers.
>>>>
>>>> 2. For others, We can force the filesystem readonly when it hits errors, which
>>>>  is what this patchset has done. Replaced BUG_ON() with the interface provided
>>>>  in this patchset, we will get error infomation via dmesg. Since btrfs is now 
>>>> readonly, we can save our data safely and umount it, then a btrfsck is 
>>>> recommended.
>>>>
>>>> By these ways, we can protect our filesystem from panic caused by those 
>>>> BUG_ONs.
>>>>
>>>> ---
>>>>  fs/btrfs/ctree.h       |   21 ++++++++++
>>>>  fs/btrfs/disk-io.c     |   23 +++++++++++
>>>>  fs/btrfs/super.c       |  100 ++++++++++++++++++++++++++++++++++++++++++++++-
>>>>  fs/btrfs/transaction.c |    7 +++
>>>>  4 files changed, 148 insertions(+), 3 deletions(-)
>>>>
>>> Overall seems sane, but what about kernels that don't make these checks?  I'm ok
>>> with "well sucks for them" as an answer, just want to make sure we've at least
>>> though about it.
>> You mean those code that does nothing on ret-checks?
>>
>> IMO, if the code really needs ret-check, we should deal with them seriously, or just
>> leave it alone. And this is a step-by-step job.
>>
> 
> Sorry I mean for older kernels that don't know about these "hey your fs is
> screwed" flags.  It seems like they'll just get ignored, are we sure thats what
> we want to happen?  I'm fine with that, but if we don't want that to happen it
> may be good to have a incompat flag.
> 

Ohh, got it, thanks for pointing it out. Will do it later.

>>> Also I'm not sure marking the fs as broken is the right move here.  Ext3/4 don't
>>> do this, they just mount read-only, as long as you can still unmount the
>>> filesystem everything comes out ok.  Think of the case where we just get a
>>> spurious EIO, the fs should be fine the next time around, there's reason to
>>> force the user to run fsck in this case.
>>>
>> Yes, I agree on this.
>> For spurious EIO, it mainly depends on coders, returning the errno to caller may work on 
>> bypassing fsck.
>>
> 
> Right I'm worried about the flipping read only stuff being kicked by EIO, which
> happens with ext* and could happen with btrfs in the right cases.  I'm not
> saying thats wrong, its what should happen, I'm just saying we need to be able
> to unmount the filesystem and mount it back up without needing to run an fsck in
> between.
> 

hm, this really makes sense. 

Since it is difficult to tell whether a fake corruption it is, what about just 
implementing readonly stuff like this and making it more friendly to EIO in future?

>> While I'm working on this readonly stuff, it is difficult to solve the potential 
>> deadlock when we write the super block to disk. 
>> Since btrfs supports multi-device, before write-super, we must get the device lock 
>> "device_list_mutex" first, and this has puzzled me a lot.
>>
>> BTW, I've tried another way to bypass deadlock. I made the write-super stuff into umount, 
>> which can make us free from deadlock, however, while testing this, it seemes that umount 
>> cannot work due to a ext3/4 jbd oops, I'm digging on this oops...
>>
>> So, any ideas about free from deadlock?
>>
> 
> None :).  The best thing I can think of is do like we're doing with the read
> only stuff and only write out the super right before we flip read only, and then
> make umount make sure that if we're mounted read only to not do anything.
> 
> Truth be told I hate this "mark the fs as broken" idea.  We don't know if the
> error we got means the filesystem is broken (for example the EIO case).  If we
> do hit actual corruption maybe it would be good, and in that case we should
> write out the super at the point we find that corruption and then flip read only
> and have that be the only time we have to worry about writing out the super.
> 
> So I guess that's 2 options
> 
> 1) Ditch the "the fs is broken" flag.  This makes things nice and simple since
> on-disk is already consistent, all we have to do is drop anything thats dirty
> and we're home free.
> 
> 2) Keep the flag, but only worry about writing it out on a case by case basis.
> So we have a btrfs_corrupt_fs() function that writes out the super with the
> appropriate flag, and then flips the fs read only.  Then we don't have to do
> anything special in the common paths, just the normal "hey is this fs read
> only?" things, so for all other cases we can just flip the fs read only and
> everything works.
> 

The 2) is what I have just done. :)

> I hope that makes sense, if not feel free to ignore me and just keep doing what
> you've been doing :).  Thanks,
> 

They are very helpful.

Thanks,
Liu Bo

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

