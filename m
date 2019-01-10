Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B564C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 06:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D356120879
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 06:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GziF2Neg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfAJGRl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 01:17:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45812 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfAJGRl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 01:17:41 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0A64RkV035495;
        Thu, 10 Jan 2019 06:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=W+5piE/qGpNAocnGLmE2ZswFszdazrUnScVip8J9JpI=;
 b=GziF2NegCwYbeJQwDd2N0r/v/aZ2UD0N/VEQ2UKWgb5tAF3WIesRSlzIFD0qcOs7MP1F
 5yeKOyxVk+fijXo1EBPFDGVA9vwoQeVKIDChS85dUaZdfC3N4SEdWBEA7iaaLPdBqn9x
 0xvPg5UEn6xLTGhFjbTCJkbJ/MO+w12ClXmH7/pD9ToaRnK1Ve8LjcR2G9NxNCzlZLhE
 qXwlefnzYxE2kJ/IjRoPYFxarr98onFlCIxpuNkqZWDK4cQeuE8HM9oadejeWqeKsfEx
 jsy/LJYCWq6JKg+QUx5ESzmkW2/Hu9yGKRHbuJxOBDy//5ZCga0/Z5Z4TaanxHxNWjPi uw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2ptj3e5hn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jan 2019 06:17:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0A6HZHU021021
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jan 2019 06:17:35 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0A6HZiV008673;
        Thu, 10 Jan 2019 06:17:35 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jan 2019 22:17:35 -0800
Subject: Re: [PATCH 1/2] fstests: btrfs: Make seed device test cases into
 their own group
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20190110061415.32045-1-wqu@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <bf4b36e4-3ca3-86c9-ff6a-5062b1a13e8b@oracle.com>
Date:   Thu, 10 Jan 2019 14:17:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190110061415.32045-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9131 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901100050
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/10/2019 02:14 PM, Qu Wenruo wrote:
> btrfs/16[123] are all seed device related test cases, make them into
> 'seed' group.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

> ---
>   tests/btrfs/group | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index b78ed37fd9f1..04c0254aa4bf 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -163,9 +163,9 @@
>   158 auto quick raid scrub
>   159 auto quick punch log
>   160 auto quick
> -161 auto quick volume
> -162 auto quick volume
> -163 auto quick volume
> +161 auto quick volume seed
> +162 auto quick volume seed
> +163 auto quick volume seed
>   164 auto quick volume
>   165 auto quick subvol
>   166 auto quick qgroup
> 
