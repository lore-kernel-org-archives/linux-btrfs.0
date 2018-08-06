Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10667 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbeHFEqx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 00:46:53 -0400
Message-ID: <5B67B4FB.4080405@huawei.com>
Date: Mon, 6 Aug 2018 10:39:55 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] fs/btrfs/disk-io: Remove unneeded variable "err"
References: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>  <1533481371-21349-2-git-send-email-zhongjiang@huawei.com> <5b2806ada98cfca4346e48f1943aca6da0cda4a6.camel@perches.com>
In-Reply-To: <5b2806ada98cfca4346e48f1943aca6da0cda4a6.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/8/5 23:27, Joe Perches wrote:
> On Sun, 2018-08-05 at 23:02 +0800, zhong jiang wrote:
>> The err is not used after initalization, So remove it and make
>> the function to be void function.
> []
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> []
>> @@ -4193,7 +4192,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>>  	if (atomic_read(&delayed_refs->num_entries) == 0) {
>>  		spin_unlock(&delayed_refs->lock);
>>  		btrfs_info(fs_info, "delayed_refs has NO entry");
>> -		return ret;
> Think a little more about this please.
> This is not a sensible removal.
 I am sorry for stupid mistake.  I  will repost.

Thanks,
zhong jiang
>>  	}
>>  
>>  	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
>
> .
>


