From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: R: Re: [PATCH 5/5] btrfs: Add ioctl to set snapshot
 readonly/writable
Date: Tue, 30 Nov 2010 08:52:53 +0100 (CET)
Message-ID: <13025594.9851291103573101.JavaMail.defaultUser@defaultHost>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Li,

>----Messaggio originale----
>Da: lizf@cn.fujitsu.com
>Data: 30/11/2010 8.03
>A: <kreijack@libero.it>
>Cc: <linux-btrfs@vger.kernel.org>
>Ogg: Re: [PATCH 5/5] btrfs: Add ioctl to set snapshot readonly/writable
>
>Goffredo Baroncelli wrote:
>> Hi Li,
>> 
>> On Monday, 29 November, 2010, Li Zefan wrote:
>>> This allows us to set a snapshot readonly or writable on the fly.
>>>
>>> Usage:
>>>
>>> Set BTRFS_SNAPSHOT_RDONLY/WRITABLE of btrfs_ioctl_vol_arg_v2->flags,
>>> and then call ioctl(BTRFS_IOCTL_SNAP_SETFLAGS);
>> 
>> I really appreciate your work, but I have some doubt about this interface. 
In 
>> particolar:
>
>It's the interface that I would like to be discussed. Thanks!
>
>> - how get the flags of a subvolume ? I suggest to implement a pair of 
ioctls:
>> 	- subvolume_setflags  -> get the flags
>> 	- subvolume_getflags  -> set the flags
>> These ioctls would be more generic (there are a lot of flags which may be 
>> interested to put in the "root" of a subvolume: think about 
>> compress/nocompress, (no)datasum...)
>> - For the reason abowe, I suggest to replace SNAPSHOT with SUBVOLUME
>> - Finally, with a pair of  get/set_flags functions we can avoid the use of 
the 
>> flags BTRFS_SNAPSHOT_WRITABLE.
>> 
>
>There are some reasons that I created this interface:
>
>- set/getflags should set/get root flags which reflect in struct
>btrfs_root_item->flags.
>
>- btrfs_root_item->flags was not used at all before this patch, so
>(no)compress and (no)datasum is not reflect in ->flags.
>
>- _CREATE_ASYNC flag is to create snapshot asynchronously, so it's not
>a flag of tree root.

Of course I never mind about  _CREATE_ASYNC to be set in btrfs_root_item-
>flags. 
_CREATE_ASYNC is not a snapshot properties but a way of creating a subvolume.
But other flags may make sense to live in btrfs_root_item->flags.
 So I am suggesting to develop a more general 
interface for future improvement. These pair of functions (*_set/get) should 
be use to 
set the subvolume/snapshot properties. And the RDONLY is one of them.

In the detail to set an attributue an user should be:

- get the subvolume flags (ioctl(fd, BTRFS_IOC_SNAP_GETFLAGS....) )
- compute the new flags ( flags |= BTRFS_FLAGS_XXXX or flags &= 
~BTRFS_FLAG_XXXX)
- set the subvolume flags (ioctl(fd, BTRFS_IOC_SNAP_SGETFLAGS....) )

>
>- It seems to me there's no user requirement for getflags ioctl to
>return _RDONLY/_WRITABLE flags of a tree root?

And how an user/admin can understand that a snapshot/subvolume is readonly ? 
How 

>
>- By suggesting BTRFS_SUBVOL_RDONLY, does it impliy not only snapshot
>but also a subvolume can be made readonly?

IIRC a snapshot is a subvolume already filled from the beginning. Why doesn't 
share 
the capability of make a subvolume RO ?

Finally I have another suggestion: make sense to check that the file 
descriptor is referring 
to the root of a subvolume instead of a the tree. I highlight that because the 
other ioctls
suffer  the same problem and confused the user sometime. For example a lot of
people tough that was possible to snapshot a directory, because the ioctl 
doesn't return
any error. But instead of the directory the snapshot was of the full 
subvolume.

Goffredo

[...]

