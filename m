Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754373AbeFYIts (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 04:49:48 -0400
Subject: Re: [PATCH v2] btrfs: remove -ERANGE check and avoid errno overriding
 in btrfs_get_acl()
From: Nikolay Borisov <nborisov@suse.com>
To: Chengguang Xu <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20180623063858.10395-1-cgxu519@gmx.com>
 <c4c195c6-8a80-3823-ca2b-dd4791cd07d2@suse.com>
Message-ID: <793ca398-684d-4a40-11ea-ad673fcd995a@suse.com>
Date: Mon, 25 Jun 2018 11:49:46 +0300
MIME-Version: 1.0
In-Reply-To: <c4c195c6-8a80-3823-ca2b-dd4791cd07d2@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.06.2018 11:44, Nikolay Borisov wrote:
> 
> 
> On 23.06.2018 09:38, Chengguang Xu wrote:
>> Remove -ERANGE error check because there is no chance to get into
>> this condition and meanwhile avoid overriding errno to -EIO in
>> btrfs_get_acl().
> 
> This is way too terse. The reason why we can't get an ERANGE error is
> because we first call btrfs_getxattr to get the length of the attribute,
> then we do a subsequent call with the size from the first call. Between
> the 2 calls the size shouldn't change.
> 
> Furthermore, I see one more bad practice in this code - the first call
> to btrfs_getxattr is not using the value buffer hence it should be
> passing NULL to make this obvious, instead it's passing an empty string
> form the rodata section.

While at it, I guess you could also remove the BUG() in the default case
of the switch statement in btrfs_get_acl. A simple return
ERR_PTR(-EINVAL) should suffice.
> 
>>
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>> v2:
>> - Avoid errno overriding instead of print error message in error case.
>> - Change commit log for better understanding.
>>
>>  fs/btrfs/acl.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index 15e1dfef56a5..b71a875036af 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -40,13 +40,13 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
>>  			return ERR_PTR(-ENOMEM);
>>  		size = btrfs_getxattr(inode, name, value, size);
>>  	}
>> -	if (size > 0) {
>> +	if (size > 0)
>>  		acl = posix_acl_from_xattr(&init_user_ns, value, size);
>> -	} else if (size == -ERANGE || size == -ENODATA || size == 0) {
>> +	else if (size == -ENODATA || size == 0)
>>  		acl = NULL;
>> -	} else {
>> -		acl = ERR_PTR(-EIO);
>> -	}
>> +	else
>> +		acl = ERR_PTR(size);
>> +
>>  	kfree(value);
>>  
>>  	return acl;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
