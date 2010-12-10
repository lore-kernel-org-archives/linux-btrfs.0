From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: R: Re: [PATCH v2 5/5] Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS
 ioctl
Date: Fri, 10 Dec 2010 09:18:08 +0100 (CET)
Message-ID: <8570787.1939201291969088397.JavaMail.root@wmail54>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



>----Messaggio originale----
>Da: lizf@cn.fujitsu.com
>Data: 10/12/2010 8.12
>A: <kreijack@libero.it>
>Cc: <linux-btrfs@vger.kernel.org>
>Ogg: Re: [PATCH v2 5/5] Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS ioctl
>
>Goffredo Baroncelli wrote:
>> Hi Li,
>> 
>> On Thursday, 09 December, 2010, Li Zefan wrote:
>>> This allows us to set a snapshot or a subvolume readonly or writable
>>> on the fly.
>>>
>>> Usage:
>>>
>>> Set BTRFS_SUBVOL_RDONLY of btrfs_ioctl_vol_arg_v2->flags, and then
>>> call ioctl(BTRFS_IOCTL_SUBVOL_SETFLAGS);
[...]
>>> +	/* nothing to do */
>>> +	if (!!(flags & BTRFS_SUBVOL_RDONLY) == root->readonly)
>>> +		goto out_unlock;
>> 
>> This is only an aesthetic comment: I prefer a simpler style like
>> 
>> 	if ((flags & BTRFS_SUBVOL_RDONLY) && root->readonly)
>> 		goto out_unlock;
>> 
>
>They are not equivalent. The former checks if the flags and the
>root both have readonly bit set or cleared.

Right, my fault

>> But I know that every body has its style :-)
>> 
>>> +
>>> +	root_flags = btrfs_root_flags(&root->root_item);
>>> +	if (flags & BTRFS_SUBVOL_RDONLY)
>>> +		btrfs_set_root_flags(&root->root_item,
>>> +				     root_flags | BTRFS_ROOT_SNAP_RDONLY);
>>> +	else
>>> +		btrfs_set_root_flags(&root->root_item,
>>> +				     root_flags & ~BTRFS_ROOT_SNAP_RDONLY);
>>> +	root->readonly = !root->readonly;
>> 
>> I double checked this line. But if I read the code correctly I think that 
the 
>> line above is wrong: the field "root->readonly" is flipped regardless the 
>> value of the flags passed by the user.
>> 
>
>Yep, that's because if we don't need to flip it, we've already exited early.
>
>Note, there's only one flag.

Yes, it is true. However I strongly suggest to avoid that. If someone adds 
another flag this may miss... 
Obviously if we get rid of the root->readonly we solve at the root the problem 
:)

>> Moreover I have another question: why internally the flags is 
>> BTRFS_ROOT_SNAP_RDONLY, instead in user space the flag is 
BTRFS_SUBVOL_RDONLY 
>> ? 
>> 
>
>That's my carelessness..
>
>> I suggest to 
>> - rename BTRFS_SUBVOL_RDONLY in BTRFS_SUBVOL_CREATE_SNAP_RDONLY (like 
>> BTRFS_SUBVOL_CREATE_SNAP_ASYNC)
>> - rename BTRFS_ROOT_SNAP_RDONLY in BTRFS_ROOT_FLAGS_RDONLY and use both 
in 
>> userspace and in kernel space this flag. I suggested to remove SNAP 
because 
>> the flag make sense also for a "standard" subvolume.
>> 
>
>I'd prefer not to mix flags for root_item flags and vol ioctl flags.
>
>And CREATE_RDONLY and CREATE_ASYNC can also be valid for subvolumes too.
>Support for async subvolume creation is already there, just lack of an
>user interface. So I've changed _CREATE_SNAP_ASYNC to _CREATE_ASYNC
>in the patch I sent just now.

I fully gree

>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


