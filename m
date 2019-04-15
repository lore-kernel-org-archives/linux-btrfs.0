Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ADEC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 22:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B69B206BA
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 22:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Js86mCF4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfDOWCM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 18:02:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44648 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfDOWCL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 18:02:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3FLsGdT145809;
        Mon, 15 Apr 2019 22:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=aRMP/Xw4Yb7p2Nv3mNKHLLoIClA/B1ttFYFgSKdy8Ro=;
 b=Js86mCF4YYaEOVp95JGJ4FkSCY1opIympHubZBjq7sOp4z6n4/alBOrAg4pISLi1usRA
 SoccpT1ftic6vK9xikrrU4q6IeUAWfHXdam0umNuZDjpbfMiAUFeiMq/a8WHID4RZtBU
 RzXyMiyAg5eqSSAOZRjkIwUIdbFuFyeabfJofRCG3bhAhBMC3W+ChKmbRypuN2cSU9D1
 KtrU7aAa3MFkEOEO3jZHzEHs2Udb5K/E0Ro2fnKwFN/ntOl/wKx+vlREQqjhamB3ssPT
 hOMOqV+r/1SZTYgAr7C+wCU4Pk9fLLkqD1BUSuRnN3laGQkX6c3Wc/fBpwGRWvpn5wHE og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2ru59d1c3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Apr 2019 22:02:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3FM0tgs166234;
        Mon, 15 Apr 2019 22:02:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ru4vsutm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Apr 2019 22:02:05 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3FM24G5031688;
        Mon, 15 Apr 2019 22:02:05 GMT
Received: from [192.168.1.119] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Apr 2019 15:02:04 -0700
Subject: Re: [PATCH 0/6] cleanup property and extended attribute set
To:     dsterba@suse.cz
References: <20190412080259.5192-1-anand.jain@oracle.com>
 <20190415190117.GA20156@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <5e49b381-ef69-f9d9-c934-7122bbc5406b@oracle.com>
Date:   Tue, 16 Apr 2019 06:01:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415190117.GA20156@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9228 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=930
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904150149
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9228 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=938 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904150149
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 16/4/19 3:01 am, David Sterba wrote:
> On Fri, Apr 12, 2019 at 04:02:53PM +0800, Anand Jain wrote:
>> In an attempt to stream line the property and extended attribute set here
>> are the few cleanup patches.
>>
>>   1/6 to 3/6 are mostly non functional cleanups (except for the conversion
>>    to non static function in 3/6) and can be merged together.
>>   4/6 removes the readonly root check in btrfs_setxattr() more details in
>>    the change log.
>>   5/6 as now we have btrfs_setxattr() and btrfs_setxattr_trans() for the
>>    threads with transaction and without transaction respectively, so this
>>    patch uses them.
>>   6/6 as 5/6 as diverted the threads with transaction to btrfs_setxattr(),
>>    now btrfs_setxattr_trans() can drop the trans arg.
>>
>> Anand Jain (6):
>>    btrfs: rename btrfs_setxattr to btrfs_setxattr_trans
>>    btrfs: rename do_setxattr to btrfs_setxattr
>>    btrfs: declare btrfs_setxattr as a non static function
>>    btrfs: remove redundant readonly root check in btrfs_setxattr_trans
>>    btrfs: split thread with trans to use btrfs_setxattr
>>    btrfs: cleanup btrfs_setxattr_trans drop trans arg
> 
> Looks good to me, thanks. The result is very close to what the previous
> patchset did. Patchset will go to for-next soon.
> 

Thanks. On top of these, I am writing patches to merge 
start_transactions in btrfs_ioctl_setflags().

-Anand
