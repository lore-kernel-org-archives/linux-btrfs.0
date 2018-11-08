Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190F5C32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 09:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF65F2081C
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 09:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oJHDXnqA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF65F2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbeKHSmO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 13:42:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbeKHSmO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 13:42:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA894FMu174338;
        Thu, 8 Nov 2018 09:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zPKoSfdv+vY18+s5SXwq71sdJ+4fDvdhuzewePTgIz8=;
 b=oJHDXnqALnVhoEQz2zmaulp2SUOjUyNQ5hHqsz3UM8TL5E8B0S3gYPhiH2aH1PWLW1vf
 CWRmt01xdIC5OR5j1Dh0RodBto1ihSUXmGxZGs+PCqOGKIjlqL6Cjk8XAPSSW2tAmYD0
 rAjvybKILq9+fOCGKHiQmt/BaedNfB+ehaHzavuDFd62c3gftNLtTESdcYYwEeTQRQNH
 3RNxPiWCc/e0nP007ywGal5FfHlLkWmBP018S/XzovYUBEFEBqDHPB4mEAvGEHPQcF5F
 pErPWTF4Sy9C5EZnd7dF0i/3J18DG22XhIK1ZKp3M1jaDh/GeMh8wDcXulCO/bohf0jc Sg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nh33u8685-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Nov 2018 09:07:32 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA897QvV018935
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Nov 2018 09:07:26 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA897Q3F019043;
        Thu, 8 Nov 2018 09:07:26 GMT
Received: from [192.168.0.120] (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Nov 2018 01:07:26 -0800
Subject: Re: [PATCH 6/9] btrfs: replace's scrub must not be running in replace
 suspended state
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
 <1541591010-29789-7-git-send-email-anand.jain@oracle.com>
 <f8226bea-0d58-ab46-cf09-f107bdb123b1@suse.com>
 <c2dd08ef-86ea-42d9-de45-5b3a10a809ca@oracle.com>
 <96737468-b987-d2cb-c2ad-6217ac834393@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <bc1d0ae6-6b98-4e23-d9a3-06d2e0a25602@oracle.com>
Date:   Thu, 8 Nov 2018 17:07:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <96737468-b987-d2cb-c2ad-6217ac834393@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9070 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811080080
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/08/2018 04:52 PM, Nikolay Borisov wrote:
> 
> 
> On 8.11.18 г. 10:33 ч., Anand Jain wrote:
>>
>>
>> On 11/07/2018 08:19 PM, Nikolay Borisov wrote:
>>>
>>>
>>> On 7.11.18 г. 13:43 ч., Anand Jain wrote:
>>>> +        /* scrub for replace must not be running in suspended state */
>>>> +        if (btrfs_scrub_cancel(fs_info) != -ENOTCONN)
>>>> +            ASSERT(0);
>>>
>>> ASSERT(btrfs_scrub_cancel(fs_info) == -ENOTCONN)
>>>
>>
>> There will be substantial difference in code when compiled with and
>> without CONFIG_BTRFS_ASSERT [1]. That is, btrfs_scrub_cancel(fs_info)
>> won't be run at all,  I would like to keep it as it is.
> 
> Fair point, in that case do:
> 
> ret = btrfs_scrub_cancel(fs_info);
> ASSERT(ret != -ENOTCONN);

Fixed.

Thanks, Anand

> result
> 
> 
>>
>> [1]
>> ------
>> ./fs/btrfs/ctree.h
>> #ifdef CONFIG_BTRFS_ASSERT
>>
>> __cold
>> static inline void assfail(const char *expr, const char *file, int line)
>> {
>>          pr_err("assertion failed: %s, file: %s, line: %d\n",
>>                 expr, file, line);
>>          BUG();
>> }
>>
>> #define ASSERT(expr)    \
>>          (likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>> #else
>> #define ASSERT(expr)    ((void)0)
>> #endif
>> -------
>>
>> Thanks, Anand
>>
>>
