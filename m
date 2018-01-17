Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38437 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753054AbeAQOgt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 09:36:49 -0500
Received: by mail-wm0-f54.google.com with SMTP id 141so16098942wme.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 06:36:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7bb8f56a-75d6-8235-5a46-d1dfe1dbf8f5@gmx.com>
References: <CAJUuSvFtEG=CZPjhACCvp8hVA83xFuFpJcScx4xAj4tPkW8uCw@mail.gmail.com>
 <CAJUuSvHo6N+esmjX8+Ly+kV+Nm1bUB=f85Mv=_xoyiLaUFA-ug@mail.gmail.com>
 <20170301180817.GJ4662@suse.cz> <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
 <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
 <e9ccb880-dfb3-aba6-d05a-869c53ec69d8@gmx.com> <CAJUuSvFCNmCiXwPdswsBdofs2UmtuTJA-xTnhvPKwu6OT9+9Zw@mail.gmail.com>
 <60b03797-ff8b-0e51-f72c-66e0ada596b7@suse.com> <CAJUuSvGcx3oMMmj=goXurrMRsYpmxjSA8aPmGvrgMTjYbSGz+A@mail.gmail.com>
 <CAJUuSvF51_ZTpQk7QjFC5_o=y5DLAn--4=Kmyy3ei-A0DQuRjQ@mail.gmail.com>
 <1431a38e-f7ec-3286-a468-50bce9a952da@gmx.com> <CAJUuSvGSG4nM5Cie_vwXg3p95Wfu1rRsCKft6cqvuiWpvOW=kg@mail.gmail.com>
 <4897b464-7212-f92c-c6cf-6fbfd04ec30c@gmx.com> <CAJUuSvH2EzQnPorkyPOrGNyCkWaumoLEf8YY4DDqK-BKf4GUqQ@mail.gmail.com>
 <d5a48369-1495-d94d-01e1-81e68048a4f1@gmx.com> <CAJUuSvHwtnmKeoKSYuuUJx2zFxhhUWFun7dB7uuaK9aCgL3HVQ@mail.gmail.com>
 <7bb8f56a-75d6-8235-5a46-d1dfe1dbf8f5@gmx.com>
From: Ilan Schwarts <ilan84@gmail.com>
Date: Wed, 17 Jan 2018 16:36:46 +0200
Message-ID: <CAJUuSvEA5kYHTqHpKKPm+GXaJwTxkV-aFDWSD8CmQOm=UVHAkg@mail.gmail.com>
Subject: Re: Fwd: Fwd: Question regarding to Btrfs patchwork /2831525
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
A new questions for this thread. Thanks in advance.

Given a result from stat:
builder@SLES12X86-64:~> stat /home/builder/myfile1
  File: ‘/home/builder/myfile1’
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 31h/49d Inode: 549453      Links: 1

I understand Device: 31h/49d is the physical device id ?

Executing mount -v:
/dev/sda2 on /srv type btrfs (rw,relatime,space_cache)
/dev/sda2 on /opt type btrfs (rw,relatime,space_cache)
/dev/sda2 on /home type btrfs (rw,relatime,space_cache)

If i stat one of the mountpoints:

builder@SLES12X86-64:~> stat /opt
  File: ‘/opt’
  Size: 120             Blocks: 0          IO Block: 4096   directory
Device: 30h/48d Inode: 256         Links: 1
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2018-01-17 16:28:18.141305151 +0200
Modify: 2018-01-17 16:28:29.245304578 +0200
Change: 2018-01-17 16:28:29.245304578 +0200
 Birth: -
builder@SLES12X86-64:~> stat /home
  File: ‘/home’
  Size: 48              Blocks: 0          IO Block: 4096   directory
Device: 31h/49d Inode: 256         Links: 1


There are different devices (31h/49d, 30h/48d ), but it is still /dev/sda2.


Additional question, 31h/49d, is returned from stat command, when
looking at btrfs source code, stat uses function btrfs_getattr, i see
they call:
static int btrfs_getattr(struct vfsmount *mnt,
struct dentry *dentry, struct kstat *stat)
...
stat->dev = BTRFS_I(inode)->root->anon_dev;
..

When printing from kernel  BTRFS_I(inode)->root->anon_dev - I receive
the number 2. and not 31h/49d.

