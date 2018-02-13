Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933824AbeBMJIi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:08:38 -0500
Subject: Re: [PATCH v2] btrfs: log, when replace, is canceled by the user
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20180212153658.19631-1-anand.jain@oracle.com>
 <20180213035343.18128-1-anand.jain@oracle.com>
 <91dd9719-28d6-dc4f-9e26-8cfa1f2082c9@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6802cddd-5609-bce4-5274-d2dc59b664d2@suse.com>
Date: Tue, 13 Feb 2018 11:08:36 +0200
MIME-Version: 1.0
In-Reply-To: <91dd9719-28d6-dc4f-9e26-8cfa1f2082c9@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.02.2018 11:05, Qu Wenruo wrote:
> 
> 
> On 2018年02月13日 11:53, Anand Jain wrote:
>> For forensic investigations of issues, we would want to know
>> if and when the user cancels the replace.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>> ---
>> v1->v2: use btrfs_dev_name() instead of rcu_str_deref()
>>         as btrfs_dev_name() also provides "missing" string,
>>         if needed.
> 
> Would you please provide the branch you're using?
> 
> As I couldn't find the function or macro of btrfs_dev_name()


I have it in my misc-next checkout. I got introduced by
3c958bd23b60 ("btrfs: add helper for device path or missing")

which is in 4.16-rc1 so pretty recent.


> 
> Thanks,
> Qu
> 
>>
>>  fs/btrfs/dev-replace.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index dd717e204b5e..3b0760f7ec8a 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -703,6 +703,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>>  {
>>  	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
>>  	struct btrfs_device *tgt_device = NULL;
>> +	struct btrfs_device *src_device = NULL;
>>  	struct btrfs_trans_handle *trans;
>>  	struct btrfs_root *root = fs_info->tree_root;
>>  	int result;
>> @@ -724,6 +725,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>>  		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>>  		tgt_device = dev_replace->tgtdev;
>> +		src_device = dev_replace->srcdev;
>>  		dev_replace->tgtdev = NULL;
>>  		dev_replace->srcdev = NULL;
>>  		break;
>> @@ -741,6 +743,11 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>>  	}
>>  	ret = btrfs_commit_transaction(trans);
>>  	WARN_ON(ret);
>> +
>> +	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s canceled",
>> +		   btrfs_dev_name(src_device), src_device->devid,
>> +		   btrfs_dev_name(tgt_device));
>> +
>>  	if (tgt_device)
>>  		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
>>  
>>
> 
