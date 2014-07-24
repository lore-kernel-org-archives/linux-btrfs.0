Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63570 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaGXXX7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 19:23:59 -0400
Received: by mail-ig0-f180.google.com with SMTP id l13so96168iga.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 16:23:58 -0700 (PDT)
Message-ID: <53D1958D.1070202@gmail.com>
Date: Thu, 24 Jul 2014 18:23:57 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs_qgroup_create unused parameter
References: <53B708CC.5020306@gmail.com> <474060AA-5D86-40F9-BD9C-27A68F732D63@gmail.com>
In-Reply-To: <474060AA-5D86-40F9-BD9C-27A68F732D63@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I submitted a patch for this a week or two ago
(https://patchwork.kernel.org/patch/4486121/), but latest for-linus
doesn't have it merged, is it just being put of as minor, or is there a
problem with it?

-Kevin

On 07/04/2014 09:09 PM, Wang Shilong wrote:
> Hi 
>
> I think you are right,  @name here is unneeded..
> You can give a patch for that.^_^
>
> Wang
>> |The code is pasted below for convenience of reference, but in the function to 
>> create a qgruop, it taks a 4th parameter (char * name). I assume this is the name
>> of the path to limit, however, i don't see where its used anywhere in the function.
>>
>> -Kevin Brandstatter
>>
>> int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
>> 			struct btrfs_fs_info *fs_info, u64 qgroupid, *char** *****name**)*
>> {
>> 	struct btrfs_root *quota_root;
>> 	struct btrfs_qgroup *qgroup;
>> 	int ret = 0;
>>
>> 	mutex_lock(&fs_info->qgroup_ioctl_lock);
>> 	quota_root = fs_info->quota_root;
>> 	if (!quota_root) {
>> 		ret = -EINVAL;
>> 		goto out;
>> 	}
>> 	qgroup = find_qgroup_rb(fs_info, qgroupid);
>> 	if (qgroup) {
>> 		ret = -EEXIST;
>> 		goto out;
>> 	}
>>
>> 	ret = add_qgroup_item(trans, quota_root, qgroupid);
>> 	if (ret)
>> 		goto out;
>>
>> 	spin_lock(&fs_info->qgroup_lock);
>> 	qgroup = add_qgroup_rb(fs_info, qgroupid);
>> 	spin_unlock(&fs_info->qgroup_lock);
>>
>> 	if (IS_ERR(qgroup))
>> 		ret = PTR_ERR(qgroup);
>> out:
>> 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
>> 	return ret;
>> }|
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

