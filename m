Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFAEC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 06:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB9DD2173C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 06:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dNXgwGb5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfBZGZr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 01:25:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfBZGZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 01:25:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1Q6OEJ6115444;
        Tue, 26 Feb 2019 06:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=S2lmXSSZWzDd0vBawewudFiFn4S1PslhclMK8UkyFDI=;
 b=dNXgwGb5v36WoM4wiG6pzXe+shByBl7VXnnyR29s/Pur5vb1PFpkxa0ZQfB7tCJziThQ
 1xDUqpEab1NuOuybooTg6M21akKE923AIEcCzXVU+uEJRspJ9obpzMjMYuZmIyaaXyVc
 x01C90N3ptMkDgzZ7O0uDtWAahzFy2nLWB7EOl9KxPggKHqB3o6f546vfUp2vVhtbWD5
 ZTXsye46n3q7fCs0TyKVufRzra5Q0Xh4Al49SqBH+E7AsmVykmmIWMvItWRUCQyAgXxm
 qq5GuOrkpaNCS+TSRvowbUNtbUWJADzwW9bx0C45v/ASFPZRe4WGQyGWX8xej1INlXBI Eg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxtrjfmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Feb 2019 06:25:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1Q6Pdvu009056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Feb 2019 06:25:39 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1Q6Pc26003442;
        Tue, 26 Feb 2019 06:25:39 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Feb 2019 22:25:38 -0800
Subject: Re: Btrfs progs release 4.20.2
From:   Anand Jain <anand.jain@oracle.com>
To:     David Sterba <dsterba@suse.com>, dsterba@suse.cz
Cc:     linux-btrfs@vger.kernel.org
References: <20190225180438.4249-1-dsterba@suse.com>
 <03a1aba5-3a19-25fe-de3a-d99ad32d2edd@oracle.com>
Message-ID: <707f025e-3980-7e5b-6fd1-93616ae696ce@oracle.com>
Date:   Tue, 26 Feb 2019 14:25:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <03a1aba5-3a19-25fe-de3a-d99ad32d2edd@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9178 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902260048
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



I got some logs with and without fix.

Test case:

Pause a balance:

# btrfs bal start --full-balance /btrfs
balance paused by user


Try to run replace now:

Without fix:

# btrfs replace start -B /dev/sdb /dev/sdc /btrfs
ERROR: ioctl(DEV_REPLACE_START) on '/btrfs' returns error: <illegal 
result value>

With fix:

# ./btrfs replace start -B /dev/sdb /dev/sdc /btrfs
ERROR: ioctl(DEV_REPLACE_START) '/btrfs': 
add/delete/balance/replace/resize operation in progress


-Anand


On 2/26/19 1:06 PM, Anand Jain wrote:
> 
> 
>   https://patchwork.kernel.org/patch/10732689/
> 
> Would like to bring to your notice. Above patch is not yet integrated 
> for a long time. Any comments?
> 
> Thanks, Anand
> 
> 
> On 2/26/19 2:04 AM, David Sterba wrote:
>> Hi,
>>
>> btrfs-progs version 4.20.2 have been released. This is a quick fix of 
>> a problem
>> with send/receive path checks that break some setups. As there's no 
>> proper
>> fix yet, the patch that caused the regression has been reverted.
>>
>> Tarballs: 
>> https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
>> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
>>
>> Shortlog:
>>
>> David Sterba (5):
>>        btrfs-progs: ci: explicitly request reiserfs support for 
>> btrfs-convert
>>        btrfs-progs: ci: switch to newer build environment
>>        Revert "Btrfs-progs: fix mount point detection due to partial 
>> prefix match"
>>        btrfs-progs: update CHANGES for v4.20.2
>>        Btrfs progs v4.20.2
>>
>> Nikolay Borisov (1):
>>        btrfs-progs: Use a single tab for 'leafsize (deprecated)' row
>>
