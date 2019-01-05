Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B305C43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 05:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E952E21871
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 05:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tnGiyMrp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfAEFpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 5 Jan 2019 00:45:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37758 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfAEFpZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2019 00:45:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x055jJH0157545;
        Sat, 5 Jan 2019 05:45:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=QQuzjjmIe9NCyhchFDBf3Y+9Wjwf55JOzC1X3mXqP2o=;
 b=tnGiyMrpJdll/iLR2ryA54FQFjLOIo8iCMjfmUJT1JAWgFTZqEC3Ce+wLuHdcOTl1L+0
 xDS+7BWpOH+9+VtIwsBPjD9pPo28yTaXdwfCJIl95PDmT7hkOTGQptDwCwQ5JO/mekkr
 xcaMtK9WMlw6VMVk7Aw9U4uvMT10PAQdMd++z9WRc939GLRvOpdM/xmppPDuGH2MJR8O
 G/sL73PzaxYSiEpJ1enVxqiYkGO15IE/0pT08lkxyxi1nXbWHPXTh2Rlze8H5wgkQ7P0
 WDny2kNLk5shMPC7Hy/Qvk4sN8UWhS5R+sfN3PHj8hjrpGRdtxX3CvXqql3bGxo8KNW+ xQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ptn7qg3dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Jan 2019 05:45:19 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x055jI0j020761
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 5 Jan 2019 05:45:18 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x055jHq5004902;
        Sat, 5 Jan 2019 05:45:17 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Jan 2019 21:45:17 -0800
Subject: Re: [PATCH 1/1] btrfs-progs: btrfstune: print seeding status
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Disseldorp <ddiss@suse.de>, linux-btrfs@vger.kernel.org
References: <20190103232239.11931-1-ddiss@suse.de>
 <20190103232239.11931-2-ddiss@suse.de>
 <5e76f1f9-27aa-c89c-861a-9d6a9f197482@suse.com>
 <20190104112645.2a39eca8@suse.de>
 <85b4bef0-20ae-9cac-5ddb-955fe2331a0d@suse.com>
 <20190104143415.1a4d4296@suse.de>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <fd438225-19ef-e755-e3eb-4d95377824ef@oracle.com>
Date:   Sat, 5 Jan 2019 13:45:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190104143415.1a4d4296@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9126 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=963
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901050049
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


On 01/04/2019 09:34 PM, David Disseldorp wrote:
> On Fri, 4 Jan 2019 15:18:13 +0200, Nikolay Borisov wrote:
> 
>> IMO seed has really been
>> hacked on "just because" and is lacking coherent design,

Can you elaborate please?

It has great potential, especially in the golden image kind of 
environment, current missing feature is ability to propagate and apply 
the golden image diff. Also it can be a choice of feature for the OS 
installation. I see a lot of potential in it.


>> I'd prefer it
>> didn't proliferate and rely on what we have currently.

> That's unfortunate to hear. Seed devices are IMO a very cool feature for
> transactional OS updates and live installers.



> Cheers, David
> 
