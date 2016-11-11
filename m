Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36154 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750751AbcKKDzb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 22:55:31 -0500
Subject: Re: btrfs support for filesystems >8TB on 32bit architectures
To: Marc MERLIN <marc@merlins.org>
References: <10ed4e8a-c9a6-961a-fb51-16186da079e4@cn.fujitsu.com>
 <20161107145502.7lahpm6smqsv6s2q@merlins.org>
 <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com>
 <20161108003950.GD13371@merlins.org>
 <63a1964d-f8df-413d-c088-20163f824e3d@cn.fujitsu.com>
 <20161108010600.GE13371@merlins.org>
 <977bbf2a-5d9f-f5aa-084c-4ca1d891eb72@cn.fujitsu.com>
 <20161108152429.GC24297@merlins.org>
 <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
 <20161109020519.GN13371@merlins.org>
 <20161111034805.svs33jawobogpzrc@merlins.org>
CC: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f9757f37-ab2b-87d8-3f72-80dcc968f6e8@cn.fujitsu.com>
Date: Fri, 11 Nov 2016 11:55:21 +0800
MIME-Version: 1.0
In-Reply-To: <20161111034805.svs33jawobogpzrc@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/11/2016 11:48 AM, Marc MERLIN wrote:
> On Tue, Nov 08, 2016 at 06:05:19PM -0800, Marc MERLIN wrote:
>> On Wed, Nov 09, 2016 at 09:50:08AM +0800, Qu Wenruo wrote:
>>> Yeah, quite possible!
>>>
>>> The truth is, current btrfs check only checks:
>>> 1) Metadata
>>>    while --check-data-csum option will check data, but still
>>>    follow the restriction 3).
>>> 2) Crossing reference of metadata (contents of metadata)
>>> 3) The first good mirror/backup
>>>
>>> So quite a lot of problems can't be detected by btrfs check:
>>> 1) Data corruption (csum mismatch)
>>> 2) 2nd mirror corruption(DUP/RAID0/10) or parity error(RAID5/6)
>>>
>>> For btrfsck to check all mirror and data, you could try out-of-tree
>>> offline scrub patchset:
>>> https://github.com/adam900710/btrfs-progs/tree/fsck_scrub
>>>
>>> Which implements the kernel scrub equivalent in btrfs-progs.
>>
>> I see, thanks for the answer.
>> Note that this is very confusing to the end user.
>> If check --repair returns success, the filesystem should be clean.
>> Hopefully that patchset can be included in btrfs-progs
>>
>> But sure enough, I'm seeing a lot of these:
>> BTRFS warning (device dm-6): checksum error at logical 269783986176 on dev /dev/mapper/crypt_bcache2, sector 529035384, root 16755, inode 1225897, offset 77824, length 4096, links 5 (path: magic/20150624/home/merlin/public_html/rig3/img/thumb800_302_1-Wire.jpg)
>
> So, I ran check -repair, then I ran scrub and I deleted all the files
> that were referenced by pathname and failed scrub.
> Now I have this:
> BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785128960 on dev /dev/mapper/crypt_bcache2
> BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1545, gen 0
> BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785133056 on dev /dev/mapper/crypt_bcache2
> BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1546, gen 0
> BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785137152 on dev /dev/mapper/crypt_bcache2
> BTRFS warning (device dm-6): checksum error at logical 269784580096 on dev /dev/mapper/crypt_bcache2, sector 529036544, root 17564, inode 1225903, offset 16384: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784584192 on dev /dev/mapper/crypt_bcache2, sector 529036552, root 17564, inode 1225903, offset 20480: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784588288 on dev /dev/mapper/crypt_bcache2, sector 529036560, root 17564, inode 1225903, offset 24576: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784592384 on dev /dev/mapper/crypt_bcache2, sector 529036568, root 17564, inode 1225903, offset 28672: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784596480 on dev /dev/mapper/crypt_bcache2, sector 529036576, root 17564, inode 1225903, offset 32768: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784600576 on dev /dev/mapper/crypt_bcache2, sector 529036584, root 17564, inode 1225903, offset 36864: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784604672 on dev /dev/mapper/crypt_bcache2, sector 529036592, root 17564, inode 1225903, offset 40960: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784608768 on dev /dev/mapper/crypt_bcache2, sector 529036600, root 17564, inode 1225903, offset 45056: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269784612864 on dev /dev/mapper/crypt_bcache2, sector 529036608, root 17564, inode 1225903, offset 49152: path resolving failed with ret=-2
>
> How am I supposed to deal with those?

It seems to be orphan inodes.
Btrfs doesn't remove all the contents of an inode at rm time.
It just unlink the inode and put it into a state called orphan 
inodes.(Can't be referred from any directory).

And then free their data extents in next several trans.


Try to find these inodes using inode number in specified subvolume.
If not found, then they are orphan inodes, nothing to worry.
These wrong data extent will disappear soon or later.

Or you can use "btrfs fi sync" to make sure orphan inodes are really 
removed from tree.

Thanks,
Qu
>
> Thanks,
> Marc
>


