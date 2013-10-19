Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43965 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3JSKc4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Oct 2013 06:32:56 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so2950105wgh.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Oct 2013 03:32:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526247E3.9000804@giantdisaster.de>
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>
	<526247E3.9000804@giantdisaster.de>
Date: Sat, 19 Oct 2013 18:32:54 +0800
Message-ID: <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing supers
From: Shilong Wang <wangshilong1991@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, it did not hurt. but it may  output checksum mismatch.  For example:
Writing 4k superblock is not totally finished, but we are trying to scrub it.

Thanks,
Wang

2013/10/19, Stefan Behrens <sbehrens@giantdisaster.de>:
> On 10/19/2013 06:17, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> Scrubing supers is not in a transaction context, when trying to
>> write supers to disk, we should check if we are trying to
>> scrub supers.Fix it.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/disk-io.c     | 2 ++
>>   fs/btrfs/transaction.c | 2 ++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 419968e..0debb19 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3582,7 +3582,9 @@ int btrfs_commit_super(struct btrfs_root *root)
>>   		return ret;
>>   	}
>>
>> +	btrfs_scrub_pause_super(root);
>>   	ret = write_ctree_super(NULL, root, 0);
>> +	btrfs_scrub_continue_super(root);
>>   	return ret;
>>   }
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 277fe81..3ebcbbd 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1892,7 +1892,9 @@ int btrfs_commit_transaction(struct
>> btrfs_trans_handle *trans,
>>   		goto cleanup_transaction;
>>   	}
>>
>> +	btrfs_scrub_pause_super(root);
>>   	ret = write_ctree_super(trans, root, 0);
>> +	btrfs_scrub_continue_super(root);
>>   	if (ret) {
>>   		mutex_unlock(&root->fs_info->tree_log_mutex);
>>   		goto cleanup_transaction;
>>
>
> What kind of race do you see between writing the 4K superblock and scrub
> checking its checksum? Or in other words, what could happen?
>
>
>
