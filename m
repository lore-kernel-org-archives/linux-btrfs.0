Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53045 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239AbaKRQDu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 11:03:50 -0500
Message-ID: <546B6DDF.1050909@fb.com>
Date: Tue, 18 Nov 2014 11:03:43 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not move em to modified list when unpinning
References: <1415999790-4144-1-git-send-email-jbacik@fb.com> <20141118071308.GB12504@localhost.localdomain>
In-Reply-To: <20141118071308.GB12504@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2014 02:13 AM, Liu Bo wrote:
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
> This will make em->generation remain -1 in the above case, no?
>
> Csum is copied after ordered extent is set with "IO_DONE", but before
> unpin_extent_cache(), "sync log" happens, so if we dont have it 're-logged',
> em->generation will not get updated so that the btrfs_file_extent_item's generation will not be
> updated.
>

Huh this is a good point, but it brings up another horrible thing I just 
realized, in this case that we die directly after that transaction 
commit we'll lose the extent anyway because we'll drop the tree log and 
the extent won't actually be in its actual tree.  Woo I love this stuf.

Josef
