Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7F9C32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF032081C
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a+I8ejv7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF032081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbeKHRlK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 12:41:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbeKHRlK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 12:41:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA88093o124756;
        Thu, 8 Nov 2018 08:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=U7F3gvAD2hrxE0+p0Kcbx6JYgK2AhFeUJU6XMf8Ply0=;
 b=a+I8ejv7nEdQQ/J0dSAnePzwUUUKYZvwGwupt0w7WQabQ8fRwuKJ2NfYx+AUHbPIEt1M
 MueyrY01AAc38NteFbW58hw3pOZtYXqAulJzI2PVcmmLtC2qMgA5OPyp+M1fkzpCnvZ4
 ghv8MtZiiX2UhW6rrlroHblvo/9LFAYo7yY2B0UL9sGrrOlGSyf/ZSUgHNYPtqNfppRK
 DWQUIorGupPOBXGD7GCuTcU3H5EjjcuKMzTnywj/3AaF7q47OtdJ4CC3MygEG49L+ZOq
 0P5BWfxAD5U6NoSQ9EaQd2xCIkYowMHpBB5m2A1pfQ+yN9B1xLMy4ZkdU1z2JCewhUnH tQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nh33u7xa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Nov 2018 08:06:50 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA886nqG009082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Nov 2018 08:06:50 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA886nPZ005601;
        Thu, 8 Nov 2018 08:06:49 GMT
Received: from [192.168.0.120] (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Nov 2018 00:06:49 -0800
Subject: Re: [PATCH 7/9] btrfs: quiten warn if the replace is canceled at
 finish
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
 <1541591010-29789-8-git-send-email-anand.jain@oracle.com>
 <87c528a9-155d-330c-a8ea-90c97fed5bd7@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <372b9c04-b3be-214c-f096-1cace73c1557@oracle.com>
Date:   Thu, 8 Nov 2018 16:06:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <87c528a9-155d-330c-a8ea-90c97fed5bd7@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9070 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=792
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811080070
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/07/2018 08:17 PM, Nikolay Borisov wrote:
> 
> 
> On 7.11.18 г. 13:43 ч., Anand Jain wrote:
>> -	WARN_ON(ret);
>> +	if (ret != -ECANCELED)
>> +		WARN_ON(ret);
> 
> WARN_ON(ret && ret != -ECANCELED)
> 

Will fix.
Thanks, Anand
