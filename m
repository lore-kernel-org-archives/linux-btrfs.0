Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDE3C46465
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9891420827
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FvIVS/ff"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9891420827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbeKHSID (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 13:08:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49278 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbeKHSID (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 13:08:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA88OPlq143193;
        Thu, 8 Nov 2018 08:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XKHhjKJ/ZAhSdujjXlHVHuznPg8DZNokMQ0jUH0tJRU=;
 b=FvIVS/ff66Kp/f2eVIBqtZDBnLiBl5zBwapgbpmaArNH9pwC8OBLvauKVoCLXSsHuhnO
 Ae+yYeeKralrh/AkPMSmg6brzRjfnxmTTnzbwe5GaJFb2NjFNnXgv2pJf/HDKCYoQFhA
 d8gWIjuvbg0qrsW4qzQjeEDtzTCEkLe8ZSuoA+8mifksZDg+NMYrRiaX38izGdjrKy2w
 IIz6HyEO9itlrZRvx+tKBhacAsu4w1GGzoiTzlgUeRAAEindRJIEhh6vMqEGRd+2abGN
 KUiPyFliYw67GrkjlHiH8xSP6EWcewh5CJT1JUF9Gvaf/LyPm9wtT1RkA6GQ5udcN5SF xQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nh33u81h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Nov 2018 08:33:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA88XZBK015125
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Nov 2018 08:33:36 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA88XZoZ022390;
        Thu, 8 Nov 2018 08:33:35 GMT
Received: from [192.168.0.120] (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Nov 2018 00:33:35 -0800
Subject: Re: [PATCH 6/9] btrfs: replace's scrub must not be running in replace
 suspended state
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
 <1541591010-29789-7-git-send-email-anand.jain@oracle.com>
 <f8226bea-0d58-ab46-cf09-f107bdb123b1@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <c2dd08ef-86ea-42d9-de45-5b3a10a809ca@oracle.com>
Date:   Thu, 8 Nov 2018 16:33:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f8226bea-0d58-ab46-cf09-f107bdb123b1@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9070 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811080074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/07/2018 08:19 PM, Nikolay Borisov wrote:
> 
> 
> On 7.11.18 г. 13:43 ч., Anand Jain wrote:
>> +		/* scrub for replace must not be running in suspended state */
>> +		if (btrfs_scrub_cancel(fs_info) != -ENOTCONN)
>> +			ASSERT(0);
> 
> ASSERT(btrfs_scrub_cancel(fs_info) == -ENOTCONN)
> 

There will be substantial difference in code when compiled with and 
without CONFIG_BTRFS_ASSERT [1]. That is, btrfs_scrub_cancel(fs_info)
won't be run at all,  I would like to keep it as it is.

[1]
------
./fs/btrfs/ctree.h
#ifdef CONFIG_BTRFS_ASSERT

__cold
static inline void assfail(const char *expr, const char *file, int line)
{
         pr_err("assertion failed: %s, file: %s, line: %d\n",
                expr, file, line);
         BUG();
}

#define ASSERT(expr)    \
         (likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
#else
#define ASSERT(expr)    ((void)0)
#endif
-------

Thanks, Anand


