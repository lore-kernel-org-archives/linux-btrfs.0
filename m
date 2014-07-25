Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10905 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758584AbaGYBWm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 21:22:42 -0400
Message-ID: <53D1B021.6040501@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 09:17:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Kevin Brandstatter <icarusthecow@gmail.com>,
        Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs_qgroup_create unused parameter
References: <53B708CC.5020306@gmail.com> <474060AA-5D86-40F9-BD9C-27A68F732D63@gmail.com> <53D1958D.1070202@gmail.com>
In-Reply-To: <53D1958D.1070202@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kevin,

On 07/25/2014 07:23 AM, Kevin Brandstatter wrote:
> I submitted a patch for this a week or two ago
> (https://patchwork.kernel.org/patch/4486121/), but latest for-linus
> doesn't have it merged, is it just being put of as minor, or is there a
> problem with it?
I believe your patch will be picked up by Chris and sent to Linus
when next merge window is open.

Since Chris is sometimes busy, patch merging is always
delayed for some time.

Thanks,
Wang
>
> -Kevin
>
> On 07/04/2014 09:09 PM, Wang Shilong wrote:
>> Hi
>>
>> I think you are right,  @name here is unneeded..
>> You can give a patch for that.^_^
>>
>> Wang
>>> |The code is pasted below for convenience of reference, but in the function to
>>> create a qgruop, it taks a 4th parameter (char * name). I assume this is the name
>>> of the path to limit, however, i don't see where its used anywhere in the function.
>>>
>>> -Kevin Brandstatter
>>>
>>> int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
>>> 			struct btrfs_fs_info *fs_info, u64 qgroupid, *char** *****name**)*
>>> {
>>> 	struct btrfs_root *quota_root;
>>> 	struct btrfs_qgroup *qgroup;
>>> 	int ret = 0;
>>>
>>> 	mutex_lock(&fs_info->qgroup_ioctl_lock);
>>> 	quota_root = fs_info->quota_root;
>>> 	if (!quota_root) {
>>> 		ret = -EINVAL;
>>> 		goto out;
>>> 	}
>>> 	qgroup = find_qgroup_rb(fs_info, qgroupid);
>>> 	if (qgroup) {
>>> 		ret = -EEXIST;
>>> 		goto out;
>>> 	}
>>>
>>> 	ret = add_qgroup_item(trans, quota_root, qgroupid);
>>> 	if (ret)
>>> 		goto out;
>>>
>>> 	spin_lock(&fs_info->qgroup_lock);
>>> 	qgroup = add_qgroup_rb(fs_info, qgroupid);
>>> 	spin_unlock(&fs_info->qgroup_lock);
>>>
>>> 	if (IS_ERR(qgroup))
>>> 		ret = PTR_ERR(qgroup);
>>> out:
>>> 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
>>> 	return ret;
>>> }|
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

