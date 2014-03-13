Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18463 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbaCML04 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 07:26:56 -0400
Message-ID: <5321957F.7070104@cn.fujitsu.com>
Date: Thu, 13 Mar 2014 19:24:47 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: mkfs: make sure we can deal with hard
 links with -r option
References: <1394533749-3138-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1394533749-3138-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140312162151.GB6782@twin.jikos.cz>
In-Reply-To: <20140312162151.GB6782@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

On 03/13/2014 12:21 AM, David Sterba wrote:
> On Tue, Mar 11, 2014 at 06:29:09PM +0800, Wang Shilong wrote:
>> @@ -840,6 +833,10 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
>>   					      cur_file->d_name, cur_inum,
>>   					      parent_inum, dir_index_cnt,
>>   					      &cur_inode);
>> +			if (ret == -EEXIST) {
>> +				BUG_ON(st.st_nlink <= 1);
> As the mkfs operation is restartable, can we handle the error?
This should be a logic error which means a inode has hard links(but 
links <= 1). :-)

Add error handling may be better,  i will update it.

Thanks,
Wang
>
> Otherwise, good fix, thanks.
>
>> +				continue;
>> +			}
>>   			if (ret) {
>>   				fprintf(stderr, "add_inode_items failed\n");
>>   				goto fail;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

