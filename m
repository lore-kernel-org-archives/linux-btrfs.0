Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EC2C65BAE
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 01:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED50D2082F
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 01:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XOnDDLXW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED50D2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbeK3MNo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 07:13:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbeK3MNn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 07:13:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAU0suje183014;
        Fri, 30 Nov 2018 01:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=UggRhIL76YWk0Wqz1qtk9juemuNOayeiWy9EvV5+PhY=;
 b=XOnDDLXWt5BxiYGoXmahYbR2ZujEdqUj3z86l7ORFYt7YBNocEXkv+38Ql8h48GxgAcG
 oPxcgXCLGkjk/hiwJUAZAFQeRmfeURURVi4uxNWg+FmOZgputOUp4JofRO6LowFCdx1z
 sYJm2Q14TAvg7x2903EiN/nPmKiCGxF06Qj6dE57G/axXhjHiFcbVGE+4J/yVNUP71tB
 1SVifMpeX1qxXkua3HdJj5LY5c3I1R3BQcqkSxlTOpPWm3hvLsF19+ks2DEBR80ceE2t
 h4q6pNXiaOpW1NtUK8EP2aLfh5VJmkB9yihGGSO0+rSK0CrENNpffv2/G4TrVjoXbK2E Aw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2p2jf0jp0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Nov 2018 01:06:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAU169lJ028584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Nov 2018 01:06:09 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAU168WF021467;
        Fri, 30 Nov 2018 01:06:08 GMT
Received: from [192.168.0.120] (/202.156.140.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 17:06:08 -0800
Subject: Re: [PATCH 2/2] btrfs: scrub: fix circular locking dependency warning
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1543223228-28232-1-git-send-email-anand.jain@oracle.com>
 <1543223228-28232-3-git-send-email-anand.jain@oracle.com>
 <ed04b1e5-b187-7ea9-3f8d-0a14f1143232@suse.com>
 <49b4a708-0d99-fb01-23ff-3463ddd4315f@oracle.com>
 <20181129143133.GA2842@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <fdb7bc42-48b6-8c1c-486a-abda8900b3e6@oracle.com>
Date:   Fri, 30 Nov 2018 09:05:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181129143133.GA2842@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9092 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811300005
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/29/2018 10:31 PM, David Sterba wrote:
> On Wed, Nov 28, 2018 at 04:47:27PM +0800, Anand Jain wrote:
>>> 2. scrub_workers_refcnt must eventually be converted to refcount_t type
>>
>>    ok. Added in v2 patch set.
> 
> No such thing is in v2 and this would actually get rid of the need to
> hold scrub_lock in scrub_workers_put. Which in turn can be moved out of
> the locked section in btrfs_scrub_dev and the warning is gone. Problem
> solved.
> 

  Right. When testing btrfs/011 it got hung and bisect pointed to the
  patch which was converting int to refcount_t.
  I had difficulties to get the logs out of the test machines, so I
  had to drop the patch.
  Will send refcount_t patch, patch 1/3 and possibly scrub concurrency
  patch (make scrub independent of the btrfs-progs locks) patches all
  together.

Thanks, Anand
