Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75E4C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 22:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96300218D9
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 22:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3M6thdmr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfBFWN5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 17:13:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfBFWN5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 17:13:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x16MDo5t033747;
        Wed, 6 Feb 2019 22:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=9Xl0kkqNSv+LMdXuc/VZaK91Bbg7chOQEkooTfYoWV0=;
 b=3M6thdmru/YXmgfdYuwPyup9SD9WHJKfD3ynEOgk/lAccAhSieya21OsogRjlcV+PkOx
 GquP7C0xKU3cVV/pzbPKONvlhV1XwI2+7oXqHpmeFPlndVciXhjcpoE8MmF18RG3SiXF
 sAFnK2AAX5Qh+YoJNP267BjHyKohPRhT/Kc2mZFWNuu/GdQcHFjlnZYuLgfPOEIarGLx
 i24iTTZc6741ARVFMOMyyO+Ipy1/x6K8GhyU0sOtLEDJr3eIKvIHUJxOCf+ze7fOydcR
 YvF+vBR13pHub9AtplXvxZ+IP78Lo8ynx/ORH0RIL6SseOq0ggtf8Oukree1Ct1s9aWC 2g== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qd98nbt4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Feb 2019 22:13:50 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x16MDlvs007707
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Feb 2019 22:13:47 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x16MDlTJ025035;
        Wed, 6 Feb 2019 22:13:47 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Feb 2019 14:13:47 -0800
Subject: Re: [PATCH v14] Add cli and ioctl to forget scanned device(s)
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
 <20190206153326.GD2900@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1b208c60-c207-67b7-c59d-26bfa46ac991@oracle.com>
Date:   Thu, 7 Feb 2019 06:13:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190206153326.GD2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9159 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902060167
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/6/19 11:33 PM, David Sterba wrote:
> On Fri, Jan 04, 2019 at 01:31:51PM +0800, Anand Jain wrote:
>> Adds cli and ioctl to forget a scanned device or forget all stale
>> devices in the kernel.
>>
>> Anand Jain (2):
>>    btrfs: refactor btrfs_free_stale_devices() to get return value
>>    btrfs: introduce feature to forget a btrfs device
> 
> The 2nd patch has been added to misc-next too, I've updated the
> changelog a bit.

Thanks.

> The usecase here is quite small so I don't think we've
> missed something crucial on the kernel side. 


> The userspace part can
> provide some convenience shortcuts like --forget-all 

The --forget is already equivalent to --forget-all. For example..

# btrfs dev scan /dev/sdb
Scanning for Btrfs filesystems in '/dev/sdb'
# btrfs dev scan --forget /dev/sdb
# btrfs dev scan
Scanning for Btrfs filesystems
# btrfs dev scan --forget
# echo $?
0
# btrfs dev scan --forget /dev/sdb
ERROR: Can't forget '/dev/sdb': No such file or directory
# echo $?
1
#

 > or specifying by
 > filesystem id where the translation would happen internally, but the
 > ioctl would cover that. Thanks.

Looks like that seeks the complete enhancement to scan cli.

IMO we could add..

  #btrfs dev scan --show

  For which looks like we need to enhance existing ioctl
  BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO so that it works
  through btrfs-control.
  Which means 'btrfs fi show' can also show the scanned devices from
  the kernel, probably we should just add flags to the output to indicate
  if the fsid-device is mounted.

  OR a wrapper around the sysfs fs-dev tree implementation will suffice
  as well.

further, (fsid translation happens internally)

  #btrfs dev scan <fsid>
  #btrfs dev scan --forget <fsid>

In general, agree use case is limited.

Thanks, Anand
