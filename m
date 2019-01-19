Return-Path: <SRS0=mgXs=P3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95219C61CE8
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 06:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F70E2086D
	for <linux-btrfs@archiver.kernel.org>; Sat, 19 Jan 2019 06:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kNZ6nWhT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfASGy2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 19 Jan 2019 01:54:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbfASGy1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Jan 2019 01:54:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0J6sJ39181943;
        Sat, 19 Jan 2019 06:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dbe0jnGQQH2lb/Lwn5KQtELB7F/dbJvRMoeLGzLGnTo=;
 b=kNZ6nWhTLNm1HSxMGvopIc9paWF321GCMY1bjqMG08fZYHqMeIlg+s7iGLBc52s+QBNg
 ZR1DY6EmXH+Qi27hI9EXJaI0snNkIs6w/B4tYSxoJ4MGAJekgK4QWr0degiwealqx8L0
 DbTKn/VAVaK3kLDQeub0vGLR6Q62fqNAl+BuozK4/U+Rh08TqJ+UzS3nk5OMav+A/zGL
 QkPK7lXTfbJlP4UcZn1qM+sDEh+5z/dSNJCuuBZ33L45SjIA9eaJIqVKHOhujCGMW0s2
 azMrMO5e7d/+K5pAXxcfEnwd9ZNXKd41jCZntRgAABu/dG/ZJEFvqNBvPYROL2lFcHD7 DA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2q3uau8bf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jan 2019 06:54:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0J6sNQu030533
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jan 2019 06:54:23 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0J6sMVx013471;
        Sat, 19 Jan 2019 06:54:22 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jan 2019 22:54:22 -0800
Subject: Re: [PATCH 0/6] btrfs: find_device cleanups
To:     dsterba@suse.cz
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
 <20190118173330.GD2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <5a9b2fef-3598-3c46-6060-606bbc13396d@oracle.com>
Date:   Sat, 19 Jan 2019 14:54:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190118173330.GD2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9140 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=617
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901190056
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/19/2019 01:33 AM, David Sterba wrote:
> On Thu, Jan 17, 2019 at 11:32:27PM +0800, Anand Jain wrote:
>> find_device and its helper functions are as below
>>
>>   btrfs_find_device_by_devspec()
>>   btrfs_find_device_missing_or_by_path()
>>   btrfs_find_device_by_path()
>>   btrfs_find_device()
>>   find_device()
>>
>> Its quite confusing and too fragmented.
>>
>> In this patch-set..
>>   1/6 and 2/6 -- btrfs_find_device_missing_or_by_path() is collapsed into
>>   btrfs_find_device_by_devspec() and cleanup the surviving function.
>>
>>   3/6 -- rename btrfs_find_device_by_path() to find_device_by_superblock().
>>
>>   4/6 and 5/6 -- collapses find_device() into btrfs_find_device().
>>
>>   6/6 refactors btrfs_find_device() to return standard error code.
>>
>> Resulting in..
>>
>> btrfs_find_device():
>>   Mainly used to get struct btrfs_device internally for a given devid
>>   and or uuid and also helper function for btrfs_find_device_by_devspec().
>>
>> btrfs_find_device_by_devspec() and a helper function find_device_by_superblock():
>>   Is mainly to retrieve the struct btrfs_device of a userland given device_path.
>>
>> Anand Jain (6):
>>    btrfs: merge btrfs_find_device_missing_or_by_path() into parent
>>    btrfs: cleanup btrfs_find_device_by_devspec()
>>    btrfs: rename btrfs_find_device_by_path()
>>    btrfs: refactor btrfs_find_device() take fs_devices as argument
>>    btrfs: merge btrfs_find_device() and find_device()
>>    btrfs: refactor btrfs_find_device() return error code
> 
> 1,2,4, applied,

  Thanks

> please update 5 and resend. Thanks.

  comments were fixed and v2 is in the ML.