On Mon, Jan 15, 2018 at 2:13 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年01月15日 20:08, Ilan Schwarts wrote:
>> Thanks for detailed information !
>> Its a legacy code for kernel module i maintain.. dont talk to me about
>> ancient when i need to maintain it to systems like solaris 8 or RHEL4
>> 2.6.9 :(
>
> Well, that's unfortunate, I mean real unforunate...
>
> Despite that, if sticking to device number (dev_t), I think the one in
> super_block->s_dev won't help much.
> Especially it can change when btrfs tries to add/delete devices.
>
> So it will be a very hard time for you to trace device number for btrfs.
>
> Thanks,
> Qu
>
>>
>>
>>
>> On Mon, Jan 15, 2018 at 12:01 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>> On 2018年01月15日 17:24, Ilan Schwarts wrote:
>>>> Qu,
>>>> Given inode, i get the fsid via: inode->i_sb->s_dev;
>>>> this return dev_t and not u8/u16
>>>
>>> That's just a device number.
>>>
>>> Not really useful in btrfs, since btrfs is a multi-device filesystem.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>>
>>>> On Sun, Jan 14, 2018 at 12:44 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>
>>>>>
>>>>> On 2018年01月14日 18:32, Ilan Schwarts wrote:
>>>>>> Thank you for clarification.
>>>>>> Just 2 quick questions,
>>>>>> 1. Sub volumes - 2 sub volumes cannot have 2 same inode numbers ?
>>>>>
>>>>> They can.
>>>>>
>>>>> So to really locate an inode in btrfs, you need:
>>>>>
>>>>> fsid (locate the fs) -> subvolume id (locate subvolume) -> inode number.
>>>>>
>>>>> fsid can be feteched from superblock as mentioned in previous reply.
>>>>>
>>>>> subvolume id can be get from BTRFS_I(inode)->root.
>>>>> And normally root is what you need.
>>>>>
>>>>> If you really want the number, then either
>>>>> BTRFS_I(inode)->root->objectid or
>>>>> BTRFS_I(inode)->root->root_key->objectid will give you the u64 subvolume id.
>>>>>
>>>>>> 2. Why fsInfo fsid return u8 and the traditional file system return
>>>>>> dev_t, usually 32 integer ?
>>>>>
>>>>> As far as I found in xfs or ext4, their fsid is still u8[16] or uuid_t,
>>>>> same as btrfs.
>>>>>
>>>>> For ext4 it's ext4_super_block->s_uuid[16]
>>>>> And for xfs, it's xfs_sb->sb_uuid.
>>>>>
>>>>> I don't know how you get the dev_t parameter.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>>
>>>>>> On Sun, Jan 14, 2018 at 12:22 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 2018年01月14日 18:13, Ilan Schwarts wrote:
>>>>>>>> both btrfs filesystems will have same fsid ?
>>>>>>>>
>>>>>>>>
>>>>>>>> On Sun, Jan 14, 2018 at 12:06 PM, Ilan Schwarts <ilan84@gmail.com> wrote:
>>>>>>>>> But both filesystems will have same fsid?
>>>>>>>>>
>>>>>>>>> On Jan 14, 2018 12:04, "Nikolay Borisov" <nborisov@suse.com> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 14.01.2018 12:02, Ilan Schwarts wrote:
>>>>>>>>>>> First of all, Thanks for response !
>>>>>>>>>>> So if i have 2 btrfs file system on the same machine (not your
>>>>>>>>>>> everyday scenario, i know)
>>>>>>>
>>>>>>> Not a problem, the 2 filesystems will have 2 different fsid.
>>>>>>>
>>>>>>> (And it's my everyday scenario, since fstests neeeds TEST_DEV and
>>>>>>> SCRATCH_DEV_POOL)
>>>>>>>
>>>>>>>>>>> Lets say a file is created on device A, the file gets inode number X
>>>>>>>>>>> is it possible on device B to have inode number X also ?
>>>>>>>>>>> or each device has its own Inode number range ?
>>>>>>>
>>>>>>> Forget the mess about device.
>>>>>>>
>>>>>>> Inode is bounded to a filesystem, not bounded to a device.
>>>>>>>
>>>>>>> Just traditional filesytems are normally bounded to a single device.
>>>>>>> (Although even traditional filesystems can have external journal devices)
>>>>>>>
>>>>>>> So there is nothing to do with device at all.
>>>>>>>
>>>>>>> And you can have same inode numbers in different filesystems, but
>>>>>>> BTRFS_I(inode)->root->fs_info will point to different fs_infos, with
>>>>>>> different fsid.
>>>>>>>
>>>>>>> So return to your initial question:
>>>>>>>> both btrfs filesystems will have same fsid ?
>>>>>>>
>>>>>>> No, different filesystems will have different fsid.
>>>>>>>
>>>>>>> (Unless you're SUUUUUUUUUUUUUUUUUUUPER lucky to have 2 filesystems with
>>>>>>> same fsid)
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>>
>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Of course it is possible. Inodes are guaranteed to be unique only across
>>>>>>>>>> filesystem instances. In your case you are going to have 2 fs instances.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> I need to create unique identifier for a file, I need to understand if
>>>>>>>>>>> the identifier would be: GlobalFSID_DeviceID_Inode or DeviceID_Inode
>>>>>>>>>>> is enough.
>>>>>>>>>>>
>>>>>>>>>>> Thanks
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On Sun, Jan 14, 2018 at 11:13 AM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>>>>>>>>> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On 2018年01月14日 16:33, Ilan Schwarts wrote:
>>>>>>>>>>>>> Hello btrfs developers/users,
>>>>>>>>>>>>>
>>>>>>>>>>>>> I was wondering regarding to fetching the correct fsid on btrfs from
>>>>>>>>>>>>> the context of a kernel module.
>>>>>>>>>>>>
>>>>>>>>>>>> There are two IDs for btrfs. (in fact more, but you properly won't need
>>>>>>>>>>>> the extra ids)
>>>>>>>>>>>>
>>>>>>>>>>>> FSID: Global one, one fs one FSID.
>>>>>>>>>>>> Device ID: Bonded to device, each device will have one.
>>>>>>>>>>>>
>>>>>>>>>>>> So in case of 2 devices btrfs, each device will has its own device id,
>>>>>>>>>>>> while both of the devices have the same fsid.
>>>>>>>>>>>>
>>>>>>>>>>>> And I think you're talking about the global fsid instead of device id.
>>>>>>>>>>>>
>>>>>>>>>>>>> if on suse11.3 kernel 3.0.101-0.47.71-default in order to get fsid, I
>>>>>>>>>>>>> do the following:
>>>>>>>>>>>>> convert inode struct to btrfs_inode struct (use btrfsInode =
>>>>>>>>>>>>> BTRFS_I(inode)), then from btrfs_inode struct i go to root field, and
>>>>>>>>>>>>> from root i take anon_dev or anon_super.s_dev.
>>>>>>>>>>>>>         struct btrfs_inode *btrfsInode;
>>>>>>>>>>>>>         btrfsInode = BTRFS_I(inode);
>>>>>>>>>>>>>        btrfsInode->root->anon_super.s_dev    or
>>>>>>>>>>>>>        btrfsInode->root->anon_dev    - depend on kernel.
>>>>>>>>>>>>
>>>>>>>>>>>> The most directly method would be:
>>>>>>>>>>>>
>>>>>>>>>>>> btrfs_inode->root->fs_info->fsid.
>>>>>>>>>>>> (For newer kernel, as I'm not familiar with older kernels)
>>>>>>>>>>>>
>>>>>>>>>>>> Or from superblock:
>>>>>>>>>>>> btrfs_inode->root->fs_info->super_copy->fsid.
>>>>>>>>>>>> (The most reliable one, no matter which kernel version you're using, as
>>>>>>>>>>>> long as the super block format didn't change)
>>>>>>>>>>>>
>>>>>>>>>>>> For device id, it's not that commonly used unless you're dealing with
>>>>>>>>>>>> chunk mapping, so I'm assuming you're referring to fsid.
>>>>>>>>>>>>
>>>>>>>>>>>> Thanks,
>>>>>>>>>>>> Qu
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> In kernel 3.12.28-4-default in order to get the fsid, i need to go
>>>>>>>>>>>>> to the inode -> superblock -> device id (inode->i_sb->s_dev)
>>>>>>>>>>>>>
>>>>>>>>>>>>> Why is this ? and is there a proper/an official way to get it ?
>>>>>>>>>>>>> --
>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>>>>>>>>>> in
>>>>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>



-- 


-
Ilan Schwarts
