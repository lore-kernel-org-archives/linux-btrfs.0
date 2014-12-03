Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5855 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750707AbaLCHlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 02:41:22 -0500
Message-ID: <547EBE9F.3070805@cn.fujitsu.com>
Date: Wed, 3 Dec 2014 15:41:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Ed Tomlinson <edt@aei.ca>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] More generic inode nlink repair function
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com> <2026580.dXZxrES2AW@grover> <547EB7F1.9090408@jp.fujitsu.com>
In-Reply-To: <547EB7F1.9090408@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 0/6] More generic inode nlink repair function
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
To: Ed Tomlinson <edt@aei.ca>, <linux-btrfs@vger.kernel.org>
Date: 2014年12月03日 15:12
> Hi,
>
> (2014/12/03 14:03), Ed Tomlinson wrote:
>> Hi,
>>
>> I'd really like to see these patches included in btrfsck - they 
>> repaired my fs.   Once
>> Qu got them working they found additional corruptions.  This time 
>> there was no crash or stall
>> just an umount that left (chromium) files unlinked...  The bug with 
>> these files has been
>> hitting me for a while - just did not recognize what was causing it 
>> or notice the corruption.
>>
>> The only objection I have seen to these patches is that they may 
>> create a "lost+found"
>> directory.  I submit this is an expected behavior for a fsck 
>> utility.  When --repair is specified
>> I expect a fsck to make changes to my fs one of which may be adding 
>> and populating a
>> lost+found directory.
>
> How about making lost+found on mkfs.btrfs like ext4?
>
> Thanks,
> Satoru
>
I hope most user won't see the lost+found dir.

Due to the COW feature especially on all the metadata,
btrfs is *supposed* to be fsck free and self repairing fs, make 
lost+found at mkfs time
may make btrfs not so special among the old time ext* fs.

IMHO, most user will not see the lost+found dir, if hardware and kernel 
works as they should be,
usual bit flip can be recovered by the default DUP or higher RAID 
metadata profile.
The lost+found dir will only occur if the fs is really badly damaged or 
kernel bug.
(or intently damaged by btrfs-corrupt-block for QA reason).

With the maturing of btrfs, such case should be more and more rare and 
most user will forget
the fact that btrfsck will create lost+found dir, but it will still be 
the last hope.
So lost+found should only occur when it is needed, and when it is needed 
it will be created.

Thanks,
Qu
>>
>> Thanks
>> Ed Tomlinson
>>
>> PS. It would be very interesting to find out WHY these files are 
>> ending up unlinked.  Ideas?
>>
>>
>> On Wednesday 03 December 2014 12:18:26 you wrote:
>>> Update on patch 4 and 6, other is not changed.
>>> This nlink repair function is more generic than the original one.
>>>
>>> The old one can only handle a specific case that the inode_ref is
>>> invalid, either point to a non-exist parent inode or point to a invalid
>>> inode(not dir or conflicting index/name).
>>>
>>> The new one will reset all the backref, no matter it is valid or not,
>>> and re-add all the valid backref, this make the nlink handles more
>>> corrupt cases.
>>>
>>> Qu Wenruo (6):
>>>    btrfs-progs: print root dir verbose error in fsck
>>>    btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.
>>>    btrfs-progs: Import lookup/del_inode_ref() function.
>>>    btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.
>>>    btrfs-progs: Add btrfs_mkdir() function for the incoming 
>>> 'lost+found'
>>>         fsck mechanism.
>>>    btrfs-progs: Add fixing function for inodes whose nlink dismatch
>>>
>>>   Makefile     |   2 +-
>>>   cmds-check.c | 311 ++++++++++++++++++++++++++++++++++++--
>>>   ctree.c      |   6 +
>>>   ctree.h      |  38 +++++
>>>   inode-item.c | 318 +++++++++++++++++++++++++++++++++++++++
>>>   inode.c      | 484 
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   6 files changed, 1148 insertions(+), 11 deletions(-)
>>>   create mode 100644 inode.c
>>>
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

