Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73CCC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 01:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62C8F206DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 01:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T6uqcg3g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfDCBCM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 21:02:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfDCBCM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 21:02:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x32MsPYS092601;
        Tue, 2 Apr 2019 23:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=HELnniJ6LraZO/6OXwGDzwww8fCswLQXMLz+/dSD/nQ=;
 b=T6uqcg3ghI9HcLlDxMtSNVBNbhByP06SrOLI94yIFQkYqNozxWe8az6YfbQx/Ets5JUS
 sqUEuM0vWUvp41YSOEKydG50yxB8iUIubYrvnicYq5vf2aNXmTVnUBrXY7MjVxaDrhJN
 BaYnNdycc5qKe4pjX4Rgbiqp9rPPb8H4wQz9L7BXupWaHN/NMWB+yGPd/j65JGbsZwEL
 JB0Idmo+UrXndeQV2x5eIqc9nIa89sQLEDDj3iGchgcxGQZ9OPTr14ysZc6OI5wS0XjK
 iLEFfxQ7uFF2NQQPSpz3PJe72o4vieVY8rxPhGyzE+u7B9vB1sOBU2ETcXgbp27Q0LR+ OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2rj0dnms18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 23:03:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x32N1I7t163766;
        Tue, 2 Apr 2019 23:03:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2rm8f519kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 23:03:07 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x32N36tx012729;
        Tue, 2 Apr 2019 23:03:06 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 16:03:06 -0700
Subject: Re: [PATCH 4/4 RESEND] btrfs: fix property validate fail should not
 increment generation
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-6-anand.jain@oracle.com>
 <20190402220410.GH29086@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <e1b3fbcd-811f-0b6f-2b9a-e511b920f0ed@oracle.com>
Date:   Wed, 3 Apr 2019 07:03:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190402220410.GH29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904020149
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020149
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/4/19 6:04 AM, David Sterba wrote:
> On Tue, Apr 02, 2019 at 06:07:42PM +0800, Anand Jain wrote:
>> When the property fails to pass the prop_handlers::validate() check, the
>> thread should exit with no changes in the kernel, but as we are starting
>> the transaction too early, we have just updated the generation even if
>> there is no change.
> 
> Agreed, this should be fixed.
> 
>>
>> For example:
>> btrfs prop get /btrfs compression
>>   compression=lzo
>> sync
>> btrfs in dump-super /dev/sdb | grep "^generation"
>>   generation		32
>>
>> Try to set an incomplete compression type
>>
>> btrfs prop set /btrfs compression zli
>>    ERROR: failed to set compression for /btrfs: Invalid argument
>> sync
>>
>> Set failed but generation is incremented
>> btrfs in dump-super /dev/sdb | grep "^generation"
>>   generation		33  <--
>>
>> Fix it by collapsing btrfs_set_prop_trans() into btrfs_set_prop(), which
>> provides flexibility to start the transaction after the
>> prop_handlers::validate() has been checked.
> 
> Please split the changes, the collapsed function make it difficult to
> review. It does not matter if you first clean up the functions and then
> switch the transaction, or the other way around.

  will do.

[1]
>> As of now if the prop_handlers::apply() fails then we still increment
>> the generation, but if there is strong prop_handlers::validate() then
>> the prop_handlers::apply() can never fail.



