From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH 0/4] Add readonly support to replace BUG_ON phrase
Date: Tue, 30 Nov 2010 10:03:58 +0800
Message-ID: <4CF45B8E.3070100@cn.fujitsu.com>
References: <4CEE31EF.1020102@cn.fujitsu.com> <20101129201017.GB2618@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	liubo <liubo2009@cn.fujitsu.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101129201017.GB2618@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2010 04:10 AM, Josef Bacik wrote:
> On Thu, Nov 25, 2010 at 05:52:47PM +0800, Miao Xie wrote:
>> Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasant panic.
>> Meanwhile, they are very ugly and should be handled more propriately.
>>
>> There are mainly two ways to deal with these BUG_ON()s.
>>
>> 1. For those errors which can be handled well by callers, we just return their
>> error number to callers.
>>
>> 2. For others, We can force the filesystem readonly when it hits errors, which
>>  is what this patchset has done. Replaced BUG_ON() with the interface provided
>>  in this patchset, we will get error infomation via dmesg. Since btrfs is now 
>> readonly, we can save our data safely and umount it, then a btrfsck is 
>> recommended.
>>
>> By these ways, we can protect our filesystem from panic caused by those 
>> BUG_ONs.
>>
>> ---
>>  fs/btrfs/ctree.h       |   21 ++++++++++
>>  fs/btrfs/disk-io.c     |   23 +++++++++++
>>  fs/btrfs/super.c       |  100 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  fs/btrfs/transaction.c |    7 +++
>>  4 files changed, 148 insertions(+), 3 deletions(-)
>>
> 
> Overall seems sane, but what about kernels that don't make these checks?  I'm ok
> with "well sucks for them" as an answer, just want to make sure we've at least
> though about it.

You mean those code that does nothing on ret-checks?

IMO, if the code really needs ret-check, we should deal with them seriously, or just
leave it alone. And this is a step-by-step job.

> 
> Also I'm not sure marking the fs as broken is the right move here.  Ext3/4 don't
> do this, they just mount read-only, as long as you can still unmount the
> filesystem everything comes out ok.  Think of the case where we just get a
> spurious EIO, the fs should be fine the next time around, there's reason to
> force the user to run fsck in this case.
> 

Yes, I agree on this.
For spurious EIO, it mainly depends on coders, returning the errno to caller may work on 
bypassing fsck.

While I'm working on this readonly stuff, it is difficult to solve the potential 
deadlock when we write the super block to disk. 
Since btrfs supports multi-device, before write-super, we must get the device lock 
"device_list_mutex" first, and this has puzzled me a lot.

BTW, I've tried another way to bypass deadlock. I made the write-super stuff into umount, 
which can make us free from deadlock, however, while testing this, it seemes that umount 
cannot work due to a ext3/4 jbd oops, I'm digging on this oops...

So, any ideas about free from deadlock?

> Thanks,
> 
> Josef
> 

