Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from oul135-36.netplaza.fi ([80.75.100.36]:41962 "EHLO
	lime.offcode.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbbDAH17 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 03:27:59 -0400
Message-ID: <551B9DF9.9060702@offcode.fi>
Date: Wed, 01 Apr 2015 10:27:53 +0300
From: Timo Kokkonen <timo.kokkonen@offcode.fi>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: prevent deletion of mounted subvolumes
References: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com> <20150330123034.GB32051@suse.cz> <20150330184135.GA27227@mew.dhcp4.washington.edu> <87k2xwv6y8.fsf@x220.int.ebiederm.org> <20150401070328.GA27048@mew>
In-Reply-To: <20150401070328.GA27048@mew>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 01.04.2015 10:03, Omar Sandoval wrote:
> On Tue, Mar 31, 2015 at 10:54:55PM -0500, Eric W. Biederman wrote:
>> Omar Sandoval <osandov@osandov.com> writes:
>>
>>> On Mon, Mar 30, 2015 at 02:30:34PM +0200, David Sterba wrote:
>>>> On Mon, Mar 30, 2015 at 02:02:17AM -0700, Omar Sandoval wrote:
>>>>> Before commit bafc9b754f75 ("vfs: More precise tests in d_invalidate"),
>>>>> d_invalidate() could return -EBUSY when a dentry for a directory had
>>>>> more than one reference to it. This is what prevented a mounted
>>>>> subvolume from being deleted, as struct vfsmount holds a reference to
>>>>> the subvolume dentry. However, that commit removed that case, and later
>>>>> commits in that patch series removed the return code from d_invalidate()
>>>>> completely, so we don't get that check for free anymore. So, reintroduce
>>>>> it in btrfs_ioctl_snap_destroy().
>>>>
>>>>> This applies to 4.0-rc6. To be honest, I'm not sure that this is the most
>>>>> correct fix for this bug, but it's equivalent to the pre-3.18 behavior and it's
>>>>> the best that I could come up with. Thoughts?
>>>>
>>>>> +	spin_lock(&dentry->d_lock);
>>>>> +	err = dentry->d_lockref.count > 1 ? -EBUSY : 0;
>>>>> +	spin_unlock(&dentry->d_lock);
>>>>
>>>> The fix restores the original behaviour, but I don't think opencoding and
>>>> using internals is fine. Either there should be a vfs api for that or
>>>> there's an existing one that can be used instead.
>>
>> I have a problem with restoring the original behavior as is.
>>
>> In some sense it re-introduces the security issue that the d_invalidate
>> changes were built to fix.
>>
>> Any user in the system can create a user namespace, create a mount
>> namespace and keep any subvolume pinned forever.  Which at the very
>> least could make a very nice DOS attack.  I am not familiar enough with
>> how people use subvolumes and
>>
>> So let me ask.  How can userspace not know that a subvolume that they
>> want to delete is already mounted?
>>
>
> Currently, the entry in /proc/mounts doesn't tell you which subvolume is
> mounted. The fix for that could be as simple as:
>
> ----
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 05fef19..9492d83 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1024,6 +1024,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>   	struct btrfs_root *root = info->tree_root;
>   	char *compress_type;
>
> +	if (dentry != dentry->d_sb->s_root) {
> +		seq_puts(seq, ",subvol=");
> +		seq_dentry(seq, dentry, " \t\n\\");
> +	}
>   	if (btrfs_test_opt(root, DEGRADED))
>   		seq_puts(seq, ",degraded");
>   	if (btrfs_test_opt(root, NODATASUM))
> ----
>
> Then, maybe this policy could be pushed up to userspace. It feels
> awkward to do it in the kernel, but users are apparently depending on
> this behavior. Timo, do you mind sharing some more details about how
> your scripts ran into the bug?
>

We are choosing the active subvolume via kernel command line parameter, eg:

root=/dev/mmcblk0p3 rw rootwait rootflags=subvol=/foobar

In the user space we run a script that does some upgrades on the root 
file system and in the process creates new subvolumes and deletes old 
ones. For this to work we mount the root subvolume "eg. /" onto 
somewhere so we can take a new snapshot from the currently active 
subvolume, eg.

mount /dev/mmcblk0p3 /mnt/root
btrfs subvolume snapshot /mnt/root/foobar /mnt/root/new_foobar
btrfs subvolume delete /mnt/root/old_foobar

and such. But if it happens that user gives faulty names for the 
subvolumes to operate with, the script might delete the subvolume that 
is the same where the device root file system is mounted from. That is, 
there is not anything anymore that prevents user from running this command:

btrfs subvolume delete /mnt/root/foobar

Once you delete the this subvolume, things obviously collapse into halt 
pretty soon as the userspace expects "/" to be present on the system.

That is something that is obviously wrong thing for the user to do to 
begin with, easily avoidable with more careful scripting. But I can 
think this is very bad if the user is doing root file system snapshot 
management by hand and might easily delete his mounted root file system 
by accident. And I can't think of any reason why kernel should allow 
user to do this.

I hope this clears up things a bit.

-Timo

>> I can see having something like is_local_mount_root and denying the
>> subvolume destruction if the mount that is pinning it is in your local
>> mount namespace.
>>
>>
>>>> The bug here seems defined up to the point that we're trying to delete a
>>>> subvolume that's a mountpoint. My next guess is that a check
>>>>
>>>> 	if (d_mountpoint(&dentry)) { ... }
>>>>
>>>> could work.
>>>
>>> That was my first instinct as well, but d_mountpoint() is true for
>>> dentries that have a filesystem mounted on them (e.g., after mount
>>> /dev/sda1 /mnt, the dentry for "/mnt"), not the dentry that is mounted.
>>>
>>> I poked around the mount code for awhile and couldn't come up with
>>> anything using the existing interface. Mounting subvolumes bubbles down
>>> to mount_subtree(), which doesn't really leave any traces of which
>>> subvolume is mounted except for the dentry in struct vfsmount.
>>>
>>> (As far as I can tell, under the covers subvolume deletion is more or
>>> less equivalent to an rm -rf, and we obviously don't do anything to stop
>>> users from doing that on the root of their mounted filesystem, but it
>>> appears that users expect the original behavior.)
>>>
>>> Here's an idea: mark mount root dentries as such in the VFS and check it
>>> in the Btrfs code. Adding fsdevel ML for comments
>>> (https://lkml.org/lkml/2015/3/30/125 is the original message).
>>
>> Marking root dentries is needed to fix the bug that you can escape
>> the limitations of loopback mounts with a carefully placed rename.
>>
>> I have a patch cooking that marks mountpoints and tracks all of the
>> mounts on a dentry.  So except for the possibility of stepping on each
>> others toes I have no objections.
>>
>
> We'll see how the discussion here plays out. I'll keep an eye out for
> it, feel free to Cc me.
>
>> Eric
>>
>>> ----
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 74609b9..8a0933d 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -2384,6 +2384,11 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>>>   		goto out_dput;
>>>   	}
>>>
>>> +	if (d_is_mount_root(dentry)) {
>>> +		err = -EBUSY;
>>> +		goto out_dput;
>>> +	}
>>> +
>>>   	mutex_lock(&inode->i_mutex);
>>>
>>>   	/*
>>> diff --git a/fs/namespace.c b/fs/namespace.c
>>> index 82ef140..a28ca15 100644
>>> --- a/fs/namespace.c
>>> +++ b/fs/namespace.c
>>> @@ -920,6 +920,10 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
>>>   		return ERR_CAST(root);
>>>   	}
>>>
>>> +	spin_lock(&root->d_lock);
>>> +	root->d_flags |= DCACHE_MOUNT_ROOT;
>>> +	spin_unlock(&root->d_lock);
>>> +
>>>   	mnt->mnt.mnt_root = root;
>>>   	mnt->mnt.mnt_sb = root->d_sb;
>>>   	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
>>> @@ -1017,6 +1021,8 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
>>>
>>>   static void cleanup_mnt(struct mount *mnt)
>>>   {
>>> +	struct dentry *root = mnt->mnt.mnt_root;
>>> +
>>>   	/*
>>>   	 * This probably indicates that somebody messed
>>>   	 * up a mnt_want/drop_write() pair.  If this
>>> @@ -1031,7 +1037,10 @@ static void cleanup_mnt(struct mount *mnt)
>>>   	if (unlikely(mnt->mnt_pins.first))
>>>   		mnt_pin_kill(mnt);
>>>   	fsnotify_vfsmount_delete(&mnt->mnt);
>>> -	dput(mnt->mnt.mnt_root);
>>> +	spin_lock(&root->d_lock);
>>> +	root->d_flags &= ~DCACHE_MOUNT_ROOT;
>>> +	spin_unlock(&root->d_lock);
>>> +	dput(root);
>>>   	deactivate_super(mnt->mnt.mnt_sb);
>>>   	mnt_free_id(mnt);
>>>   	call_rcu(&mnt->mnt_rcu, delayed_free_vfsmnt);
>>> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
>>> index d835879..d974ab8 100644
>>> --- a/include/linux/dcache.h
>>> +++ b/include/linux/dcache.h
>>> @@ -225,6 +225,7 @@ struct dentry_operations {
>>>
>>>   #define DCACHE_MAY_FREE			0x00800000
>>>   #define DCACHE_FALLTHRU			0x01000000 /* Fall through to lower layer */
>>> +#define DCACHE_MOUNT_ROOT		0x02000000 /* is the root of a mount */
>>>
>>>   extern seqlock_t rename_lock;
>>>
>>> @@ -401,6 +402,16 @@ static inline bool d_mountpoint(const struct dentry *dentry)
>>>   	return dentry->d_flags & DCACHE_MOUNTED;
>>>   }
>>>
>>> +static inline bool d_is_mount_root(const struct dentry *dentry)
>>> +{
>>> +	bool ret;
>>> +
>>> +	spin_lock(&dentry->d_lock);
>>> +	ret = dentry->d_flags & DCACHE_MOUNT_ROOT;
>>> +	spin_unlock(&dentry->d_lock);
>>> +	return ret;
>>> +}
>>> +
>>>   /*
>>>    * Directory cache entry type accessor functions.
>>>    */
>>> ----
>

