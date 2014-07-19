Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61170 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200AbaGSSkG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 14:40:06 -0400
Message-ID: <53CABB77.5090008@fb.com>
Date: Sat, 19 Jul 2014 14:39:51 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS hang with 3.16-rc5
References: <1502954.OtX3SzjMKZ@merkaba> <25104768.pskoHShbKc@merkaba> <53C922C6.1020406@fb.com> <3378728.FvZP3jOPGh@merkaba>
In-Reply-To: <3378728.FvZP3jOPGh@merkaba>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/19/2014 01:59 PM, Martin Steigerwald wrote:
> Am Freitag, 18. Juli 2014, 09:36:06 schrieb Chris Mason:
>> On 07/18/2014 03:51 AM, Martin Steigerwald wrote:
>>> Am Dienstag, 15. Juli 2014, 09:21:40 schrieb Chris Mason:
>>>> On 07/14/2014 05:58 PM, Martin Steigerwald wrote:
>>>>> Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
>>>>>> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
>>>>>>> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
>>>>>>>> Hi!
>>>>>>>>
>>>>>>>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several
>>>>>>>> days
>>>>>>>> of
>>>>>>>> usage, with 3-16-rc5 I had a hang again. Less than a hour since
>>>>>>>> booting
>>>>>>>> it.
>>>>>>>>
>>>>>>>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2
>>>>>>>> usually
>>>>>>>> didn´t happen that quickly after boot and since backtrace looks a bit
>>>>>>>> different from what I have in memory, I post this in a new thread.
>>>>>>>> See thread "Blocked tasks on 3.15.1" for a discussion of previous
>>>>>>>> hang
>>>>>>>> issues.
>>>>>>>
>>>>>>> Probably good to add some basic information on the filesystem:
>>>>>> Do you have compression enabled?  I wasn't able to nail down the 3.15.1
>>>>>> hang before vacation attacked me, but I'm hoping to track it down
>>>>>> today.
>>>>>
>>>>> Yes. I have.
>>>>>
>>>>> It just hung again while I was playing PlaneShift.
>>>>>
>>>>> Back to 3.16-rc4 as rc5 seems to be broke here.
>>>>
>>>> The btrfs hang you're hitting goes back to 3.15.  So 3.16-rc4 vs rc5
>>>> shouldn't be a factor.  Are you hitting other problems with 3.16?
>>>
>>> On this system it is a matter.
>>>
>>> 3.16-rc5: Two hangs in one day
>>>
>>> 3.16-rc4: No hang so far with three days uptime (well with hibernation
>>> cycles in between)
>>>
>>> So easy observation for me: 3.16-rc4 fine, 3.16-rc5 broke.
>>
>> Can you please try this patch on rc5 and look for the printk:
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 3668048..8ab56df 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -8157,6 +8157,13 @@ void btrfs_destroy_inode(struct inode *inode)
>>  		spin_unlock(&root->fs_info->ordered_root_lock);
>>  	}
>>
>> +	spin_lock(&root->fs_info->ordered_root_lock);
>> +	if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
>> +		list_del_init(&BTRFS_I(inode)->ordered_operations);
>> +printk(KERN_CRIT "racing inode deletion with ordered
>> operations!!!!!!!!!!!\n"); +	}
>> +	spin_unlock(&root->fs_info->ordered_root_lock);
>> +
>>  	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
>>  		     &BTRFS_I(inode)->runtime_flags)) {
>>  		btrfs_info(root->fs_info, "inode %llu still on the orphan list",
> 
> Did so and again got a hang.
> 
> No racing inodes tough:
> 
> merkaba:/boot> zgrep -i "racing inode" /var/log/syslog*
> merkaba:/boot#1>
> 
> Built kernel seems right:
> 
> martin@merkaba:[…]> LANG=C grep -ir "racing inode" fs/btrfs
> fs/btrfs/inode.c:printk(KERN_CRIT "racing inode deletion with ordered operations!!!!!!!!!!!\n");
> Binary file fs/btrfs/inode.o matches
> Binary file fs/btrfs/btrfs.o matches
> Binary file fs/btrfs/btrfs.ko matches
> 
> Backtrace doesn´t seem to contain any function related to inodes.
> 
> 
> Back to rc4 again for now.
> 
> 
> These hangs seemed to occur first at writing several hundred MiB onto a
> high speed SDHC card… yet, they persisted long after the write was finished,
> upto to a point where I had to reboot cause machine hung on trying to
> switch between tty7 (X11) and tty1 (for diagnosis).

Ok, this is definitely the same hang reported on 3.15.1.  Thanks for
giving the patch a try, I've got another long running test going this
weekend in hopes of triggering it here.

-chris
