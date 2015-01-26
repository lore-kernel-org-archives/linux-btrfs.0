Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3072 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751962AbbAZAhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Jan 2015 19:37:53 -0500
Message-ID: <54C58C5C.30701@cn.fujitsu.com>
Date: Mon, 26 Jan 2015 08:37:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <miaoxie@huawei.com>
Subject: Re: [PATCH RFC v3 1/5] Revert "btrfs: add support for processing
 pending changes" related commits
References: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com> <1422005505-9472-2-git-send-email-quwenruo@cn.fujitsu.com> <20150123145735.GN13289@twin.jikos.cz>
In-Reply-To: <20150123145735.GN13289@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RFC v3 1/5] Revert "btrfs: add support for 
processing pending changes" related commits
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月23日 22:57
> On Fri, Jan 23, 2015 at 05:31:41PM +0800, Qu Wenruo wrote:
>> For mount option change, later patches will introduce copy-n-update
>> method and rwsem protects to keep mount options consistent during
>> transaction.
> That's a better approach, for the mount options.
I'm glad that you like this method.
Although the description in this patch is outdated, it is now 
per-transaction mount option.
Sorry for the confusion.
>
>> For sysfs interface to change label/features, it will keep the same
>> behavior as 'btrfs pro set', so pending changes are also not needed.
> This still leaves the transaction commit inside the syfs handler, that
> was one of the points not to do that.
>
> The callstack looks safe from, eg. the label handler:
>
> [169148.523158] WARNING: CPU: 1 PID: 2044 at fs/btrfs/sysfs.c:394 btrfs_label_store+0x135/0x190 [btrfs]()
> [169148.533925] Modules linked in: btrfs dm_flakey rpcsec_gss_krb5 loop [last unloaded: btrfs]
> [169148.536950] CPU: 1 PID: 2044 Comm: bash Tainted: G        W      3.19.0-rc5-default+ #211
> [169148.536952] Hardware name: Intel Corporation Santa Rosa platform/Matanzas, BIOS TSRSCRB1.86C.0047.B00.0610170821 10/17/06
> [169148.536954]  000000000000018a ffff88007a753dc8 ffffffff81a9898b 000000000000018a
> [169148.536963]  0000000000000000 ffff88007a753e08 ffffffff81077f65 ffff880077fb0100
> [169148.536972]  ffff880075dc0000 ffff880077fbff00 0000000000000009 ffff880075dc06d0
> [169148.536980] Call Trace:
> [169148.536983]  [<ffffffff81a9898b>] dump_stack+0x4f/0x6c
> [169148.536991]  [<ffffffff81077f65>] warn_slowpath_common+0x95/0xe0
> [169148.537000]  [<ffffffff81077fca>] warn_slowpath_null+0x1a/0x20
> [169148.537005]  [<ffffffffa0052b65>] btrfs_label_store+0x135/0x190 [btrfs]
> [169148.537030]  [<ffffffff813ed8b7>] kobj_attr_store+0x17/0x20
> [169148.537037]  [<ffffffff812147ff>] sysfs_kf_write+0x4f/0x70
> [169148.537044]  [<ffffffff81213cc8>] kernfs_fop_write+0x128/0x180
> [169148.537051]  [<ffffffff8119f404>] vfs_write+0xd4/0x1d0
> [169148.537059]  [<ffffffff8119f7b9>] SyS_write+0x59/0xd0
> [169148.537070]  [<ffffffff81a9f9d2>] system_call_fastpath+0x12/0x17
>
> Lockep shows these locks held:
>
> [169148.537296] 4 locks held by bash/2044:
> [169148.537309]  #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff8119f4e0>] vfs_write+0x1b0/0x1d0
> [169148.537319]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81213c2e>] kernfs_fop_write+0x8e/0x180
> [169148.537330]  #2:  (s_active#214){.+.+.+}, at: [<ffffffff81213c36>] kernfs_fop_write+0x96/0x180
> [169148.537342]  #3:  (tasklist_lock){.+.+..}, at: [<ffffffff810b9ed4>] debug_show_all_locks+0x44/0x1e0
>
> #3 is from lockdep
> #2 is not really a lock, annotated vfs atomic counter
> #0 is annotated atomic, the freezing barrier
>
> #1 is a kernfs mutex that, afaics it's per file, but I don't like to see
> the lock dependency here. That's a lock we can see now, but it's outside
> of btrfs or the vfs. It's a matter of precaution.
Thanks for pointing out the problem.
It makes sense to delay it.

But we have btrfs-workqueue, why not put it to "worker" workqueue?

If using this method, we can just wrap btrfs_ioctl_set_fslabel() and 
queue it to fs_info->workers.
This can avoid the the lockdep problem, but the behavior is still 
inconsistent with the synchronized
ioctl method.
Although not perfect, it should be good enough and still clean enough.

What do you think about such method?

Thanks,
Qu
