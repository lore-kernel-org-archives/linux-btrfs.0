Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:46335 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbbA3EPV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 23:15:21 -0500
Message-ID: <54CB0520.2070008@huawei.com>
Date: Fri, 30 Jan 2015 12:14:24 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to
 get vfsmount from a given sb.
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com> <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com> <54CAD5DC.2060603@huawei.com> <54CAE1E3.1040406@cn.fujitsu.com> <20150130021445.GH29656@ZenIV.linux.org.uk>
In-Reply-To: <20150130021445.GH29656@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 30 Jan 2015 02:14:45 +0000, Al Viro wrote:
> On Fri, Jan 30, 2015 at 09:44:03AM +0800, Qu Wenruo wrote:
> 
>> This shouldn't happen. If someone is ro, the whole fs should be ro, right?
> 
> Wrong.  Individual vfsmounts over an r/w superblock might very well be r/o.
> As for that trylock...  What for?  It invites transient failures for no
> good reason.  Removal of sysfs entry will block while write(2) to that sucker
> is in progress, so btrfs shutdown will block at that point in ctree_close().
> It won't go away under you.

could you explain the race condition? I think the deadlock won't happen, during
the btrfs shutdown, we hold s_umount, the write operation will fail to lock it,
and quit quickly, and then umount will continue.

I think sb_want_write() is similar to trylock(s_umount), the difference is that
sb_want_write() is more complex.

> 
> Now, you might want to move those sysfs entry removals to the very beginning
> of btrfs_kill_super(), but that's a different story - you need only to make
> sure that they are removed not later than the destruction of the data
> structures they need (IOW, the current location might very well be OK - I
> hadn't checked the details).

Yes, we need move those sysfs entry removals, but needn't move to the very
beginning of btrfs_kill_super(), just at the beginning of close_ctree();

The current location is not right, it will introduce the use-after-free
problem. because we remove the sysfs entry after we release
transaction_kthread, use-after-free problem might happen in this case
	Task1				Task2
	change Label by sysfs
					close_ctree
					  kthread_stop(transaction_kthread);
	  change label
	  wake_up(transaction_kthread)


Thanks
Miao

> 
> As for "it won't go r/o under us" - sb_want_write() will do that just fine.
> .
> 

