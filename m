Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34470 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934258AbeFYOEH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 10:04:07 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix regression in btrfs_page_mkwrite() from
 vm_fault_t conversion
Date: Mon, 25 Jun 2018 10:03:54 -0400
Message-ID: <45F09F92-4602-45CF-AFF7-FF0682401C52@fb.com>
In-Reply-To: <20180625135411.GD27958@twin.jikos.cz>
References: <20180625134532.3889459-1-clm@fb.com>
 <20180625135411.GD27958@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 Jun 2018, at 9:54, David Sterba wrote:

> On Mon, Jun 25, 2018 at 06:45:32AM -0700, Chris Mason wrote:

>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 193f933..38403aa 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -9013,6 +9013,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>>  		goto out_unlock;
>>  	}
>>  	ret2 = 0;
>> +	ret = 0;
>
> That's something I'd rather avoid, now there are two error values that
> need to be tracked. Shouldn't the 'ret2 = 0' be removed completely?


Yeah, the whole thing hurts my eyes.  Fixing.

>
>>
>>  	/* page is wholly or partially inside EOF */
>>  	if (page_start + PAGE_SIZE > size)
>> @@ -9037,7 +9038,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>>  	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
>>
>>  out_unlock:
>> -	if (!ret2) {
>> +	if (!ret) {
>
> I'm not sure is safe, the new ret is one of the VM_FAULT_ values and
> it's not 0 by default and in fact I don't see anything that would set it
> to 0 directly or indirectly. Which means that the code in the out: label
> also needs to be revisited:

Good point, ok.

-chris
