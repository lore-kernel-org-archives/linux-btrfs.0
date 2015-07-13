Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:34923 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbbGMUWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 16:22:24 -0400
Received: by qget71 with SMTP id t71so161967151qge.2
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 13:22:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557F7B82.2060203@cn.fujitsu.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
	<557A890D.8080306@cn.fujitsu.com>
	<CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
	<557E877E.2060704@cn.fujitsu.com>
	<CAEMJtDusywPEnDcNcMvvFKQsuZyTmSMXXgJT=eBZX1F+R8RM8w@mail.gmail.com>
	<557F7B82.2060203@cn.fujitsu.com>
Date: Mon, 13 Jul 2015 13:22:23 -0700
Message-ID: <CAEMJtDv1Tm7-O2mU03kZhPDkaSj7nVi+VAZVhPfh7BN8AuF2Bg@mail.gmail.com>
Subject: Re: Can't mount btrfs volume on rbd
From: Steve Dainard <sdainard@spd1.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

I ran into this issue again, without pacemaker involved, so I'm really
not sure what is triggering this.

There is no content at all on this disk, basically it was created with
a btrfs filesystem, mounted, and now after some reboots later (and
possibly hard resets) won't mount with a stale file handle error.

I've DD'd the 10G disk and tarballed it to 10MB, I'll send it to you
in another email so the attachment doesn't spam the list.

Thanks,
Steve

