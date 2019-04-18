Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA970C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B4220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M4mMkm0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389278AbfDRO2E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:28:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45556 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388850AbfDRO2E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 10:28:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3IEJ9JG087522;
        Thu, 18 Apr 2019 14:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=jZYXterq57G6BOn8qO8nhhBcCQkHPMgJXZAiNYomR+s=;
 b=M4mMkm0cIuX2jLwkoOjkql4XlQHuwmeuAMf5KyWgYPBvWg+8leboNxR2xR3MpKIZYaNc
 75bxdGjRw48+wfvI9JJeVP0TYQAB+LNDoZC1JLO9RPEksWgzIF04XwZ/VO3NwNOxgn7e
 1a4P5ZYLnbM7QB7zuijKRnEZC30cgvsA3a9dcVm7hx8ACnj9onxVvUS11wlmwCRQ3Nlh
 ZG7Dej5CCuROnK30qBVBguLIP00qX4xCj5V5CriM2AePJvOSbYCK+YTVttVffXQ5fhED
 9mflV4bdK2b7xZZoJNuHNLCqmdQyqLiaRtUMQJx8Jc9+tuz82GvAUiEUTrzmkw/m6Nff Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2ru59dh6nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Apr 2019 14:28:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3IEQBqO183550;
        Thu, 18 Apr 2019 14:28:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2rwe7b0g40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Apr 2019 14:27:59 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3IERx8F031952;
        Thu, 18 Apr 2019 14:27:59 GMT
Received: from [192.168.1.119] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Apr 2019 07:27:59 -0700
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 2/2 RFC] btrfs: start transaction in
 btrfs_ioctl_setflags()
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20190417153706.29942-1-anand.jain@oracle.com>
 <20190417153706.29942-3-anand.jain@oracle.com>
 <20190418132358.GM20156@twin.jikos.cz>
Message-ID: <d4070d00-429a-704a-7960-e56fb7d0ba72@oracle.com>
Date:   Thu, 18 Apr 2019 22:27:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190418132358.GM20156@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9231 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904180098
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9231 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904180098
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Thanks for the comments.. more below.

On 18/4/19 9:23 PM, David Sterba wrote:
> On Wed, Apr 17, 2019 at 11:37:06PM +0800, Anand Jain wrote:
>> When inode attribute flags is set through FS_IOC_SETFLAGS ioctl, there is
>> a bit of duplicate codes, the following things happens twice -
>> start/end_transaction, inode_inc_iversion(), current_time update to
>> inode->i_ctime, and btrfs_update_inode(). These are updated both at
>> btrfs_ioctl_setflags() and btrfs_set_props() as well. (RFC: So inode
>> version and the generation number should have increased by +2, but I
>> don't see that in the test case below ran without this patch)

Looks like we don't commit transaction on the end transaction. So its
just about optimizing the duplicate code.

>> This patch merges these two duplicate codes at btrfs_ioctl_setflags().
>>
>> $ cat a
>> mkfs.btrfs -fq /dev/sdb || exit
>> mount /dev/sdb /btrfs
>> touch /btrfs/file1
>> sync
>> echo before:
>> btrfs in dump-super /dev/sdb | grep ^generation
>> btrfs in dump-tree /dev/sdb | grep -A4 "257 XATTR_ITEM"
>> btrfs in dump-tree /dev/sdb | grep -A4 "257 INODE_ITEM 0) item"
>> echo
>> echo "chattr +Ac /btrfs/file1"
>> chattr +Ac /btrfs/file1
>> sync
>> echo after:
>> btrfs in dump-super /dev/sdb | grep ^generation
>> btrfs in dump-tree /dev/sdb | grep -A4 "257 XATTR_ITEM"
>> btrfs in dump-tree /dev/sdb | grep -A4 "257 INODE_ITEM 0) item"
>>
>> $ umount /btrfs; ./a
>> before:
>> generation		6
>> 	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
>> 		generation 6 transid 6 size 0 nbytes 0
>> 		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>> 		sequence 19 flags 0x0(none)
>>
>> chattr +Ac /btrfs/file1
>> after:
>> generation		7
>> 	item 6 key (257 XATTR_ITEM 550297449) itemoff 15815 itemsize 51
>> 		location key (0 UNKNOWN.0 0) type XATTR
>> 		transid 7 data_len 4 name_len 17
>> 		name: btrfs.compression
>> 		data zlib
>> 	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
>> 		generation 6 transid 7 size 0 nbytes 0
>> 		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>> 		sequence 21 flags 0xa00(NOATIME|COMPRESS)
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ioctl.c | 38 ++++++++++++++++++--------------------
>>   fs/btrfs/props.c |  6 +++---
>>   fs/btrfs/props.h |  3 +++
>>   3 files changed, 24 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 63e6e2f5b659..82772523bb87 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -192,6 +192,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>   	u64 old_flags;
>>   	unsigned int old_i_flags;
>>   	umode_t mode;
>> +	const char *comp = NULL;
>>   
>>   	if (!inode_owner_or_capable(inode))
>>   		return -EPERM;
>> @@ -283,14 +284,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>   	if (fsflags & FS_NOCOMP_FL) {
>>   		binode->flags &= ~BTRFS_INODE_COMPRESS;
>>   		binode->flags |= BTRFS_INODE_NOCOMPRESS;
>> -
>> -		/* set no-compression no need to validate prop here */
>> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
>> -					   0, 0);
>> -		if (ret && ret != -ENODATA)
>> -			goto out_drop;
>>   	} else if (fsflags & FS_COMPR_FL) {
>> -		const char *comp;
>>   
>>   		if (IS_SWAPFILE(inode)) {
>>   			ret = -ETXTBSY;
>> @@ -300,36 +294,40 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>   		binode->flags |= BTRFS_INODE_COMPRESS;
>>   		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
>>   
>> -		/* compress_type is already validated during mount options */
>>   		comp = btrfs_compress_type2str(fs_info->compress_type);
>>   		if (!comp || comp[0] == 0)
>>   			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
>> -
>> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", comp,
>> -					   strlen(comp), 0);
>> -		if (ret)
>> -			goto out_drop;
>> -
>>   	} else {
>> -		/* reset prop, no need of validate prop here */
>> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
>> -					   0, 0);
>> -		if (ret && ret != -ENODATA)
>> -			goto out_drop;
>>   		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
>>   	}
>>   
>> -	trans = btrfs_start_transaction(root, 1);
>> +	trans = btrfs_start_transaction(root, 3);
> 
> This should reflect if the properties are actually changed or not, so
> there's not unnecessary reservation made.

  Here we assume reset a flag, if its unset.
  So to preserve a flag which is already set, the cli
  internally is doing some kind of read modify write.
  So we over write the compression property with the
  same value all the time. Can this optimization go into
  a new patch, as its been like that in the original code
  as well.


