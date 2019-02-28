Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F3CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 11:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 932B72083D
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 11:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hw+Ycwin"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfB1LKQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:10:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730906AbfB1LKQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 06:10:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1SB9kua139237;
        Thu, 28 Feb 2019 11:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=JNoB020fD5stb8B4+Him4FnPZ+/0+nEqa4LtSlL3I5o=;
 b=hw+YcwinqwEFf5SPnN5TCUWS6BNPWWBGiFadJJuY3K5BgdlLMlvHgIliwf4UXOHJKFt4
 jbr3BYWh0AF5+DPGiXoEJjwURlWdBE7Pvoj4ktrncTjLu4T3I+MsA0H6PYqhJuN3htl+
 +wyd5PMM8ccOoT++TAPwZ92cbo7HmvRgc/MFEzuFDpWIyBKI4XM8SHkiR5je4IvePxaF
 B2t3AnrkS7iVXoBAlq6SuFLyKNc+KnQjg6/YiHVk/uCKaqi42W0rVa/WZrE7NDXqu1gr
 aT4yPGdEhLN1tczLR6+mCrNk5WAvuV01tsCQcKrbdHzqy1xWtfwzXB0a0twE0y3DCmDh 5Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qtxts09rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 11:10:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1SBAA8A026548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 11:10:11 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1SBAAuN000641;
        Thu, 28 Feb 2019 11:10:10 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 03:10:09 -0800
Subject: Re: [PATCH v4 10/10] btrfs: kill btrfs_setxattr
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-11-git-send-email-anand.jain@oracle.com>
 <20190227162154.GW24609@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <3859f73d-85ba-722c-0fca-7fa6ed7b5ce6@oracle.com>
