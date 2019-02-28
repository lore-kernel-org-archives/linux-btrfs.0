Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8909C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738DD2171F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:36:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zQxGFwY9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbfB1Kgq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:36:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47504 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfB1Kgp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 05:36:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1SANuTD098104;
        Thu, 28 Feb 2019 10:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XdUVQpA/nurBHd3wKwyvxHIw1V05sbhXldOOaiUyJyc=;
 b=zQxGFwY96T0fRygxavLZt7hLbp1t29UxGlJ0IY6x0Db4Ez8v/l4ekpyvRiOwNiAX5yE1
 3qfcoorSmkDuQ43W3LoVhXA5+mtCpQsZgqx/IlZA0Mi5WYjz+fs/4uOoGmAl20hOC6G7
 Bou2DalmTH+RdYdvVAvYkN8DceDwmeNqTISNrTK00eFZ0jdDGgscQ4pm+PPqRx6vdzuu
 3FQQUX48f7EwpPFF576WyI8hbpi6PJ4yPB8ngLF5sNWqsckNuQ7G8qwolxjkMwjexiYX
 /eec5S+caf6R6jKVOeCJ/pd2NKLnzYwxdbATXb98i30/XGs8/xnBX5TGD+SI1H1qNs/a FA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qtupegd9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 10:36:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1SAaZ9N018653
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 10:36:36 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1SAaZFs028216;
        Thu, 28 Feb 2019 10:36:35 GMT
Received: from [172.20.10.2] (/183.90.37.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 02:36:35 -0800
Subject: Re: [PATCH v4 06/10] btrfs: start transaction in btrfs_set_prop_trans
To:     dsterba@suse.cz
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-7-git-send-email-anand.jain@oracle.com>
 <20190227160826.GT24609@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <742192e4-ce6e-df4e-aa64-1145a4e3f44a@oracle.com>
Date:   Thu, 28 Feb 2019 18:36:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190227160826.GT24609@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9180 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902280074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/28/19 12:08 AM, David Sterba wrote:
> On Sat, Feb 23, 2019 at 01:39:48AM +0800, Anand Jain wrote:
>> In preparation to make trans argument of btrfs_setxattr() a mandatory,
>> start the transaction in btrfs_set_prop_trans.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v4: born
>>   fs/btrfs/props.c | 21 ++++++++++++++++++++-
>>   1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index e581da1bfbb6..f878ba3160f0 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -4,6 +4,7 @@
>>    */
>>   
>>   #include <linux/hashtable.h>
>> +#include <linux/iversion.h>
>>   #include "props.h"
>>   #include "btrfs_inode.h"
>>   #include "transaction.h"
>> @@ -103,7 +104,25 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>>   int btrfs_set_prop_trans(struct inode *inode, const char *name,
>>   			   const char *value, size_t value_len, int flags)
>>   {
>> -	return btrfs_set_prop(NULL, inode, name, value, value_len, flags);
>> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>> +	struct btrfs_trans_handle *trans;
>> +	int ret;
>> +
>> +	trans = btrfs_start_transaction(root, 2);
>> +	if (IS_ERR(trans))
>> +		return PTR_ERR(trans);
>> +
>> +	ret = btrfs_set_prop(trans, inode, name, value, value_len, flags);
>> +
>> +	if (!ret) {
>> +		inode_inc_iversion(inode);
>> +		inode->i_ctime = current_time(inode);
>> +		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
>> +		ret = btrfs_update_inode(trans, root, inode);
>> +		ASSERT(!ret);
> 
> This is not right. The previous code uses BUG_ON which is also not
> right, but does not silently continue if asserts are compiled out.
> Please add proper error handling here.

  Error handling should save and undo of inode version, i_ctime and
  runtime_flags. Is a new patch for this OK? and here will use BUG_ON
  as in the original.

Thanks, Anand

>> +	}
>> +	btrfs_end_transaction(trans);
>> +	return ret;
>>   }
>>   
>>   static int iterate_object_props(struct btrfs_root *root,
>> -- 
>> 1.8.3.1
