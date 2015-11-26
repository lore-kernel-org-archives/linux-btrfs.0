Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59190 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133AbbKZBpT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 20:45:19 -0500
Subject: Re: btrfs check help
To: Vincent Olivier <vincent@up4.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
 <5654C86C.9080800@gmail.com> <20151124203210.GR24333@carfax.org.uk>
 <B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56566416.5000405@cn.fujitsu.com>
Date: Thu, 26 Nov 2015 09:44:54 +0800
MIME-Version: 1.0
In-Reply-To: <B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Vincent Olivier wrote on 2015/11/25 11:51 -0500:
> I should probably point out that there is 64GB of RAM on this machine and it’s a dual Xeon processor (LGA2011-3) system. Also, there is only Btrfs served via Samba and the kernel panic was caused Btrfs (as per what I remember from the log on the screen just before I rebooted) and happened in the middle of the night when zero (0) client was connected.
>
> You will find below the full “btrfs check” log for each device in the order it is listed by “btrfs fi show”.

There is really no need to do such thing, as btrfs is able to manage 
multiple device, calling btrfsck on any of them is enough as long as 
it's not hugely damaged.

>
> Ca I get a strong confirmation that I should run with the “—repair” option on each device? Thanks.

YES.

Inode nbytes fix is *VERY* safe as long as it's the only error.

Although it's not that convincing since the inode nbytes fix code is 
written by myself and authors always tend to believe their codes are 
good....
But at least, some other users with more complicated problem(with inode 
nbytes error) fixed it.

The last decision is still on you anyway.

Thanks,
Qu


>
> Vincent
>
>
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdp
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [O]
> checking free space cache [o]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdi
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [.]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdq
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [o]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdh
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdm
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [O]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdj
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [.]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdo
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [O]
> checking free space cache [.]
> checking fs roots [o]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdg
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [o]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdn
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [O]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdl
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [o]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdc
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [O]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdr
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [O]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdf
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [o]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sde
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [.]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdd
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
> Checking filesystem on /dev/sdb
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
>
> found 19328980191604 bytes used err is 1
> total csum bytes: 18849205856
> total tree bytes: 27393392640
> total fs tree bytes: 4452958208
> total extent tree bytes: 3075571712
> btree space waste bytes: 2881050910
> file data blocks allocated: 19445786390528
> referenced 20138885959680
>
>
>
>> On Nov 24, 2015, at 3:32 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>
>> On Tue, Nov 24, 2015 at 03:28:28PM -0500, Austin S Hemmelgarn wrote:
>>> On 2015-11-24 12:06, Vincent Olivier wrote:
>>>> Hi,
>>>>
>>>> Woke up this morning with a kernel panic (for which I do not have details). Please find below the output for btrfs check. Is this normal ? What should I do ? Arch Linux 4.2.5. Btrfs-utils 4.3.1. 17x4TB RAID10.
>>> You get bonus points for being on a reasonably up-to-date kernel and
>>> userspace :)
>>>
>>> This is actually a pretty tame check result for a filesystem that's
>>> been through kernel panic. I think everything listed here is safe
>>> for check to fix, but I would suggest waiting until the devs provide
>>> opinions before actually running with --repair.  I would also
>>> suggest comparing results between the different devices in the FS,
>>> if things are drastically different, you may have issues that check
>>> can't fix on it's own.
>>>> [root@3dcpc5 ~]# btrfs check /dev/sdk
>>>> Checking filesystem on /dev/sdk
>>>> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
>>>> checking extents
>>>> checking free space cache
>>>> checking fs roots
>>> These next two lines are errors, but I'm not 100% certain if it's
>>> safe to have check fix them:
>>>> root 5 inode 1341670 errors 400, nbytes wrong
>>>> root 11406 inode 1341670 errors 400, nbytes wrong
>>
>>    I think so yes.
>>
>>> This next one is also an error, and I am fairly certain that it's
>>> safe to have check fix as long as the number at the end is not too
>>> big.
>>>> found 19328809638262 bytes used err is 1
>>
>>    Agreed.
>>
>>    Hugo.
>>
>>> The rest is just reference info
>>>> total csum bytes: 18849042724
>>>> total tree bytes: 27389886464
>>>> total fs tree bytes: 4449746944
>>>> total extent tree bytes: 3075457024
>>>> btree space waste bytes: 2880474254
>>> The only other thing I know that's worth mentioning is that if the
>>> numbers on these next two lines don't match, you may be missing some
>>> writes from right before the crash.
>>>> file data blocks allocated: 19430708535296
>>>> referenced 20123773407232
>>
>> --
>> Hugo Mills             | Great films about cricket: Umpire of the Rising Sun
>> hugo@... carfax.org.uk |
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


