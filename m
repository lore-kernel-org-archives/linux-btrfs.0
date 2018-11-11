Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DC6C0044C
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EED2521104
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qzoai53d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EED2521104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbeKKXtV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 18:49:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbeKKXtV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 18:49:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABDrvpJ189314;
        Sun, 11 Nov 2018 14:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=u/8Goz07GTYvMb4jgk6K1P94BAQAN9PCGN1GS1FRMw4=;
 b=Qzoai53df3ihvtqPg/bqh0uoTpWeSWwGZyLPze16/vr2MnBiEoW1Ar7d5Tg6oaQf3gjV
 TrUZNXoHEvIuQxz0j3C1+7oLF2SiJW3Nrm9tQVE577/RGyLqz58P1c0cT/VYtBqyXmtH
 12Xi7fFO+SZu1rnD9BR3/JFoo9zNHbyTQpRsH+3o5hEkCAMQpyChXkekz1YnDi4vveaU
 Ie+hZH4MX24zlwEtN5uy81ICVzgLxM3MkRlbfXmgN518q34mh8wT+Kt4KeBmf0UJZV63
 rKMS1HQc+oCL5WQUVIQ9nzEgjvGucSOQpadPewnV/scO25OkYOKprz47TQdcR2KLmVk0 Ew== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nnwg120t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Nov 2018 14:00:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wABE0bh0008866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Nov 2018 14:00:38 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wABE0bLi027929;
        Sun, 11 Nov 2018 14:00:37 GMT
Received: from [172.20.10.2] (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:00:37 -0800
Subject: Re: [PATCH 2/9] btrfs: replace go back to suspended if target missing
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
 <1541591010-29789-3-git-send-email-anand.jain@oracle.com>
 <230df6a5-109f-b3f9-f93c-e2112f016e49@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <91d53b66-11f8-e9ed-0268-7d883dfd3298@oracle.com>
Date:   Sun, 11 Nov 2018 22:00:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <230df6a5-109f-b3f9-f93c-e2112f016e49@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110134
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/07/2018 08:35 PM, Nikolay Borisov wrote:
> 
> 
> On 7.11.18 г. 13:43 ч., Anand Jain wrote:
>> At the time of forced unmount we place the running replace to
>> BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED state, so when the system comes
>> back and suppose the target device is missing, then let the replace
>> state continue to be in BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED state
>> instead of BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED as there isn't any
>> matching scrub running as part of replace.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/dev-replace.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 59991165e126..47d6768a9cde 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -884,6 +884,9 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
>>   			   "cannot continue dev_replace, tgtdev is missing");
>>   		btrfs_info(fs_info,
>>   			   "you may cancel the operation after 'mount -o degraded'");
>> +		dev_replace->replace_state =
>> +					BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
>> +		dev_replace->item_needs_writeback = 1;
> 
> Why do we need items_needs_writeback = 1 here, nothing is changed w.r.t
> on-disk data?

  You are right. We don't need writeback. Will fix.

Thanks, Anand


>>   		btrfs_dev_replace_write_unlock(dev_replace);
>>   		return 0;
>>   	}
>>
