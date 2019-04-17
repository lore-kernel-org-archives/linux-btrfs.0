Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15179C10F12
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 10:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5BE32064A
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 10:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cozMnI1W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfDQKYt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:24:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40108 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfDQKYt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 06:24:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HANeO2107366;
        Wed, 17 Apr 2019 10:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hRHqB8O36AHlxu4fldZy+eS3vxk28A0mCL2lOsx09Ww=;
 b=cozMnI1WSb52fb/5JjHELlzMVdK5rtxtJ2sOXtbtPE9Rv83Cdm1DKqzpP3tCkua9S84j
 vLqjVwP4/bBwgPmb3NvWpiPj99ZhnwTOOlvCtbunDYXrNGk2LMgSCcdKB8yD1dS+4JeY
 kuowgPixrnPoMVjkL8BQsidFtoMHkp9FXDrLYmqtTXWN8VAqlejT8lKk9wkJcjeY5zQo
 QQPq2qjgQn5crToPYbdbW09Kpd8Dx7Hw+Jv+yEgsmqUuloqjwM8+JDcO+eBvBwPHXFPS
 Bb1bituiugwCd3DKZdifu4yYZNyyOy8CGSZOtc5/ELLrjP3xtdwbu4JfdvR/emA32qmW JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2ru59da219-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 10:24:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HAOPDL165398;
        Wed, 17 Apr 2019 10:24:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rubq6uwgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 10:24:43 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HAOgAG013362;
        Wed, 17 Apr 2019 10:24:43 GMT
Received: from [192.168.1.119] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 03:24:42 -0700
Subject: Re: [PATCH 0/6] cleanup property and extended attribute set
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20190412080259.5192-1-anand.jain@oracle.com>
 <20190415190117.GA20156@twin.jikos.cz>
 <5e49b381-ef69-f9d9-c934-7122bbc5406b@oracle.com>
 <20190417093142.GC20156@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <5ac91c6b-36f9-e0cd-c1aa-0331e47f1ba4@oracle.com>
Date:   Wed, 17 Apr 2019 18:24:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190417093142.GC20156@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9229 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=831
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170074
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9229 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=839 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 17/4/19 5:31 PM, David Sterba wrote:
> On Tue, Apr 16, 2019 at 06:01:58AM +0800, Anand Jain wrote:
>>
>>
>> On 16/4/19 3:01 am, David Sterba wrote:
>>> On Fri, Apr 12, 2019 at 04:02:53PM +0800, Anand Jain wrote:
>>>> In an attempt to stream line the property and extended attribute set here
>>>> are the few cleanup patches.
>>>>
>>>>    1/6 to 3/6 are mostly non functional cleanups (except for the conversion
>>>>     to non static function in 3/6) and can be merged together.
>>>>    4/6 removes the readonly root check in btrfs_setxattr() more details in
>>>>     the change log.
>>>>    5/6 as now we have btrfs_setxattr() and btrfs_setxattr_trans() for the
>>>>     threads with transaction and without transaction respectively, so this
>>>>     patch uses them.
>>>>    6/6 as 5/6 as diverted the threads with transaction to btrfs_setxattr(),
>>>>     now btrfs_setxattr_trans() can drop the trans arg.
>>>>
>>>> Anand Jain (6):
>>>>     btrfs: rename btrfs_setxattr to btrfs_setxattr_trans
>>>>     btrfs: rename do_setxattr to btrfs_setxattr
>>>>     btrfs: declare btrfs_setxattr as a non static function
>>>>     btrfs: remove redundant readonly root check in btrfs_setxattr_trans
>>>>     btrfs: split thread with trans to use btrfs_setxattr
>>>>     btrfs: cleanup btrfs_setxattr_trans drop trans arg
>>>
>>> Looks good to me, thanks. The result is very close to what the previous
>>> patchset did. Patchset will go to for-next soon.
>>>
>>
>> Thanks. On top of these, I am writing patches to merge
>> start_transactions in btrfs_ioctl_setflags().
> 
> My current idea how to change btrfs_ioctl_setflags is like that (but I
> haven't prototyped it so it might not work):
> 
> - don't change binode->flags directly, but do all flag updates on a
>    temporary variable
> 
> - if a property needs to be changed, do validation first, then start
>    transaction and pass it to the property handler
 >
> - in the finalizing code, start a transaction unless it's been started
>    already, apply the iflags and end transaction

I almost have the same way, but not in the same change sequence.
Which should be fine.

> This means there are up to 4 starting points of transaction, but the
> property validation should never fail between start/end region. There
> are other potential failures due to ENOMEM or ENOSPC, but that's the
> general set of errors we can't avoid.
> 

My new docker build+test setup is giving me a little bit of
headache. I will send the patches for the review soon.

Thanks, Anand

