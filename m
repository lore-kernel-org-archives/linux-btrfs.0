Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8490 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754115AbbGUIiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 04:38:13 -0400
Subject: Re: Can't mount btrfs volume on rbd
To: Steve Dainard <sdainard@spd1.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
 <557A890D.8080306@cn.fujitsu.com>
 <CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
 <557E877E.2060704@cn.fujitsu.com>
 <CAEMJtDusywPEnDcNcMvvFKQsuZyTmSMXXgJT=eBZX1F+R8RM8w@mail.gmail.com>
 <557F7B82.2060203@cn.fujitsu.com>
 <CAEMJtDv1Tm7-O2mU03kZhPDkaSj7nVi+VAZVhPfh7BN8AuF2Bg@mail.gmail.com>
 <55A46473.8070106@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55AE04EF.6040807@cn.fujitsu.com>
Date: Tue, 21 Jul 2015 16:38:07 +0800
MIME-Version: 1.0
In-Reply-To: <55A46473.8070106@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Steve,

I checked your binary dump.

Previously I was too focused on the assert error, but ignored some even 
larger bug...

As for the btrfs-debug-tree output, subvol 257 and 5 are completely 
corrupted.
Subvol 257 seems to contains a new tree root, and 5 seems to contains a 
new device tree.

------
fs tree key (FS_TREE ROOT_ITEM 0)
leaf 29409280 items 8 free space 15707 generation 9 owner 4
fs uuid 1bb22a03-bc25-466f-b078-c66c6f6a6d28
chunk uuid 11cca6df-e850-45d7-a928-cdff82c5f295
         item 0 key (0 DEV_STATS 1) itemoff 16243 itemsize 40
                 device stats
         item 1 key (1 DEV_EXTENT 0) itemoff 16195 itemsize 48
                 dev extent chunk_tree 3
                 chunk objectid 256 chunk offset 0 length 4194304
         item 2 key (1 DEV_EXTENT 4194304) itemoff 16147 itemsize 48
                 dev extent chunk_tree 3
                 chunk objectid 256 chunk offset 4194304 length 8388608
         item 3 key (1 DEV_EXTENT 12582912) itemoff 16099 itemsize 48
                 dev extent chunk_tree 3
......
# DEV_EXTENT should never occur in fs tree. It should only occurs in
# dev tree

file tree key (257 ROOT_ITEM 0)
leaf 29376512 items 13 free space 12844 generation 9 owner 1
fs uuid 1bb22a03-bc25-466f-b078-c66c6f6a6d28
chunk uuid 11cca6df-e850-45d7-a928-cdff82c5f295
         item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
                 root data bytenr 29392896 level 0 dirid 0 refs 1 gen 9
                 uuid 00000000-0000-0000-0000-000000000000
         item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
                 root data bytenr 29409280 level 0 dirid 0 refs 1 gen 9
                 uuid 00000000-0000-0000-0000-000000000000
         item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
                 inode ref index 0 namelen 7 name: default
         item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
                 root data bytenr 29360128 level 0 dirid 256 refs 1 gen 4
                 uuid 00000000-0000-0000-0000-000000000000
         item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14789 itemsize 160
                 inode generation 3 transid 0 size 0 nbytes 16384
                 block group 0 mode 40755 links 1 uid 0 gid 0
                 rdev 0 flags 0x0
# These things are only in tree root.
------

So the problem is, the kernel you use has some bug (btrfs or rbd 
related), causing the btrfs write wrong tree blocks into existing tree 
blocks.

For such case, btrfsck won't be able to fix the critical error.
And I didn't even have an idea to fix the assert to change it into a 
normal error. As it's corrupting the whole structure of btrfs...

I can't even recall such critical btrfs bug...


Not familiar with rbd, but will it allow a block device to be mounted on 
different systems?

Like exporting a device A to system B and system C, and both system B 
and system C mounting device A at the same time as btrfs?

Thanks,
Qu

