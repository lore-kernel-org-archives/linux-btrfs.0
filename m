Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB167C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 14:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A64DA206BA
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 14:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="boOPy3uN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfCKOi2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:38:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfCKOi2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 10:38:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2BEY0Ei168227;
        Mon, 11 Mar 2019 14:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=RY2ztpgFpxsLzOKplLW6SIlO3UrRK4+6XsuNDEqvG7Q=;
 b=boOPy3uNblwdPRE/HOhXHED4ynIWFLMcWaJ8RCJ0ngBTw++2tGMXfWOaqurov5DWoZGo
 9CKREtLOqa/LgvNK3letxtnDd0qNzKGGdA3OryMTdwmWR7Q7rpcI7pGCp85o4/Osb54K
 aHL1h+Oc+0cqnrs/5vc/+55DLqDadWSsq/q11deAru9TtErWH3pQFLnOu7Odh+1Z6tY2
 EK6YXGH7w1/mW7MITwF4RZH8BYiA1uvMzqKeg6n2GquwBXJfY4PN101BqW+1Q0YO7XK2
 00TOjaH6oQnfyFPovXH6XeJcIddvYiAJxHSQh8/ZeMcfQU22I5zRbuQTOcJWBaEfIpZl yA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r44wtxuaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:38:26 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2BEcPgc027207
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:38:25 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2BEcPbp031938;
        Mon, 11 Mar 2019 14:38:25 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 07:38:24 -0700
Subject: Re: confusing behavior when supers mismatch
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <10ca6f3a-d6df-96ad-2136-2827424d6e10@oracle.com>
Date:   Mon, 11 Mar 2019 22:38:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9192 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110106
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/11/19 7:09 AM, Chris Murphy wrote:
> In the case where superblock 0 at 65536 is valid but stale (older than
> the others):
> 
> 1. btrfs check doesn't complain, the stale super is used for the check

> 2. when mounting, super 0 is used, no complaints at mount time, fairly
> quickly the newer supers are overwritten

  More or less all these were hardened in the patchset [1] which is in
  the mailing-list.

    [PATCH v4 0/7] Superblock read and verify cleanups

Thanks, Anand

> Is this expected? In particular, in lieu of `btrfs rescue super`
> behavior which considers super 0 a bad super, and offers to fix it
> from the newer ones, and when I answer y, it replaces super 0 with
> newer information from the other supers.
> 
> I think the `btrfs rescue` behavior is correct. I would expect that
> all the supers are read at mount time, and if there's discrepancy that
> either there's code to suspiciously sanity check the latest roots in
> the newest super, or it flat out fails to mount. Mounting based on
> stale super data seems risky doesn't it?
> 