On Mon, Jun 15, 2015 at 6:27 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Steve Dainard wrote on 2015/06/15 09:19 -0700:
>>
>> Hi Qu,
>>
>> # btrfs --version
>> btrfs-progs v4.0.1
>> # btrfs check /dev/rbd30
>> Checking filesystem on /dev/rbd30
>> UUID: 1bb22a03-bc25-466f-b078-c66c6f6a6d28
>> checking extents
>> cmds-check.c:3735: check_owner_ref: Assertion `rec->is_root` failed.
>> btrfs[0x41aee6]
>> btrfs[0x423f5d]
>> btrfs[0x424c99]
>> btrfs[0x4258f6]
>> btrfs(cmd_check+0x14a3)[0x42893d]
>> btrfs(main+0x15d)[0x409c71]
>> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f29ce437af5]
>> btrfs[0x409829]
>>
>> # btrfs-image /dev/rbd30 rbd30.image -c9
>> # btrfs-image -r rbd30.image rbd30.image.2
>> # mount rbd30.image.2 temp
>> mount: mount /dev/loop0 on /mnt/temp failed: Stale file handle
>
> OK, my assumption are all wrong.
>
> I'd better check the debug-tree output more carefully.
>
> BTW, the rbd30 is the block device which you took the debug-tree output?
>
> If so, would you please do a dd dump of it and send it to me?
> If it contains important/secret info, just forget this.
>
> Maybe I can improve the btrfsck tool to fix it.
>
>>
>> I have a suspicion this was caused by pacemaker starting
>> ceph/filesystem resources on two nodes at the same time,I haven't
>> been able to replicate the issue after hard poweroff if ceph/btrfs are
>> not being controlled by pacemaker.
>
> Did you mean mount the same device on different system?
>
> Thanks,
> Qu
>
>>
>> Thanks for your help.
>>
>>
>>
>> On Mon, Jun 15, 2015 at 1:06 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> The debug result seems valid.
>>> So I'm afraid the problem is not in btrfs.
>>>
>>> Would your please try the following 2 things to eliminate btrfs problems?
>>>
>>> 1) btrfsck from 4.0.1 on the rbd
>>>
>>> If assert still happens, please update the image of the volume(dd image),
>>> to
>>> help us improve btrfs-progs.
>>>
>>> 2) btrfs-image dump and rebuilt the fs into other place.
>>>
>>> # btrfs-image <RBD_DEV> <tmp_file1> -c9
>>> # btrfs-image -r <tmp_file1> <tmp_file2>
>>> # mount <tmp_file2> <mnt>
>>>
>>> This will dump all metadata from <RBD_DEV> to <tmp_file1>,
>>> and then use <tmp_file1> to rebuild a image called <tmp_file2>.
>>>
>>> If <tmp_file2> can be mounted, then the metadata in the RBD device is
>>> completely OK, and we can make conclusion the problem is not caused by
>>> btrfs.(maybe ceph?)
>>>
>>> BTW, all the commands are recommended to be executed on the device which
>>> you
>>> get the debug info from.
>>> As it's a small and almost empty device, so commands execution should be
>>> quite fast on it.
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>> 在 2015年06月13日 00:09, Steve Dainard 写道:
>>>>
>>>>
>>>> Hi Qu,
>>>>
>>>> I have another volume with the same error, btrfs-debug-tree output
>>>> from btrfs-progs 4.0.1 is here: http://pastebin.com/k3R3bngE
>>>>
>>>> I'm not sure how to interpret the output, but the exit status is 0 so
>>>> it looks like btrfs doesn't think there's an issue with the file
>>>> system.
>>>>
>>>> I get the same mount error with options ro,recovery.
>>>>
>>>> On Fri, Jun 12, 2015 at 12:23 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> wrote:
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> -------- Original Message  --------
>>>>> Subject: Can't mount btrfs volume on rbd
>>>>> From: Steve Dainard <sdainard@spd1.com>
>>>>> To: <linux-btrfs@vger.kernel.org>
>>>>> Date: 2015年06月11日 23:26
>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> I'm getting an error when attempting to mount a volume on a host that
>>>>>> was forceably powered off:
>>>>>>
>>>>>> # mount /dev/rbd4 climate-downscale-CMIP5/
>>>>>> mount: mount /dev/rbd4 on /mnt/climate-downscale-CMIP5 failed: Stale
>>>>>> file
>>>>>> handle
>>>>>>
>>>>>> /var/log/messages:
>>>>>> Jun 10 15:31:07 node1 kernel: rbd4: unknown partition table
>>>>>>
>>>>>> # parted /dev/rbd4 print
>>>>>> Model: Unknown (unknown)
>>>>>> Disk /dev/rbd4: 36.5TB
>>>>>> Sector size (logical/physical): 512B/512B
>>>>>> Partition Table: loop
>>>>>> Disk Flags:
>>>>>>
>>>>>> Number  Start  End     Size    File system  Flags
>>>>>>     1      0.00B  36.5TB  36.5TB  btrfs
>>>>>>
>>>>>> # btrfs check --repair /dev/rbd4
>>>>>> enabling repair mode
>>>>>> Checking filesystem on /dev/rbd4
>>>>>> UUID: dfe6b0c8-2866-4318-abc2-e1e75c891a5e
>>>>>> checking extents
>>>>>> cmds-check.c:2274: check_owner_ref: Assertion `rec->is_root` failed.
>>>>>> btrfs[0x4175cc]
>>>>>> btrfs[0x41b873]
>>>>>> btrfs[0x41c3fe]
>>>>>> btrfs[0x41dc1d]
>>>>>> btrfs[0x406922]
>>>>>>
>>>>>>
>>>>>> OS: CentOS 7.1
>>>>>> btrfs-progs: 3.16.2
>>>>>
>>>>>
>>>>>
>>>>> The btrfs-progs seems quite old, and the above btrfsck error seems
>>>>> quite
>>>>> possible related to the old version.
>>>>>
>>>>> Would you please upgrade btrfs-progs to 4.0 and see what will happen?
>>>>> Hopes it can give better info.
>>>>>
>>>>> BTW, it's a good idea to call btrfs-debug-tree /dev/rbd4 to see the
>>>>> output.
>>>>>
>>>>> Thanks
>>>>> Qu.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Ceph: version: 0.94.1/CentOS 7.1
>>>>>>
>>>>>> I haven't found any references to 'stale file handle' on btrfs.
>>>>>>
>>>>>> The underlying block device is ceph rbd, so I've posted to both lists
>>>>>> for any feedback. Also once I reformatted btrfs I didn't get a mount
>>>>>> error.
>>>>>>
>>>>>> The btrfs volume has been reformatted so I won't be able to do much
>>>>>> post mortem but I'm wondering if anyone has some insight.
>>>>>>
>>>>>> Thanks,
>>>>>> Steve
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>
>>>
>
