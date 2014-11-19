Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22083 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbaKSO5w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 09:57:52 -0500
Message-ID: <546CAFE3.6040207@fb.com>
Date: Wed, 19 Nov 2014 09:57:39 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-btrfs@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not move em to modified list when unpinning
References: <1415999790-4144-1-git-send-email-jbacik@fb.com> <20141119034556.GG29950@dastard>
In-Reply-To: <20141119034556.GG29950@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2014 10:45 PM, Dave Chinner wrote:
> On Fri, Nov 14, 2014 at 04:16:30PM -0500, Josef Bacik wrote:
>> We use the modified list to keep track of which extents have been modified so we
>> know which ones are candidates for logging at fsync() time.  Newly modified
>> extents are added to the list at modification time, around the same time the
>> ordered extent is created.  We do this so that we don't have to wait for ordered
>> extents to complete before we know what we need to log.  The problem is when
>> something like this happens
>>
>> log extent 0-4k on inode 1
>> copy csum for 0-4k from ordered extent into log
>> sync log
>> commit transaction
>> log some other extent on inode 1
>> ordered extent for 0-4k completes and adds itself onto modified list again
>> log changed extents
>> see ordered extent for 0-4k has already been logged
>> 	at this point we assume the csum has been copied
>> sync log
>> crash
>>
>> On replay we will see the extent 0-4k in the log, drop the original 0-4k extent
>> which is the same one that we are replaying which also drops the csum, and then
>> we won't find the csum in the log for that bytenr.  This of course causes us to
>> have errors about not having csums for certain ranges of our inode.  So remove
>> the modified list manipulation in unpin_extent_cache, any modified extents
>> should have been added well before now, and we don't want them re-logged.  This
>> fixes my test that I could reliably reproduce this problem with.  Thanks,
>
> Is it possiible to turn this unspecified test in into another
> generic fsync xfstest?
>

It depends on a new dm target I'm working on to better test power fail 
scenarios, once I have that merged I have a few xfstests I'll be 
submitting in this area.  Would you actually mind taking a quick look at 
it to make sure it seems sane?

https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/log/?h=dm-powerfail

The 'split' option is what is meant for ext* and xfs (I haven't tested 
that part yet), which will just return the old data in the case of 
unflushed data/metadata.  Anything you'd like to see added or changed? 
Thanks,

Josef
