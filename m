Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56303 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030283AbaGRNgS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 09:36:18 -0400
Message-ID: <53C922C6.1020406@fb.com>
Date: Fri, 18 Jul 2014 09:36:06 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS hang with 3.16-rc5
References: <1502954.OtX3SzjMKZ@merkaba> <29286605.flGgbBIpOj@merkaba> <53C52AE4.6010803@fb.com> <25104768.pskoHShbKc@merkaba>
In-Reply-To: <25104768.pskoHShbKc@merkaba>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2014 03:51 AM, Martin Steigerwald wrote:
> Am Dienstag, 15. Juli 2014, 09:21:40 schrieb Chris Mason:
>> On 07/14/2014 05:58 PM, Martin Steigerwald wrote:
>>> Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
>>>> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
>>>>> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
>>>>>> Hi!
>>>>>>
>>>>>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days
>>>>>> of
>>>>>> usage, with 3-16-rc5 I had a hang again. Less than a hour since booting
>>>>>> it.
>>>>>>
>>>>>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
>>>>>> didn´t happen that quickly after boot and since backtrace looks a bit
>>>>>> different from what I have in memory, I post this in a new thread.
>>>>>> See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
>>>>>> issues.
>>>>>
>>>>> Probably good to add some basic information on the filesystem:
>>>> Do you have compression enabled?  I wasn't able to nail down the 3.15.1
>>>> hang before vacation attacked me, but I'm hoping to track it down today.
>>>
>>> Yes. I have.
>>>
>>> It just hung again while I was playing PlaneShift.
>>>
>>> Back to 3.16-rc4 as rc5 seems to be broke here.
>>
>> The btrfs hang you're hitting goes back to 3.15.  So 3.16-rc4 vs rc5
>> shouldn't be a factor.  Are you hitting other problems with 3.16?
> 
> On this system it is a matter.
> 
> 3.16-rc5: Two hangs in one day
> 
> 3.16-rc4: No hang so far with three days uptime (well with hibernation cycles 
> in between)
> 
> So easy observation for me: 3.16-rc4 fine, 3.16-rc5 broke.

Can you please try this patch on rc5 and look for the printk:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..8ab56df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8157,6 +8157,13 @@ void btrfs_destroy_inode(struct inode *inode)
 		spin_unlock(&root->fs_info->ordered_root_lock);
 	}
 
+	spin_lock(&root->fs_info->ordered_root_lock);
+	if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
+		list_del_init(&BTRFS_I(inode)->ordered_operations);
+printk(KERN_CRIT "racing inode deletion with ordered operations!!!!!!!!!!!\n");
+	}
+	spin_unlock(&root->fs_info->ordered_root_lock);
+
 	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 		     &BTRFS_I(inode)->runtime_flags)) {
 		btrfs_info(root->fs_info, "inode %llu still on the orphan list",