>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ioctl.c | 10 ++++------
>>   fs/btrfs/props.c | 59 +++++++++++++++++++++++++-------------------------------
>>   fs/btrfs/props.h |  4 ++--
>>   fs/btrfs/xattr.c |  2 +-
>>   4 files changed, 33 insertions(+), 42 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 28ee9fe6edb4..0eeaf9a68082 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -284,8 +284,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>   		binode->flags &= ~BTRFS_INODE_COMPRESS;
>>   		binode->flags |= BTRFS_INODE_NOCOMPRESS;
>>   
>> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
>> -					   0, 0);
>> +		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>>   		if (ret && ret != -ENODATA)
>>   			goto out_drop;
>>   	} else if (fsflags & FS_COMPR_FL) {
>> @@ -303,14 +302,13 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>   		if (!comp || comp[0] == 0)
>>   			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
>>   
>> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", comp,
>> -					   strlen(comp), 0);
>> +		ret = btrfs_set_prop(inode, "btrfs.compression", comp,
>> +				     strlen(comp), 0);
>>   		if (ret)
>>   			goto out_drop;
>>   
>>   	} else {
>> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
>> -					   0, 0);
>> +		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>>   		if (ret && ret != -ENODATA)
>>   			goto out_drop;
>>   		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index fb84e76f3b1d..99fa2459ba61 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -56,11 +56,12 @@ static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
>>   	return NULL;
>>   }
>>   
>> -static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>> -			  const char *name, const char *value, size_t value_len,
>> -			  int flags)
>> +int btrfs_set_prop(struct inode *inode, const char *name, const char *value,
>> +		   size_t value_len, int flags)
>>   {
>> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>>   	const struct prop_handler *handler;
>> +	struct btrfs_trans_handle *trans;
>>   	int ret;
>>   
>>   	if (btrfs_root_readonly(BTRFS_I(inode)->root))
>> @@ -74,50 +75,40 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>>   		return -EINVAL;
>>   
>>   	if (value_len == 0) {
>> +		/* Its called to reset the property */
>> +		trans = btrfs_start_transaction(root, 2);
>> +		if (IS_ERR(trans))
>> +			return PTR_ERR(trans);
>> +
>>   		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
>>   				       NULL, 0, flags);
>> -		if (ret)
>> -			return ret;
>> -
>> -		ret = handler->apply(inode, NULL, 0);
>> -		ASSERT(ret == 0);
>> -
>> -		return ret;
>> +		if (!ret) {
>> +			ret = handler->apply(inode, NULL, 0);
>> +			ASSERT(ret == 0);
>> +		}
>> +		goto out;
> 
> This block would be better in a separate helper, now that it starts the
> transaction, eg.
> 
> 	if (value_len == 0)
> 		return do_reset_property(inode, handler, flags);

  I was thinking same too. Will fix.

>>   	}
>>   
>>   	ret = handler->validate(value, value_len);
>>   	if (ret)
>>   		return ret;
>> +
>> +	trans = btrfs_start_transaction(root, 2);
>> +	if (IS_ERR(trans))
>> +		return PTR_ERR(trans);
>> +
>>   	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
>>   			       value, value_len, flags);
>>   	if (ret)
>> -		return ret;
>> +		goto out;
>> +
>>   	ret = handler->apply(inode, value, value_len);
>>   	if (ret) {
>> +		/* Apply failed. Reset the property. */
>>   		btrfs_setxattr(trans, inode, handler->xattr_name,
>>   				 NULL, 0, flags);
> 
> So that's not new code, but I wonder whether this is correct at all.
> Reset means to the original value or to empty value? The problem here is
> that it's under transaction, so this should be followed by an abort.
> 
> It maybe is possible to safely revert the value without aborting, as the
> inode is locked.

  As I mentioned [1] (above), we have this bug in the original code which
  is impossible to achieve, because apply() can never as the validate()
  has passed. So we don't need additional check in apply() for which
  it may return fail? This works as of now with the compression property.
  It should be possible to follow the same design for other upcoming
  property readmirror and encryption.

Thanks, Anand

>> -		return ret;
>> -	}
>> -
>> -	set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
>> -
>> -	return 0;
>> -}
>> -
>> -int btrfs_set_prop_trans(struct inode *inode, const char *name,
>> -			 const char *value, size_t value_len, int flags)
>> -{
>> -	struct btrfs_root *root = BTRFS_I(inode)->root;
>> -	struct btrfs_trans_handle *trans;
>> -	int ret;
>> -
>> -	trans = btrfs_start_transaction(root, 2);
>> -	if (IS_ERR(trans))
>> -		return PTR_ERR(trans);
>> -
>> -	ret = btrfs_set_prop(trans, inode, name, value, value_len, flags);
>> -
>> -	if (!ret) {
>> +	} else {
>> +		set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
>>   		inode_inc_iversion(inode);
>>   		inode->i_ctime = current_time(inode);
>>   		set_bit(BTRFS_INODE_COPY_EVERYTHING,
>> @@ -125,6 +116,8 @@ int btrfs_set_prop_trans(struct inode *inode, const char *name,
>>   		ret = btrfs_update_inode(trans, root, inode);
>>   		BUG_ON(ret);
>>   	}
>> +
>> +out:
>>   	btrfs_end_transaction(trans);
>>   	return ret;
>>   }
