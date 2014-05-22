Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34211 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbaEVMQH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 08:16:07 -0400
Message-ID: <537DEB3F.5020303@fb.com>
Date: Thu, 22 May 2014 08:19:11 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
References: <537D40EB.60906@fb.com> <537D5136.4050007@suse.com>
In-Reply-To: <537D5136.4050007@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/21/2014 09:21 PM, Jeff Mahoney wrote:
> On 05/21/2014 08:12 PM, Chris Mason wrote:
>>
>> The Btrfs sysfs code removes entries for raid types that are no
>> longer in use.  This means that if you have a raid0 FS and use balance
>> to turn it into a raid1 FS, the raid0 sysfs entries will go away.
>>
>> The rough chain of events is:
>>
>> __link_block_group() -> see we're the first RAIDX, add sysfs entry
>>
>> btrfs_remove_block_group() -> notice we're removing the last RAIDX
>> remove sysfs entry
>>
>> This all makes sense until we try to add RAIDX back into the FS again.
>> The problem is that our RAID kobjects are just in an array that gets
>> freed at unmount time, instead of an array of pointers to kobjects that
>> get freed when the great sysfs in the sky is done with them.
>>
>> When we remove the sysfs entry for a given raid level, the syfs code
>> free's the name.  When we use the same kobject to add back the RAIDX
>> entry again, sysfs sees the old name pointer and tries to free it again.
>>
>> All of which is a long way of saying we're using sysfs wrong.  For now,
>> just don't remove entries for raid levels that we're no longer using.
> 
> Hi Chris -
> 
> Thanks for posting the problem. I disagree that sysfs is being used
> wrong here - or well, not on purpose. The problem is only that I didn't
> anticipate raid levels going away and only initialize the kobjects i
> update_space_info.

Thanks Jeff, this is more a comment on the sadness that comes from using
sysfs, not a knock on your patch ;)

> 
> The name being double-freed is only part of the problem. The kobject
> isn't reinitialized at all. Clearing ->name and re-calling kobject_init
> would fix it - but I think we can do one better.
> 
> kobject_cleanup's comment for freeing ->name claims that ->name being
> set means that it was allocated by the kobject infrastructure. The raid
> names come directly out of an array anyway, so we don't even need to
> copy it. We can avoid the string allocation entirely and handle the
> reuse properly.
> 
> The following (untested, tonight anyway) patch should fix it.

Can we safely reinit a kobject that has been put in use in sysfs?  Given
all the things that can hold refs etc is this legal?

-chris
