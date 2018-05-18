Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56809 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbeERFLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:11:13 -0400
Subject: Re: [PATCH v2] Btrfs: add parent_transid parameter to
 veirfy_level_key
To: Nikolay Borisov <nborisov@suse.com>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
References: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
 <1526612375-95875-1-git-send-email-bo.liu@linux.alibaba.com>
 <05c18348-3dd1-802e-21a4-3e1b464cdb1d@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <528aef5d-ba56-1b3d-71a1-3db87344591b@gmx.com>
Date: Fri, 18 May 2018 13:10:59 +0800
MIME-Version: 1.0
In-Reply-To: <05c18348-3dd1-802e-21a4-3e1b464cdb1d@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月18日 13:02, Nikolay Borisov wrote:
> 
> 
> On 18.05.2018 05:59, Liu Bo wrote:
>> As verify_level_key() is checked after verify_parent_transid(), i.e.
>>
>> if (verify_parent_transid())
>>    ret = -EIO;
>> else if (verify_level_key())
>>    ret = -EUCLEAN;
>>
>> if parent_transid is 0, verify_parent_transid() skips verifying
>> parent_transid and considers eb as valid, and if verify_level_key()
>> reports something wrong, we're not going to know if it's caused by
>> corrupted metadata or non-checkecd eb (e.g. stale eb).
> 
> It's really unclear (from the changelog) how the stale eb ties with
> parent_transid. You should have explained the relationship between
> checking parenttransid and stale/non-stale ebs

It's in fact related to the fixing patch:
Btrfs: fix the corruption by reading stale btree blocks

But whatever, extra mention won't hurt.

> 
>>
>> @parent_transid is able to tell whether the eb's generation has been
>> verified by the caller.
> 
> It's really unclear why parent_transid is able to tell whether the
> generation is verified by the caller.

At least this looks pretty straightforward to me.
@parent_transid = 0 means no generation check, and @parent_transid != 0
means already checked.

So at least for this part I didn't get any confusion.

Thanks,
Qu

> 
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>> ---
>> v2: - more explicit commit log.
>>     - adjust the position shown in error msg.
>>
>>  fs/btrfs/disk-io.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 60caa68c3618..ad865176a3ca 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -416,7 +416,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>>  
>>  static int verify_level_key(struct btrfs_fs_info *fs_info,
>>  			    struct extent_buffer *eb, int level,
>> -			    struct btrfs_key *first_key)
>> +			    struct btrfs_key *first_key, u64 parent_transid)
>>  {
>>  	int found_level;
>>  	struct btrfs_key found_key;
>> @@ -454,10 +454,11 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
>>  	if (ret) {
>>  		WARN_ON(1);
>>  		btrfs_err(fs_info,
>> -"tree first key mismatch detected, bytenr=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
>> -			  eb->start, first_key->objectid, first_key->type,
>> -			  first_key->offset, found_key.objectid,
>> -			  found_key.type, found_key.offset);
>> +"tree first key mismatch detected, bytenr=%llu parent_transid=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
>> +			  eb->start, parent_transid, first_key->objectid,
>> +			  first_key->type, first_key->offset,
>> +			  found_key.objectid, found_key.type,
>> +			  found_key.offset);
>>  	}
>>  #endif
>>  	return ret;
>> @@ -493,7 +494,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>>  						   parent_transid, 0))
>>  				ret = -EIO;
>>  			else if (verify_level_key(fs_info, eb, level,
>> -						  first_key))
>> +						  first_key, parent_transid))
>>  				ret = -EUCLEAN;
>>  			else
>>  				break;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
