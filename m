Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B11C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 09:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73E5D206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 09:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="brGrFKKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfBUJDz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 04:03:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48952 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfBUJDz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 04:03:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1L93i6A083137;
        Thu, 21 Feb 2019 09:03:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=45oI+081Nkpae/Ae56N+x7xGmESgepT4GKwXvi3u+B8=;
 b=brGrFKKPP8HToTA5vt9I2symwd6UE40o8td/PHpgdNDpApUPpyQF5iiqPZ9x2zKi3axx
 9ggvNXwWvUvRXwVnVHZFBqjY/H7jRHkBo8RoQxwW19GmH8hLHDATRGLUBro6UtgB4F2M
 pZhBhLOMCxf01Wn23rZhIxt/xQxPPQKDSQVnzUHu9lkuDXWhCBrBHWg8CI9js7I5hed2
 7wrh4gYVBAqGW8epOmArPNFoK2QpZLi82837lh/tQWrNE2WA1JhYQgSuOGhfcWA45mWb
 qLFPi2kBWWbMWqJFG2sltNYzkTkQd8DnhEsjsIbcH8Aq7mhBUZMO7NYRRxKMctSojpOo dw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qp81eeru1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Feb 2019 09:03:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1L93mTd018857
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Feb 2019 09:03:48 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1L93mMP028165;
        Thu, 21 Feb 2019 09:03:48 GMT
Received: from [172.20.10.2] (/157.49.213.142)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 01:03:47 -0800
Subject: Re: [PATCH v3 1/3] btrfs: kill __btrfs_set_prop()
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1549937931-15339-1-git-send-email-anand.jain@oracle.com>
 <1549937931-15339-2-git-send-email-anand.jain@oracle.com>
 <20190220190020.GA9874@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <01e83b68-cd54-26ae-f4d1-3702ae13bbca@oracle.com>
Date:   Thu, 21 Feb 2019 17:03:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190220190020.GA9874@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9173 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=842 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902210068
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/21/19 3:00 AM, David Sterba wrote:
> On Tue, Feb 12, 2019 at 10:18:49AM +0800, Anand Jain wrote:
>> btrfs_set_prop() is a redirect to __btrfs_set_prop() with the
>> transaction handler equal to NULL. And __btrfs_set_prop() inturn diectly
>> uses trans to do_setxattr() which when trans is NULL creates a transaction.
> 
> That's right and I think that some of the callsites could actually pass
> the existing transaction to btrfs_set_prop instead of relying on the
> fallback behaviour.
> 
> Also, the potential NULL as transaction handle is not a good thing from
> the API point of view and I'd like to reduce that to minimum (there are
> some justified cases).
> 
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 3f9d7be30bf4..5a4ed2f66e09 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -284,7 +284,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>   		binode->flags &= ~BTRFS_INODE_COMPRESS;
>>   		binode->flags |= BTRFS_INODE_NOCOMPRESS;
>>   
>> -		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>> +		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
>> +				     0);
>>   		if (ret && ret != -ENODATA)
>>   			goto out_drop;
>>   	} else if (fsflags & FS_COMPR_FL) {
>> @@ -302,13 +303,14 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>   		if (!comp || comp[0] == 0)
>>   			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
>>   
>> -		ret = btrfs_set_prop(inode, "btrfs.compression",
>> -				     comp, strlen(comp), 0);
>> +		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", comp,
>> +				     strlen(comp), 0);
>>   		if (ret)
>>   			goto out_drop;
>>   
>>   	} else {
>> -		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>> +		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
>> +				     0);
>>   		if (ret && ret != -ENODATA)
>>   			goto out_drop;
>>   		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
> 
> When the if-else block ends, there's a new transaction started, this
> seems unnecessary.
> 
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index dc6140013ae8..4525a2a4d1cd 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -85,12 +85,9 @@ static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
>>   	return NULL;
>>   }
>>   
>> -static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
>> -			    struct inode *inode,
>> -			    const char *name,
>> -			    const char *value,
>> -			    size_t value_len,
>> -			    int flags)
>> +int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>> +		   const char *name, const char *value, size_t value_len,
>> +		   int flags)
>>   {
>>   	const struct prop_handler *handler;
>>   	int ret;
>> @@ -133,15 +130,6 @@ static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
>>   	return 0;
>>   }
>>   
>> -int btrfs_set_prop(struct inode *inode,
>> -		   const char *name,
>> -		   const char *value,
>> -		   size_t value_len,
>> -		   int flags)
>> -{
>> -	return __btrfs_set_prop(NULL, inode, name, value, value_len, flags);
> 
> I agree that one function would be better here, with defined semantics
> of 'trans'.
> 
> There are more cleanups around the properties, also in the xattr
> handling functions. This patchset is a step in the right direction and I
> think the cleanups could be more extensive.
> 
> The idea for the xattr function:
> 
> - the VFS callbacks (like btrfs_xattr_handler_set_prop) will start the
>    transaction themselves and pass the handle to the prop function

These vfs callbacks must handle the update inode part as well, which 
btrfs_setxattr() skips if trans != NULL.

----
         inode_inc_iversion(inode);
         inode->i_ctime = current_time(inode);
         set_bit(BTRFS_INODE_COPY_EVERYTHING, 
&BTRFS_I(inode)->runtime_flags);
         ret = btrfs_update_inode(trans, root, inode);
----

Will give a try.

> - a xattr function that does not take a valid trans could be named like
>    btrfs_setxattr_notrans and will start the transaction, ie. lifting
>    that to the callers

Yep. Also btrfs_set_props_notrans() and btrfs_set_acl_notrans().

> - there's a maze of the xattr callbacks so assertions are needed

ok.

Thanks, Anand
