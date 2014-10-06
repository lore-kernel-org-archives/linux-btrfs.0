Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25706 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbaJFBLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 21:11:38 -0400
Message-ID: <5431EC6B.7010507@cn.fujitsu.com>
Date: Mon, 6 Oct 2014 09:12:11 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Don't return any fs_info that contain NULL
 tree_root or fs_root.
References: <1412044762-2480-1-git-send-email-quwenruo@cn.fujitsu.com> <20140930113556.GI11436@twin.jikos.cz>
In-Reply-To: <20140930113556.GI11436@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the late reply.

Wang's patch fixed all the NULL tree root related bugs.
So my patches are not needed and please ignore them.

I'll also reply to my patches to mark them unneeded.

Thanks,
Qu
-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: Don't return any fs_info that contain 
NULL tree_root or fs_root.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年09月30日 19:35
> On Tue, Sep 30, 2014 at 10:39:22AM +0800, Qu Wenruo wrote:
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -1134,7 +1134,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>>   	return fs_info;
>>   
>>   out_failed:
>> -	if (flags & OPEN_CTREE_PARTIAL)
>> +	if (flags & OPEN_CTREE_PARTIAL &&
>> +	    fs_info->tree_root && fs_info->fs_root)
>>   		return fs_info;
> I see a conflict with a pending patch
> https://patchwork.kernel.org/patch/4254631/
>
> that removes the check completely but fixes the crash in another way. I
> like Wang's patch because it keeps the logic about partial open inside
> btrfs_setup_all_roots(). Please test if it fixes the crash with the
> corrupted image you have. Thanks.
>
>>   out_chunk:
>>   	btrfs_release_all_roots(fs_info);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

