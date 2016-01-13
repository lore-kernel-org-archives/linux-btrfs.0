Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52487 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752236AbcAMAdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 19:33:54 -0500
Subject: Re: [PATCH v2 17/25] btrfs-progs: extent-tree: Enhance
 btrfs_record_file_extent
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1448953905-28673-18-git-send-email-quwenruo@cn.fujitsu.com>
 <20160112101720.GK4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56959B4D.5060603@cn.fujitsu.com>
Date: Wed, 13 Jan 2016 08:33:17 +0800
MIME-Version: 1.0
In-Reply-To: <20160112101720.GK4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/01/12 11:17 +0100:
> On Tue, Dec 01, 2015 at 03:11:37PM +0800, Qu Wenruo wrote:
>> --- a/extent-tree.c
>> +++ b/extent-tree.c
>> +static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
>> +				      struct btrfs_root *root, u64 objectid,
>> +				      struct btrfs_inode_item *inode,
>> +				      u64 file_pos, u64 disk_bytenr,
>> +				      u64 *ret_num_bytes)
>>   {
>>   	int ret;
>>   	struct btrfs_fs_info *info = root->fs_info;
> ...
>> @@ -3999,25 +4003,80 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
>>   		return ret;
>>   	}
>>
>> -	btrfs_init_path(&path);
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
> ...
>>   fail:
>> -	btrfs_release_path(&path);
>> +	btrfs_release_path(path);
>> +	return ret;
>
> Coverity correctly complains that path leaks here.

Oh, I should use btrfs_free_path().

Should I rebase the unmerged to patches to current devel and send it again?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


