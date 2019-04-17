Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D7AC282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 10:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978F121773
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 10:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UivitDJp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbfDQKku (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:40:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57164 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbfDQKku (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 06:40:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HAcPSs118663;
        Wed, 17 Apr 2019 10:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=EZvXJo18wVSkqEDXiyNziogThu7zXW0ljmLkSCPVBns=;
 b=UivitDJpRKkUct0u7OPAcau/IzfxB3y5MtNGevtdHxXwIaVtGszcr81lTldilNGIbSjd
 spYiHQQS8mijzc1nw5w1m+h0C6pwlKemBlp9piTTQMThRAoPgtNgr52DAdGZ+Dun8I68
 ZzTxMKGLyY/OF2kaCMIIDw36iGfGhFiThoxpWLPgFyVXpbnSTC4WHaeNmzuYVfjyb5GT
 JhOuH3LLlxq2rGZJUM/wuveHdiV+1XVkJP8XaLy7m5cZJl8d2BFyQuAhyVdNvu8XyXZs
 h9VkdDJvMHR8EVld2GMFQSg9Mzvowzy9hNZQyhyM+8QGIinZ7mOX7ZOS7ypdLXct1G+0 Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2ru59da42p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 10:40:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HAd0ic144416;
        Wed, 17 Apr 2019 10:40:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ru4vtqvhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 10:40:45 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HAeiA2008322;
        Wed, 17 Apr 2019 10:40:45 GMT
Received: from [192.168.1.119] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 03:40:44 -0700
Subject: Re: [PATCH 0/6] cleanup property and extended attribute set
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20190412080259.5192-1-anand.jain@oracle.com>
 <20190415190117.GA20156@twin.jikos.cz>
 <5e49b381-ef69-f9d9-c934-7122bbc5406b@oracle.com>
 <20190417093142.GC20156@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <cd594b42-dba7-3ea0-5317-4e1dbb23d9f1@oracle.com>
Date:   Wed, 17 Apr 2019 18:40:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190417093142.GC20156@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9229 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170075
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9229 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170076
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

  In btrfs_ioctl_setflags() we don't need the validate() at all, as the
  the property strings are hard coded with in the kernel or already
  verified during the mount -o option (fs_info->compress_type).
  So only place where we need the validate is
  btrfs_xattr_handler_set_prop().

Thanks, Anand

> - in the finalizing code, start a transaction unless it's been started
>    already, apply the iflags and end transaction
> 
> This means there are up to 4 starting points of transaction, but the
> property validation should never fail between start/end region. There
> are other potential failures due to ENOMEM or ENOSPC, but that's the
> general set of errors we can't avoid.
> 