>>   	if (IS_ERR(trans)) {
>>   		ret = PTR_ERR(trans);
>>   		goto out_drop;
>>   	}
>>   
>> +	if (comp) {
>> +		ret = btrfs_set_prop(trans, inode, "btrfs.compression", comp,
>> +				     strlen(comp), 0);
>> +		if (ret)
>> +			goto out_abort;
> 
> Transaction abort should be done at the place where they happen and not
> aggregated.

  oh yes. Will do.

> I see now that the validation is not necessary here.
> 
>> +		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
>> +	} else {
>> +		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL,
>> +				     0, 0);
>> +		if (ret && ret != -ENODATA)
>> +			goto out_abort;
> 
> Same.

yep thanks.

>> +	}
>> +
>>   	btrfs_sync_inode_flags_to_i_flags(inode);
>>   	inode_inc_iversion(inode);
>>   	inode->i_ctime = current_time(inode);
>>   	ret = btrfs_update_inode(trans, root, inode);
>>   
>> + out_abort:
>> +	if (ret)
>> +		btrfs_abort_transaction(trans, ret);
>>   	btrfs_end_transaction(trans);
>>    out_drop:
>>   	if (ret) {
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index e356dd2a0f73..aedf5a7d69c9 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -72,9 +72,9 @@ int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
>>   	return handler->validate(value, value_len);
>>   }
>>   
>> -static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>> -			  const char *name, const char *value, size_t value_len,
>> -			  int flags)
>> +int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>> +		   const char *name, const char *value, size_t value_len,
>> +		   int flags)
> 
> Exporting a fuction should be in another patch.

ok.

Thanks, Anand

>>   {
>>   	const struct prop_handler *handler;
>>   	int ret;
>> diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
>> index 01d2c1899bc7..30b99348977d 100644
>> --- a/fs/btrfs/props.h
>> +++ b/fs/btrfs/props.h
>> @@ -12,6 +12,9 @@ void __init btrfs_props_init(void);
>>   
>>   int btrfs_set_prop_trans(struct inode *inode, const char *name,
>>   			 const char *value, size_t value_len, int flags);
>> +int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>> +		   const char *name, const char *value, size_t value_len,
>> +		   int flags);
>>   int btrfs_validate_prop(const char *name, const char *value, size_t value_len);
>>   
>>   int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
>> -- 
>> 2.17.1
