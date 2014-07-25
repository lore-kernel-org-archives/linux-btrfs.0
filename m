Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56525 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934873AbaGYAkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 20:40:47 -0400
Message-ID: <53D1A78E.8020802@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 08:40:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Add show_path function for btrfs_super_ops.
References: <1405933349-6215-1-git-send-email-quwenruo@cn.fujitsu.com> <20140724130928.GY1553@twin.jikos.cz>
In-Reply-To: <20140724130928.GY1553@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the comment.

-------- Original Message --------
Subject: Re: [PATCH] btrfs: Add show_path function for btrfs_super_ops.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月24日 21:09
> On Mon, Jul 21, 2014 at 05:02:29PM +0800, Qu Wenruo wrote:
>> show_path() function in struct super_operations is used to output
>> subtree mount info for mountinfo.
>> Without the implement of show_path() function, user can not found where
>> each subvolume is mounted if using 'subvolid=' mount option.
>> (When mounted with 'subvol=' mount option, vfs is aware of subtree mount
>> and can to the path resolve by vfs itself)
> Your previous patches unify both to call mount_subtree, then the default
> vfs implementation of show_path will do the right thing, ie
> seq_dentry(...), and the path will be resolved for free.
>
> Means this patch is not needed, so I'll skip commenting it.

I'm sorry that I forgot to mention this patch is going to replace the 
previous patch(use mount_subtree method).

Since vfs provide the show_path() function to do the fs specific subtree 
showing things,
I would like to use it other than previous mount_subtree() trick.

Also. as mentioned by Chandan Rajendra, previous subtree patch can't 
handle subvolume behind normal directory.
This show_path() patch is somewhat v2 version of previous patch.
>
>> With this patch, end users will be able to use findmnt(8) or other
>> programs reading mountinfo to find which btrfs subvolume is mounted.
>>
>> Though we use fs_info->subvol_sem to protect show_path() from subvolume
>> destroying/creating, if user renames/moves the parent non-subvolume
>> dir of a subvolume, it is still possible that concurrency may happen and
>> cause btrfs_search_slot() fails to find the desired key.
>> In that case, we just return -EBUSY and info user to try again since
>> extra locking like locking the whole subvolume tree is too expensive for
>> such usage.
> And the subvolume renames will be handled as well.
