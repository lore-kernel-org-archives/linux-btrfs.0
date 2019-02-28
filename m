Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACEEC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B079B2171F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="US9P3/eC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbfB1KkT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:40:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50944 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730827AbfB1KkT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 05:40:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1SANeXH101581;
        Thu, 28 Feb 2019 10:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Of+Sra7ZouJvTwBfJyNWjvDsJ4Bhdu4obgmgiifbGk0=;
 b=US9P3/eCDAx8sQaSqLFN/xAQEnCH7Jd71DcPAO/evK8orTn+S3I2f7isetsk0eUv4YNi
 RHEbL4IUDBBSOK17iV6PdmSoIB2LGMGYz7aHk8nvDZhhDWimTlHyItp5qLBmCk2vnlEC
 aT/hGHaHFq4VDyBiGIheiv0xsZSYiErLe6jQsr6YFJ7CbtTji/BsLvEpjDYVDqpm40d7
 cMfZNtSLaVVdDqh8Kw437IsTvEji3JCy2IWp2i2yHChoJEcYD62XX7wAaKQIus8Be/JG
 JRiK4PE2bfav9XLbQia8Hs+SF3QGmgY/KnMDRp38zOe63hYDi/DRNhd6kRoIwxph2TTH gg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qtxts05dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 10:40:15 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1SAeEA4026220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 10:40:14 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1SAeEYb010056;
        Thu, 28 Feb 2019 10:40:14 GMT
Received: from [172.20.10.2] (/183.90.37.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 02:40:14 -0800
Subject: Re: [PATCH v4 09/10] btrfs: btrfs_setxattr argument trans is never
 NULL
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-10-git-send-email-anand.jain@oracle.com>
 <20190227161617.GV24609@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <a2d3a930-106c-c07a-ed6a-44fe9a34deed@oracle.com>
Date:   Thu, 28 Feb 2019 18:40:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190227161617.GV24609@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9180 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902280074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/28/19 12:16 AM, David Sterba wrote:
> On Sat, Feb 23, 2019 at 01:39:51AM +0800, Anand Jain wrote:
>> The following patches
>>     btrfs: cleanup btrfs_set_acl
>>     btrfs: start transaction in btrfs_xattr_handler_set
>>     btrfs: create transaction in btrfs_set_prop_notrans
>>
>> made the btrfs_setxattr() argument trans to be never NULL, so delete the
>> code when trans is NULL in btrfs_setxattr(). Also fix the c-code style.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v4: born
>>   fs/btrfs/xattr.c | 28 +++++-----------------------
>>   1 file changed, 5 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
>> index 8e301a1ae304..b3281d4d95b9 100644
>> --- a/fs/btrfs/xattr.c
>> +++ b/fs/btrfs/xattr.c
>> @@ -220,35 +220,17 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
>>   /*
>>    * @value: "" makes the attribute to empty, NULL removes it
>>    */
>> -int btrfs_setxattr(struct btrfs_trans_handle *trans,
>> -		     struct inode *inode, const char *name,
>> -		     const void *value, size_t size, int flags)
>> +int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
>> +		   const char *name, const void *value, size_t size, int flags)
>>   {
>>   	struct btrfs_root *root = BTRFS_I(inode)->root;
>> -	int ret;
>> +
>> +	ASSERT(!trans);
> 
> Isn't this reversed?
> 
> 	ASSERT(trans == 0) is not what we want

You are right. As such the intention was to delete this function as a 
whole, which happened in the next patch. Will fix.

Thanks, Anand