Qu Wenruo wrote on 2015/07/14 09:22 +0800:
> Thanks a lot Steve!
>
> With this binary dump, we can find out what's the cause of your problem
> and makes btrfsck handle and repair it.
>
> Further more, this provides a good hint on what's going wrong in kernel.
>
> I'll start investigating this right now.
>
> Thanks,
> Qu
>
> Steve Dainard wrote on 2015/07/13 13:22 -0700:
>> Hi Qu,
>>
>> I ran into this issue again, without pacemaker involved, so I'm really
>> not sure what is triggering this.
>>
>> There is no content at all on this disk, basically it was created with
>> a btrfs filesystem, mounted, and now after some reboots later (and
>> possibly hard resets) won't mount with a stale file handle error.
>>
>> I've DD'd the 10G disk and tarballed it to 10MB, I'll send it to you
>> in another email so the attachment doesn't spam the list.
>>
>> Thanks,
>> Steve
>>
>> On Mon, Jun 15, 2015 at 6:27 PM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>>
>>> Steve Dainard wrote on 2015/06/15 09:19 -0700:
>>>>
>>>> Hi Qu,
>>>>
>>>> # btrfs --version
>>>> btrfs-progs v4.0.1
>>>> # btrfs check /dev/rbd30
>>>> Checking filesystem on /dev/rbd30
>>>> UUID: 1bb22a03-bc25-466f-b078-c66c6f6a6d28
>>>> checking extents
>>>> cmds-check.c:3735: check_owner_ref: Assertion `rec->is_root` failed.
>>>> btrfs[0x41aee6]
>>>> btrfs[0x423f5d]
>>>> btrfs[0x424c99]
>>>> btrfs[0x4258f6]
>>>> btrfs(cmd_check+0x14a3)[0x42893d]
>>>> btrfs(main+0x15d)[0x409c71]
>>>> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f29ce437af5]
>>>> btrfs[0x409829]
>>>>
>>>> # btrfs-image /dev/rbd30 rbd30.image -c9
>>>> # btrfs-image -r rbd30.image rbd30.image.2
>>>> # mount rbd30.image.2 temp
>>>> mount: mount /dev/loop0 on /mnt/temp failed: Stale file handle
>>>
>>> OK, my assumption are all wrong.
>>>
>>> I'd better check the debug-tree output more carefully.
>>>
>>> BTW, the rbd30 is the block device which you took the debug-tree output?
>>>
>>> If so, would you please do a dd dump of it and send it to me?
>>> If it contains important/secret info, just forget this.
>>>
>>> Maybe I can improve the btrfsck tool to fix it.
>>>
>>>>
>>>> I have a suspicion this was caused by pacemaker starting
>>>> ceph/filesystem resources on two nodes at the same time,I haven't
>>>> been able to replicate the issue after hard poweroff if ceph/btrfs are
>>>> not being controlled by pacemaker.
>>>
>>> Did you mean mount the same device on different system?
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Thanks for your help.
>>>>
>>>>
>>>>
>>>> On Mon, Jun 15, 2015 at 1:06 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> wrote:
>>>>>
>>>>> The debug result seems valid.
>>>>> So I'm afraid the problem is not in btrfs.
>>>>>
>>>>> Would your please try the following 2 things to eliminate btrfs
>>>>> problems?
>>>>>
>>>>> 1) btrfsck from 4.0.1 on the rbd
>>>>>
>>>>> If assert still happens, please update the image of the volume(dd
>>>>> image),
>>>>> to
>>>>> help us improve btrfs-progs.
>>>>>
>>>>> 2) btrfs-image dump and rebuilt the fs into other place.
>>>>>
>>>>> # btrfs-image <RBD_DEV> <tmp_file1> -c9
>>>>> # btrfs-image -r <tmp_file1> <tmp_file2>
>>>>> # mount <tmp_file2> <mnt>
>>>>>
>>>>> This will dump all metadata from <RBD_DEV> to <tmp_file1>,
>>>>> and then use <tmp_file1> to rebuild a image called <tmp_file2>.
>>>>>
>>>>> If <tmp_file2> can be mounted, then the metadata in the RBD device is
>>>>> completely OK, and we can make conclusion the problem is not caused by
>>>>> btrfs.(maybe ceph?)
>>>>>
>>>>> BTW, all the commands are recommended to be executed on the device
>>>>> which
>>>>> you
>>>>> get the debug info from.
>>>>> As it's a small and almost empty device, so commands execution
>>>>> should be
>>>>> quite fast on it.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>
>>>>> 在 2015年06月13日 00:09, Steve Dainard 写道:
>>>>>>
>>>>>>
>>>>>> Hi Qu,
>>>>>>
>>>>>> I have another volume with the same error, btrfs-debug-tree output
>>>>>> from btrfs-progs 4.0.1 is here: http://pastebin.com/k3R3bngE
>>>>>>
>>>>>> I'm not sure how to interpret the output, but the exit status is 0 so
>>>>>> it looks like btrfs doesn't think there's an issue with the file
>>>>>> system.
>>>>>>
>>>>>> I get the same mount error with options ro,recovery.
>>>>>>
>>>>>> On Fri, Jun 12, 2015 at 12:23 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> -------- Original Message  --------
>>>>>>> Subject: Can't mount btrfs volume on rbd
>>>>>>> From: Steve Dainard <sdainard@spd1.com>
>>>>>>> To: <linux-btrfs@vger.kernel.org>
>>>>>>> Date: 2015年06月11日 23:26
>>>>>>>
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> I'm getting an error when attempting to mount a volume on a host
>>>>>>>> that
>>>>>>>> was forceably powered off:
>>>>>>>>
>>>>>>>> # mount /dev/rbd4 climate-downscale-CMIP5/
>>>>>>>> mount: mount /dev/rbd4 on /mnt/climate-downscale-CMIP5 failed:
>>>>>>>> Stale
>>>>>>>> file
>>>>>>>> handle
>>>>>>>>
>>>>>>>> /var/log/messages:
>>>>>>>> Jun 10 15:31:07 node1 kernel: rbd4: unknown partition table
>>>>>>>>
>>>>>>>> # parted /dev/rbd4 print
>>>>>>>> Model: Unknown (unknown)
>>>>>>>> Disk /dev/rbd4: 36.5TB
>>>>>>>> Sector size (logical/physical): 512B/512B
>>>>>>>> Partition Table: loop
>>>>>>>> Disk Flags:
>>>>>>>>
>>>>>>>> Number  Start  End     Size    File system  Flags
>>>>>>>>      1      0.00B  36.5TB  36.5TB  btrfs
>>>>>>>>
>>>>>>>> # btrfs check --repair /dev/rbd4
>>>>>>>> enabling repair mode
>>>>>>>> Checking filesystem on /dev/rbd4
>>>>>>>> UUID: dfe6b0c8-2866-4318-abc2-e1e75c891a5e
>>>>>>>> checking extents
>>>>>>>> cmds-check.c:2274: check_owner_ref: Assertion `rec->is_root`
>>>>>>>> failed.
>>>>>>>> btrfs[0x4175cc]
>>>>>>>> btrfs[0x41b873]
>>>>>>>> btrfs[0x41c3fe]
>>>>>>>> btrfs[0x41dc1d]
>>>>>>>> btrfs[0x406922]
>>>>>>>>
>>>>>>>>
>>>>>>>> OS: CentOS 7.1
>>>>>>>> btrfs-progs: 3.16.2
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> The btrfs-progs seems quite old, and the above btrfsck error seems
>>>>>>> quite
>>>>>>> possible related to the old version.
>>>>>>>
>>>>>>> Would you please upgrade btrfs-progs to 4.0 and see what will
>>>>>>> happen?
>>>>>>> Hopes it can give better info.
>>>>>>>
>>>>>>> BTW, it's a good idea to call btrfs-debug-tree /dev/rbd4 to see the
>>>>>>> output.
>>>>>>>
>>>>>>> Thanks
>>>>>>> Qu.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Ceph: version: 0.94.1/CentOS 7.1
>>>>>>>>
>>>>>>>> I haven't found any references to 'stale file handle' on btrfs.
>>>>>>>>
>>>>>>>> The underlying block device is ceph rbd, so I've posted to both
>>>>>>>> lists
>>>>>>>> for any feedback. Also once I reformatted btrfs I didn't get a
>>>>>>>> mount
>>>>>>>> error.
>>>>>>>>
>>>>>>>> The btrfs volume has been reformatted so I won't be able to do much
>>>>>>>> post mortem but I'm wondering if anyone has some insight.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Steve
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-btrfs"
>>>>>>>> in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>
>>>>>>>
>>>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