Date:   Thu, 28 Feb 2019 19:10:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190227162154.GW24609@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9180 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902280078
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/28/19 12:21 AM, David Sterba wrote:
> On Sat, Feb 23, 2019 at 01:39:52AM +0800, Anand Jain wrote:
>> Now btrfs_setxattr() is a very small function with just check for
>> readonly FS and redirect the call to do_setxattr(). So instead
>> move that checks to the parent functions.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v4: born
>>   fs/btrfs/acl.c   |  9 ++++++++-
>>   fs/btrfs/props.c | 16 ++++++++++------
>>   fs/btrfs/xattr.c | 30 ++++++++----------------------
>>   fs/btrfs/xattr.h |  5 ++---
>>   4 files changed, 28 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index e395615dd304..75abe7f0d05d 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -60,6 +60,7 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
>>   	int ret, size = 0;
>>   	const char *name;
>>   	char *value = NULL;
>> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>>   
>>   	switch (type) {
>>   	case ACL_TYPE_ACCESS:
>> @@ -95,7 +96,13 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
>>   			goto out;
>>   	}
>>   
>> -	ret = btrfs_setxattr(trans, inode, name, value, size, 0);
>> +	if (btrfs_root_readonly(root)) {
>> +		ret = -EROFS;
>> +		goto out;
>> +	}
>> +
>> +	ret = do_setxattr(trans, inode, name, value, size, 0);
>> +
>>   out:
>>   	kfree(value);
>>   
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index f878ba3160f0..be6d16ccc738 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -60,6 +60,7 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>>   			  const char *name, const char *value, size_t value_len,
>>   			  int flags)
>>   {
>> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>>   	const struct prop_handler *handler;
>>   	int ret;
>>   
>> @@ -70,9 +71,12 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>>   	if (!handler)
>>   		return -EINVAL;
>>   
>> +	if (btrfs_root_readonly(root))
>> +		return -EROFS;
>> +
>>   	if (value_len == 0) {
>> -		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
>> -				     flags);
>> +		ret = do_setxattr(trans, inode, handler->xattr_name, NULL, 0,
>> +				  flags);
>>   		if (ret)
>>   			return ret;
>>   
>> @@ -85,14 +89,14 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>>   	ret = handler->validate(value, value_len);
>>   	if (ret)
>>   		return ret;
>> -	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
>> -			       value, value_len, flags);
>> +	ret = do_setxattr(trans, inode, handler->xattr_name, value, value_len,
>> +			  flags);
>>   	if (ret)
>>   		return ret;
>>   	ret = handler->apply(inode, value, value_len);
>>   	if (ret) {
>> -		btrfs_setxattr(trans, inode, handler->xattr_name,
>> -				 NULL, 0, flags);
>> +		ret = do_setxattr(trans, inode, handler->xattr_name, NULL, 0,
>> +				  flags);
>>   		return ret;
>>   	}
>>   
>> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
>> index b3281d4d95b9..4e1ccfbfa44a 100644
>> --- a/fs/btrfs/xattr.c
>> +++ b/fs/btrfs/xattr.c
>> @@ -76,9 +76,8 @@ int btrfs_getxattr(struct inode *inode, const char *name,
>>   	return ret;
>>   }
>>   
>> -static int do_setxattr(struct btrfs_trans_handle *trans,
>> -		       struct inode *inode, const char *name,
>> -		       const void *value, size_t size, int flags)
>> +int do_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
>> +		const char *name, const void *value, size_t size, int flags)
>>   {
>>   	struct btrfs_dir_item *di = NULL;
>>   	struct btrfs_root *root = BTRFS_I(inode)->root;
>> @@ -217,22 +216,6 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
>>   	return ret;
>>   }
>>   
>> -/*
>> - * @value: "" makes the attribute to empty, NULL removes it
>> - */
>> -int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
>> -		   const char *name, const void *value, size_t size, int flags)
>> -{
>> -	struct btrfs_root *root = BTRFS_I(inode)->root;
>> -
>> -	ASSERT(!trans);
>> -
>> -	if (btrfs_root_readonly(root))
>> -		return -EROFS;
>> -
>> -	return do_setxattr(trans, inode, name, value, size, flags);
>> -}
>> -
>>   ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
>>   {
>>   	struct btrfs_key key;
>> @@ -357,11 +340,14 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
>>   
>>   	name = xattr_full_name(handler, name);
>>   
>> +	if (btrfs_root_readonly(root))
>> +		return -EROFS;
>> +
>>   	trans = btrfs_start_transaction(root, 2);
>>   	if (IS_ERR(trans))
>>   		return PTR_ERR(trans);
>>   
>> -	ret = btrfs_setxattr(trans, inode, name, buffer, size, flags);
>> +	ret = do_setxattr(trans, inode, name, buffer, size, flags);
>>   
>>   	if (!ret) {
>>   		inode_inc_iversion(inode);
>> @@ -444,8 +430,8 @@ static int btrfs_initxattrs(struct inode *inode,
>>   		}
>>   		strcpy(name, XATTR_SECURITY_PREFIX);
>>   		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
>> -		err = btrfs_setxattr(trans, inode, name, xattr->value,
>> -				xattr->value_len, 0);
>> +		err = do_setxattr(trans, inode, name, xattr->value,
>> +				  xattr->value_len, 0);
>>   		kfree(name);
>>   		if (err < 0)
>>   			break;
>> diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
>> index 471fcac6ff55..276f81a622d5 100644
>> --- a/fs/btrfs/xattr.h
>> +++ b/fs/btrfs/xattr.h
>> @@ -12,9 +12,8 @@
>>   
>>   int btrfs_getxattr(struct inode *inode, const char *name,
>>   		void *buffer, size_t size);
>> -int btrfs_setxattr(struct btrfs_trans_handle *trans,
>> -			    struct inode *inode, const char *name,
>> -			    const void *value, size_t size, int flags);
>> +int do_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
>> +		const char *name, const void *value, size_t size, int flags);
> 
> No, this is backwards. Why do you promote a static helper to interface
> function but without the btrfs_ prefix?
> 
> The point of do_something functions is to actually do the thing assuming
> that external conditions have been checked, like the readonly status.
> All such checks should happen at the entry, ie. beginning of the various
> callbacks.

  I though so as well. Will rename.

Thanks, Anand

