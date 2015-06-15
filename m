Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5196 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753983AbbFOIGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 04:06:33 -0400
Subject: Re: Can't mount btrfs volume on rbd
To: Steve Dainard <sdainard@spd1.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
 <557A890D.8080306@cn.fujitsu.com>
 <CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <557E877E.2060704@cn.fujitsu.com>
Date: Mon, 15 Jun 2015 16:06:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The debug result seems valid.
So I'm afraid the problem is not in btrfs.

Would your please try the following 2 things to eliminate btrfs problems?

1) btrfsck from 4.0.1 on the rbd

If assert still happens, please update the image of the volume(dd 
image), to help us improve btrfs-progs.

2) btrfs-image dump and rebuilt the fs into other place.

# btrfs-image <RBD_DEV> <tmp_file1> -c9
# btrfs-image -r <tmp_file1> <tmp_file2>
# mount <tmp_file2> <mnt>

This will dump all metadata from <RBD_DEV> to <tmp_file1>,
and then use <tmp_file1> to rebuild a image called <tmp_file2>.

If <tmp_file2> can be mounted, then the metadata in the RBD device is 
completely OK, and we can make conclusion the problem is not caused by 
btrfs.(maybe ceph?)

BTW, all the commands are recommended to be executed on the device which 
you get the debug info from.
As it's a small and almost empty device, so commands execution should be 
quite fast on it.

Thanks,
Qu

在 2015年06月13日 00:09, Steve Dainard 写道:
> Hi Qu,
>
> I have another volume with the same error, btrfs-debug-tree output
> from btrfs-progs 4.0.1 is here: http://pastebin.com/k3R3bngE
>
> I'm not sure how to interpret the output, but the exit status is 0 so
> it looks like btrfs doesn't think there's an issue with the file
> system.
>
> I get the same mount error with options ro,recovery.
>
> On Fri, Jun 12, 2015 at 12:23 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> -------- Original Message  --------
>> Subject: Can't mount btrfs volume on rbd
>> From: Steve Dainard <sdainard@spd1.com>
>> To: <linux-btrfs@vger.kernel.org>
>> Date: 2015年06月11日 23:26
>>
>>> Hello,
>>>
>>> I'm getting an error when attempting to mount a volume on a host that
>>> was forceably powered off:
>>>
>>> # mount /dev/rbd4 climate-downscale-CMIP5/
>>> mount: mount /dev/rbd4 on /mnt/climate-downscale-CMIP5 failed: Stale file
>>> handle
>>>
>>> /var/log/messages:
>>> Jun 10 15:31:07 node1 kernel: rbd4: unknown partition table
>>>
>>> # parted /dev/rbd4 print
>>> Model: Unknown (unknown)
>>> Disk /dev/rbd4: 36.5TB
>>> Sector size (logical/physical): 512B/512B
>>> Partition Table: loop
>>> Disk Flags:
>>>
>>> Number  Start  End     Size    File system  Flags
>>>    1      0.00B  36.5TB  36.5TB  btrfs
>>>
>>> # btrfs check --repair /dev/rbd4
>>> enabling repair mode
>>> Checking filesystem on /dev/rbd4
>>> UUID: dfe6b0c8-2866-4318-abc2-e1e75c891a5e
>>> checking extents
>>> cmds-check.c:2274: check_owner_ref: Assertion `rec->is_root` failed.
>>> btrfs[0x4175cc]
>>> btrfs[0x41b873]
>>> btrfs[0x41c3fe]
>>> btrfs[0x41dc1d]
>>> btrfs[0x406922]
>>>
>>>
>>> OS: CentOS 7.1
>>> btrfs-progs: 3.16.2
>>
>> The btrfs-progs seems quite old, and the above btrfsck error seems quite
>> possible related to the old version.
>>
>> Would you please upgrade btrfs-progs to 4.0 and see what will happen?
>> Hopes it can give better info.
>>
>> BTW, it's a good idea to call btrfs-debug-tree /dev/rbd4 to see the output.
>>
>> Thanks
>> Qu.
>>>
>>> Ceph: version: 0.94.1/CentOS 7.1
>>>
>>> I haven't found any references to 'stale file handle' on btrfs.
>>>
>>> The underlying block device is ceph rbd, so I've posted to both lists
>>> for any feedback. Also once I reformatted btrfs I didn't get a mount
>>> error.
>>>
>>> The btrfs volume has been reformatted so I won't be able to do much
>>> post mortem but I'm wondering if anyone has some insight.
>>>
>>> Thanks,
>>> Steve
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
