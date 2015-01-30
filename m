Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57451 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752517AbbA3BLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 20:11:31 -0500
Message-ID: <54CADA3E.6050306@cn.fujitsu.com>
Date: Fri, 30 Jan 2015 09:11:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to
 get vfsmount from a given sb.
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com> <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com> <20150129123758.GJ3641@twin.jikos.cz> <20150129152347.GE29656@ZenIV.linux.org.uk>
In-Reply-To: <20150129152347.GE29656@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function 
to get vfsmount from a given sb.
From: Al Viro <viro@ZenIV.linux.org.uk>
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
<linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: 2015年01月29日 23:23
> On Thu, Jan 29, 2015 at 01:37:58PM +0100, David Sterba wrote:
>> Adding Al Viro into CC
>>
>> On Thu, Jan 29, 2015 at 10:24:39AM +0800, Qu Wenruo wrote:
>>> +struct vfsmount *get_vfsmount_sb(struct super_block *sb)
>>> +{
>>> +	struct vfsmount *ret_vfs = NULL;
>>> +	struct mount *mnt;
>>> +	int ret = 0;
>>> +
>>> +	lock_mount_hash();
>>> +	if (list_empty(&sb->s_mounts))
>>> +		goto out;
>>> +	mnt = list_entry(sb->s_mounts.next, struct mount, mnt_instance);
>> from include/linux/fs.h:
>>
>> struct super_block {
>> ...
>> 	struct list_head        s_mounts;       /* list of mounts; _not_ for fs use */
>> ...
>> };
>>
>> I hear a storm in the distance coming our direction ... so I'll
>> preemptively NAK this change.
> Could you explain what the devil is that for?
In sysfs interface handler, we don't have struct file or vfsmount to do 
the mnt_want_write* protection,
so this function is introduced to get a vfsmount and do the protection.
> The primitive looks rather
> bogus - if nothing else, it includes "make random instance of the filesystem
> in someone's namespace appear busy to umount", which doesn't look like a
> part of useful interface...
This is the problem I didn't find a good way to avoid.

If using the function, it will always use the first(or last?) vfsmount 
of the filesystem.
For 1 to 1 match case, it's OK, but if one device is mounted on multiple 
mount points,
it will delay the umount of that mount point. But we only need to keep 
at least one rw mount point exists.
>    The only piece of context I'd been able to find
> was something vague about sysfs-inflicted operations and wanting to use
> mnt_want_write() but having nothing to pass it; BTW, what if the (random)
> instance you run into happens to mounted r/o?
For the mounted ro case, that's not a problem, since if one instance is 
mounted ro,
other instances are also mounted ro, so that's not a problem.

>
> Assuming that your superblock is guaranteed to stay alive and usable for
> whatever work you are trying to do, what's wrong with sb_want_write()?
Did you mean change the function name and it's parameter to 
sb_want_write(sb) and sb_drop_write(sb).
That looks much better.
But I'm a little worried about just using sb_start_write() and 
s_readonly_remount/s_flags to do the protection,
will it be enough?

Thanks,
Qu
>   
>
> If it's _not_ guaranteed to stay so, and this is what you are trying to
> solve, you are doing that at the wrong level - just take sysfs entry
> removals earlier in shutdown process and be done with that.  Beginning of
> close_ctree() would probably be early enough to be safe, but if that's
> not enough, you can take it into the beginning of btrfs_kill_super().

