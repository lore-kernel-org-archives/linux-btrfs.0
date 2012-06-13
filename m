Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:64945 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab2FMKrU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 06:47:20 -0400
Message-ID: <4FD86FB9.3070503@giantdisaster.de>
Date: Wed, 13 Jun 2012 12:47:21 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 1/2] Btrfs: use rcu to protect device->name V2
References: <1339530642-13862-1-git-send-email-josef@redhat.com> <20120612223526.GJ32402@twin.jikos.cz>
In-Reply-To: <20120612223526.GJ32402@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 13 Jun 2012 00:35:26 +0200, David Sterba wrote:
> On Tue, Jun 12, 2012 at 03:50:41PM -0400, Josef Bacik wrote:
>> +++ b/fs/btrfs/check-integrity.c
>> @@ -93,6 +93,7 @@
>>  #include "print-tree.h"
>>  #include "locking.h"
>>  #include "check-integrity.h"
>> +#include "rcu-string.h"
>>  
>>  #define BTRFSIC_BLOCK_HASHTABLE_SIZE 0x10000
>>  #define BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE 0x10000
>> @@ -843,13 +844,14 @@ static int btrfsic_process_superblock_dev_mirror(
>>  		superblock_tmp->never_written = 0;
>>  		superblock_tmp->mirror_num = 1 + superblock_mirror_num;
>>  		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
>> -			printk(KERN_INFO "New initial S-block (bdev %p, %s)"
>> -			       " @%llu (%s/%llu/%d)\n",
>> -			       superblock_bdev, device->name,
>> -			       (unsigned long long)dev_bytenr,
>> -			       dev_state->name,
>> -			       (unsigned long long)dev_bytenr,
>> -			       superblock_mirror_num);
>> +			printk_in_rcu(KERN_INFO "New initial S-block (bdev %p,"
> 
> can you please add the 'btrfs: ' prefixes?

Please no additional "btrfs" prefix in the check-integrity printk lines
that are enabled with the print_mask option. If they are enabled, then
for btrfs debugging, and then the context is known. And you get
thousands of these lines...


> 
>> +				     " %s) @%llu (%s/%llu/%d)\n",
>> +				     superblock_bdev,
>> +				     rcu_str_deref(device->name),
>> +				     (unsigned long long)dev_bytenr,
>> +				     dev_state->name,
>> +				     (unsigned long long)dev_bytenr,
>> +				     superblock_mirror_num);
>>  		list_add(&superblock_tmp->all_blocks_node,
>>  			 &state->all_blocks_list);
>>  		btrfsic_block_hashtable_add(superblock_tmp,
