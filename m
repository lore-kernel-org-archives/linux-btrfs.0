Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39645 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754459AbbIIBkW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 21:40:22 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t891e7jA011921
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 09:40:07 +0800
Subject: Re: [PATCH 10/19] btrfs: delayed_ref: release and free qgroup
 reserved at proper timing
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1441703318-25733-3-git-send-email-quwenruo@cn.fujitsu.com>
 <55EF89AD.2010907@jp.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55EF8E03.5020408@cn.fujitsu.com>
Date: Wed, 9 Sep 2015 09:40:19 +0800
MIME-Version: 1.0
In-Reply-To: <55EF89AD.2010907@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Tsutomu Itoh wrote on 2015/09/09 10:21 +0900:
> Hi, Qu,
>
> On 2015/09/08 18:08, Qu Wenruo wrote:
>> Qgroup reserved space needs to be released from inode dirty map and get
>> freed at different timing:
>>
>> 1) Release when the metadata is written into tree
>> After corresponding metadata is written into tree, any newer write will
>> be COWed(don't include NOCOW case yet).
>> So we must release its range from inode dirty range map, or we will
>> forget to reserve needed range, causing accounting exceeding the limit.
>>
>> 2) Free reserved bytes when delayed ref is run
>> When delayed refs are run, qgroup accounting will follow soon and turn
>> the reserved bytes into rfer/excl numbers.
>> As run_delayed_refs and qgroup accounting are all done at
>> commit_transaction() time, we are safe to free reserved space in
>> run_delayed_ref time().
>>
>> With these timing to release/free reserved space, we should be able to
>> resolve the long existing qgroup reserve space leak problem.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>    fs/btrfs/extent-tree.c |  4 ++++
>>    fs/btrfs/inode.c       | 10 ++++++++++
>>    fs/btrfs/qgroup.c      |  5 ++---
>>    fs/btrfs/qgroup.h      |  8 +++++++-
>>    4 files changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 5411f0a..65e60eb 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2345,6 +2345,10 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>>    						      node->num_bytes);
>>    			}
>>    		}
>> +
>> +		/* Also free its reserved qgroup space */
>> +		btrfs_qgroup_free_refroot(root->fs_info, head->qgroup_ref_root,
>> +					  head->qgroup_reserved);
>>    		return ret;
>>    	}
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 61b2c17..1f7cac0 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -2112,6 +2112,16 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>>    	ret = btrfs_alloc_reserved_file_extent(trans, root,
>>    					root->root_key.objectid,
>>    					btrfs_ino(inode), file_pos, &ins);
>> +	if (ret < 0)
>> +		goto out;
>> +	/*
>> +	 * Release the reserved range from inode dirty range map, and
>> +	 * move it to delayed ref codes, as now accounting only happens at
>> +	 * commit_transaction() time.
>> +	 */
>> +	btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
>> +	ret = btrfs_add_delayed_qgroup_reserve(root->fs_info, trans,
>> +			root->objectid, disk_bytenr, ram_bytes);
>>    out:
>>    	btrfs_free_path(path);
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index ba7888f..5a69a2d 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2169,14 +2169,13 @@ out:
>>    	return ret;
>>    }
>>
>> -void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
>> +void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>> +			       u64 ref_root, u64 num_bytes)
>>    {
>>    	struct btrfs_root *quota_root;
>>    	struct btrfs_qgroup *qgroup;
>> -	struct btrfs_fs_info *fs_info = root->fs_info;
>>    	struct ulist_node *unode;
>>    	struct ulist_iterator uiter;
>> -	u64 ref_root = root->root_key.objectid;
>>    	int ret = 0;
>>
>>    	if (!is_fstree(ref_root))
>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>> index 8e69dc1..49fa15e 100644
>> --- a/fs/btrfs/qgroup.h
>> +++ b/fs/btrfs/qgroup.h
>> @@ -75,7 +75,13 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>>    			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
>>    			 struct btrfs_qgroup_inherit *inherit);
>>    int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
>> -void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
>> +void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>> +			       u64 ref_root, u64 num_bytes);
>> +static inline void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
>> +{
>> +	return btrfs_qgroup_free_refroot(root->fs_info, root->objectid,
>> +					 num_bytes);
>
> Is 'return' necessary?
>
> Thanks,
> Tsutomu
>

Hi Itoh-san

Unnecessary yet, but should provide some extensibility for later 
modification.

For example, if later qgroup_free() function need to return value, then
it will be quite easy to modify.

But I'm OK to remove the return as it's not used now.

Also thanks for the spell check, I'll update them in the next pull 
request directly, without patch bombing the mail list.

Thanks,
Qu
>> +}
>>
>>    void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
