Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14516 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751976AbbETSIm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 14:08:42 -0400
Message-ID: <555CCDA1.2040302@fb.com>
Date: Wed, 20 May 2015 14:08:33 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: fix regression in raid level conversion
References: <20150520141301.GA16249@ret.masoncoding.com> <20150520170227.GM23255@twin.jikos.cz>
In-Reply-To: <20150520170227.GM23255@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/20/2015 01:02 PM, David Sterba wrote:
> On Wed, May 20, 2015 at 10:13:11AM -0400, Chris Mason wrote:
>> Commit 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e changed
>> btrfs_set_block_group_ro to avoid trying to allocate new chunks with the
>> new raid profile during conversion.  This fixed failures when there was
>> no space on the drive to allocate a new chunk, but the metadata
>> reserves were sufficient to continue the conversion.
>>
>> But this ended up causing a regression when the drive had plenty of
>> space to allocate new chunks, mostly because reduce_alloc_profile isn't
>> using the new raid profile.
>>
>> Fixing btrfs_reduce_alloc_profile is a bigger patch.  For now, do a
>> partial revert of 2f0810880, and don't error out if we hit ENOSPC.
>>
>> Signed-off-by: Chris Mason <clm@fb.com>
>> ---
>>  fs/btrfs/extent-tree.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 45e3f08..a115599 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8829,6 +8829,26 @@ again:
>>  		goto again;
>>  	}
>>  
>> +	/*
>> +	 * if we are changing raid levels, try to allocate a corresponding
>> +	 * block group with the new raid level.
>> +	 */
>> +	if (!(cache->flags & BTRFS_BLOCK_GROUP_SYSTEM)) {
> 
> This prevents to switch the system chunk in all cases. What was the
> reason to do it?

I thought the system chunk was being caught by check_system_chunk below,
but no, its using the wrong profile.  It did work when I tested, but I
ran it a few times in a row and got inconsistent results.

> 
> If I remove the check, then the conversions work in all combinations.
> Eg.

Thanks, I'm pushing out an updated patch without the check.

-chris

