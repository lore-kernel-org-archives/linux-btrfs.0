Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751912AbdJXMXw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 08:23:52 -0400
Subject: Re: [PATCH 1/6] btrfs: qgroup: Skeleton to support separate qgroup
 reservation type
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-2-wqu@suse.com>
 <5e6a7a3c-21ce-12e4-1bdc-78cdcb69d6c7@suse.com>
 <44cac459-0d68-01e3-e7bd-9e4cf541aabd@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a8a86762-a432-5e17-aa3d-c695586da435@suse.com>
Date: Tue, 24 Oct 2017 15:23:49 +0300
MIME-Version: 1.0
In-Reply-To: <44cac459-0d68-01e3-e7bd-9e4cf541aabd@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.10.2017 14:51, Qu Wenruo wrote:
> 
> 
> On 2017年10月24日 19:00, Nikolay Borisov wrote:
>>
>>
>> On 24.10.2017 11:39, Qu Wenruo wrote:
>>> Instead of single qgroup->reserved, use a new structure btrfs_qgroup_rsv
>>> to restore different types of reservation.
>>>
>>> This patch only updates the header and needed modification to pass
>>> compile.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/qgroup.c | 16 ++++++++++------
>>>  fs/btrfs/qgroup.h | 27 +++++++++++++++++++++++++--
>>>  2 files changed, 35 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index e172d4843eae..fe3adb996883 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -2444,7 +2444,8 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>>>  }
>>>  
>>>  void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>>> -			       u64 ref_root, u64 num_bytes)
>>> +			       u64 ref_root, u64 num_bytes,
>>> +			       enum btrfs_qgroup_rsv_type type)
>>>  {
>>>  	struct btrfs_root *quota_root;
>>>  	struct btrfs_qgroup *qgroup;
>>> @@ -2936,7 +2937,8 @@ static int qgroup_free_reserved_data(struct inode *inode,
>>>  			goto out;
>>>  		freed += changeset.bytes_changed;
>>>  	}
>>> -	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed);
>>> +	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed,
>>> +				  BTRFS_QGROUP_RSV_DATA);
>>>  	ret = freed;
>>>  out:
>>>  	extent_changeset_release(&changeset);
>>> @@ -2968,7 +2970,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
>>>  	if (free)
>>>  		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
>>>  				BTRFS_I(inode)->root->objectid,
>>> -				changeset.bytes_changed);
>>> +				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
>>>  	ret = changeset.bytes_changed;
>>>  out:
>>>  	extent_changeset_release(&changeset);
>>> @@ -3045,7 +3047,8 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
>>>  	if (reserved == 0)
>>>  		return;
>>>  	trace_qgroup_meta_reserve(root, -(s64)reserved);
>>> -	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
>>> +	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved,
>>> +				  BTRFS_QGROUP_RSV_META);
>>>  }
>>>  
>>>  void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
>>> @@ -3060,7 +3063,8 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
>>>  	WARN_ON(atomic64_read(&root->qgroup_meta_rsv) < num_bytes);
>>>  	atomic64_sub(num_bytes, &root->qgroup_meta_rsv);
>>>  	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
>>> -	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
>>> +	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes,
>>> +				  BTRFS_QGROUP_RSV_META);
>>>  }
>>>  
>>>  /*
>>> @@ -3088,7 +3092,7 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
>>>  		}
>>>  		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
>>>  				BTRFS_I(inode)->root->objectid,
>>> -				changeset.bytes_changed);
>>> +				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
>>>  
>>>  	}
>>>  	extent_changeset_release(&changeset);
>>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>>> index d9984e87cddf..0b04cbc5b5ce 100644
>>> --- a/fs/btrfs/qgroup.h
>>> +++ b/fs/btrfs/qgroup.h
>>> @@ -61,6 +61,26 @@ struct btrfs_qgroup_extent_record {
>>>  	struct ulist *old_roots;
>>>  };
>>>  
>>> +enum btrfs_qgroup_rsv_type {
>>> +	BTRFS_QGROUP_RSV_DATA = 0,
>>> +	BTRFS_QGROUP_RSV_META = 1,
>>> +	BTRFS_QGROUP_RSV_TYPES = 1,
>>
>> nit: Why not BTRFS_QGROUP_RSV_TYPES_MAX = 2;
> 
> My original plan is just as the same as yours.
> 
> However I still remember I did it before and David fixed it by using
> TYPES, so I follow his naming schema here.

I don't really care about whether it's called TYPES or _MAX. The more
important thing is the fact that we have types set to the same value as
the last valid value and thus when writing loops or checking ranges we
need to use <= and + 1 respectively which IMO is a bit
counter-intuitive. But as I said it's a nit so I don't have strong
preference either way if this is the convention of btrfs so be it.
> 
> Kernel is also using this naming schema else where:
> d91876496bcf ("btrfs: compress: put variables defined per compress type
> in struct to make cache friendly")
> 
>>
>>> +};
>>> +
>>> +/*
>>> + * Represents how many bytes we reserved for this qgroup.
>>> + *
>>> + * Each type should have different reservation behavior.
>>> + * E.g, data follows its io_tree flag modification, while
>>> + * *currently* meta is just reserve-and-clear during transcation.
>>> + *
>>> + * TODO: Add new type for delalloc, which can exist across several
>>> + * transaction.
>>> + */
>>> +struct btrfs_qgroup_rsv {
>>> +	u64 values[BTRFS_QGROUP_RSV_TYPES + 1];
>>
>> nit: And here just BTRFS_QGROUP_RSV_TYPES_MAX rather than the +1 here,
>> seems more idiomatic to me.
> 
> To follow same naming schema from David.
> (IIRC it was about tree-checker patchset, checking file extent type part)
> 
> In fact, I crashed kernel several times due to the tiny +1, without even
> a clue for hours just testing blindly, until latest gcc gives warning
> about it.

So you crashed the kernel because you were missing it or not ?

> 
> Thanks,
> Qu
> 
>>
>>> +};
>>> +
>>>  /*
>>>   * one struct for each qgroup, organized in fs_info->qgroup_tree.
>>>   */
>>> @@ -88,6 +108,7 @@ struct btrfs_qgroup {
>>>  	 * reservation tracking
>>>  	 */
>>>  	u64 reserved;
>>> +	struct btrfs_qgroup_rsv rsv;
>>>  
>>>  	/*
>>>  	 * lists
>>> @@ -228,12 +249,14 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>>>  			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
>>>  			 struct btrfs_qgroup_inherit *inherit);
>>>  void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>>> -			       u64 ref_root, u64 num_bytes);
>>> +			       u64 ref_root, u64 num_bytes,
>>> +			       enum btrfs_qgroup_rsv_type type);
>>>  static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_info *fs_info,
>>>  						 u64 ref_root, u64 num_bytes)
>>>  {
>>>  	trace_btrfs_qgroup_free_delayed_ref(fs_info, ref_root, num_bytes);
>>> -	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
>>> +	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes,
>>> +				  BTRFS_QGROUP_RSV_DATA);
>>>  }
>>>  
>>>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
