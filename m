Return-Path: <SRS0=Falb=RM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D864C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 01:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA4A204FD
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 01:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bNh/+LSt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfCIBSR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 20:18:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfCIBSQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2019 20:18:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2919biK129386;
        Sat, 9 Mar 2019 01:18:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1XVpeE0qkUquLVqmawGeqdC2WeiGBLuw6PpTDZSrM/M=;
 b=bNh/+LStr5gYnpVqnB6EVOuvNMzPjMV9D3KjPhC+W/pUS0reWAa9iwQA4G13QmjRdYSc
 wALQP1MnXD/5bINV6htCmLcg8XqugkwV/ZEJbiULCSPZ9cTT/huMYZGSaeJUVL0cFh56
 xcEp7ewv27+FHkOcpGqvty/Rdh84KFAqQYer5BnoLGdrfPvmFJyGCKsNrh5BD7vTWSps
 JWhAxi7QWmrrQGw3o1t2I+b17f+RHDXf0PpErYJQgzWenboRMyHVbv0HNpGPmuOhlhzi
 6oJb/oK+k24J6TXQWxQyZ++mJYHpFEYUs7TfCP/YmbsbX9P3rsBX67YeWby9IV4frhpn 6Q== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qyjfs37f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Mar 2019 01:18:13 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x291ICnW017586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 9 Mar 2019 01:18:12 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x291IBgX012259;
        Sat, 9 Mar 2019 01:18:11 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Mar 2019 17:18:11 -0800
Subject: Re: [PATCH v5 9/9] btrfs: kill btrfs_setxattr
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
 <1551414895-22925-10-git-send-email-anand.jain@oracle.com>
 <20190308145642.GS31119@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <03d1b29e-5249-b21c-89c0-486b12c41502@oracle.com>
Date:   Sat, 9 Mar 2019 09:18:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190308145642.GS31119@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9189 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903090005
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/8/19 10:56 PM, David Sterba wrote:
> On Fri, Mar 01, 2019 at 12:34:55PM +0800, Anand Jain wrote:
>> Now btrfs_setxattr() is a very small function with just check for
>> readonly FS and redirect the call to do_setxattr(). So instead
>> move that checks to the parent functions and call do_setxattr()
>> directly.  Delete original btrfs_setxattr(), and rename do_setxattr()
>> to btrfs_setxattr(). Also add few c-style. Kindly note the arguments
>> of original do_setxattr() and original btrfs_setxattr() are same, so the
>> diff obliterates the changes as described above.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v5: rename do_setxattr() to btrfs_setxattr(). change log update. fix c-style.
>> v4: born
>>   fs/btrfs/acl.c   |  7 +++++++
>>   fs/btrfs/props.c | 16 ++++++++++------
>>   fs/btrfs/xattr.c | 29 +++++++++--------------------
>>   fs/btrfs/xattr.h |  5 ++---
>>   4 files changed, 28 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index 2b9c3394fc34..a8a1060c8cbe 100644
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
>> +	if (btrfs_root_readonly(root)) {
>> +		ret = -EROFS;
>> +		goto out;
> 
> All the readonly checks needs to go first as it's the global condition,
> the following checks make sure that the arguments are valid and depend
> on the previous.
> 
>> -		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
>> -				       NULL, 0, flags);
>> +		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
>> +				     flags);
> 
> drive-by change
> 
>>   		if (ret)
>>   			return ret;
>>   
>> @@ -85,14 +89,14 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>>   	ret = handler->validate(value, value_len);
>>   	if (ret)
>>   		return ret;
>> -	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
>> -			       value, value_len, flags);
>> +	ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
>> +			     value_len, flags);
> 
> same
> 
>>   	if (ret)
>>   		return ret;
>>   	ret = handler->apply(inode, value, value_len);
>>   	if (ret) {
>> -		btrfs_setxattr(trans, inode, handler->xattr_name,
>> -				 NULL, 0, flags);
>> +		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
>> +				     flags);
>
> And that one silently changes the return value semantics but looks like
> the other two, "just fixing the indentation". The original code does not
> set 'ret' as the whole operation returns what the property handler
> returned.
> 
> The setxattr call here resets the property. If this is not the
> right, then fixed separately.

  That's copy and paste error. :-(. It should return ret of the
  handler->apply(). Because if the undo part which is
  btrfs_setxattr() is successful it means we fail silently.
  But at this place the handler->apply() can not fail. So the
  fail part is only theoretical.

  Also, theoretically in the original code the undo part is bit wrong,
  instead of resetting to the NULL it should reset back to the
  old value.

  I was trying to read the patch which is integrated if you
  have made any changes, so that I can send the fix. But I
  can't seems to find them.

Thanks, Anand

