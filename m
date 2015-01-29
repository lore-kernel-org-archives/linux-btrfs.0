Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21358 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753446AbbA2BO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 20:14:27 -0500
Message-ID: <54C989A0.1080307@cn.fujitsu.com>
Date: Thu, 29 Jan 2015 09:15:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <miaoxie@huawei.com>
Subject: Re: [PATCH RFC v3 1/5] Revert "btrfs: add support for processing
 pending changes" related commits
References: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com> <1422005505-9472-2-git-send-email-quwenruo@cn.fujitsu.com> <20150123145735.GN13289@twin.jikos.cz> <54C58C5C.30701@cn.fujitsu.com> <54C5D91E.7050502@cn.fujitsu.com> <20150128132513.GE3641@twin.jikos.cz>
In-Reply-To: <20150128132513.GE3641@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RFC v3 1/5] Revert "btrfs: add support for 
processing pending changes" related commits
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月28日 21:25
> On Mon, Jan 26, 2015 at 02:05:18PM +0800, Qu Wenruo wrote:
>> -------- Original Message --------
>> Subject: Re: [PATCH RFC v3 1/5] Revert "btrfs: add support for
>> processing pending changes" related commits
>> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, miaoxie@huawei.com
>> Date: 2015年01月26日 08:37
>>> [...snipped...]
>>> Thanks for pointing out the problem.
>>> It makes sense to delay it.
>>>
>>> But we have btrfs-workqueue, why not put it to "worker" workqueue?
> This only differs how the work item is stored until it's processed, it
> will have to synchronize with the transaction commit anyway. The pending
> changes can act as a special purpose work queue.
>
>>> If using this method, we can just wrap btrfs_ioctl_set_fslabel() and
>>> queue it to fs_info->workers.
>>> This can avoid the the lockdep problem,
> There's no lockdep problem, the output comes from lockdep but just to
> illustrate the lock chain at the time of potential commit time.
>
>>> but the behavior is still
>>> inconsistent with the synchronized
>>> ioctl method.
>>> Although not perfect, it should be good enough and still clean enough.
>> Wait a second, #1 is a mutex, so I didn't quite understand the problem.
>> Just because it is not btrfs/vfs mutex so we want to avoid it?
>> It seems not convincing enough for me...
> It's sysfs/kernfs, isn't that enough? :)
>
> The problem I see is that the whole transaction commit is called from
> under that lock. We do some sysfs-related stuff like add or remove
> objects (eg. devices), exporting space info etc.
>
> Are we sure that there's no possible deadlock when we eg. change the
> label via sysfs in the middle of a balance that removes some of the
> files? Or other combination of operations. Can we guarantee that this
> will be ok in the long term and not introduced accidentally?
For me, I didn't see the difference between VFS staff and sysfs/kernfs 
staff.
They both have their own locking things which is out of the control of 
btrfs.

But we are still using VFS staffs, right? If we want to use sysfs 
interfaces to do things like change label,
then it's our responsibility to ensure things works fine. If not we 
should either modify btrfs or sysfs to
do it, just like what we were doing with VFS staffs.

To ensure the cooperation works fine, we just need extra testcases, much 
like what we were doing.

So IMHO, I didn't really see the difference between VFS and sysfs staffs 
(except sysfs is not so wided adapted).
We just needs to do all the old style work, modify btrfs or sysfs or 
both and, and add tons of test case.
>
>> For readonly/freeze check, I prefer extra vfsmount from sb->s_mounts and
>> use mnt_want_write() (handle ro)
>> and transaction (handle freeze).
>> So IMHO it just needs some small tweaks on the original implementation.
> But how can we do the mnt_want_write call inside sysfs handler?
>
> Although we could drop the write support for label via sysfs in the end,
> this whole exercise can be used later to decide what is/not safe to do
> via sysfs. So it's good to try find ways right now.
I have already sent the new patchset, but it seems vger.kernel.org 
refused to accept the patchset,
I'll send it again try using my personal gmail account.

In that patchset, I added a new helper function in VFS, 
get_vfsmount_sb() to get a vfsmount from a sb,
so even we are in sysfs handler, we can still use mnt_want_write() to do 
all the protections.

Thanks,
Qu
