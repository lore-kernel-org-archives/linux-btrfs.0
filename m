Return-Path: <SRS0=y50c=C6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6909C4727D
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 23:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76D5B23A74
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 23:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W4Z1PufJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgIUXzG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 19:55:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgIUXzG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Sep 2020 19:55:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LNnKL0068417;
        Mon, 21 Sep 2020 23:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zHkYTeTs1W793b6ssiIhRP7FBi1Le2MgPTRO0WKrLr4=;
 b=W4Z1PufJSnXuBnr2qsX4IX80SkB4fzQ6auAOv4dVgQp0xPlFZGiFGhsTJLVDJ9df7j8k
 DZuoDLvHAkVp2axKC69EUBAkrXHxLmmbTCbAnrO4/WJTqcY1oRbteytU2yzud9HYotJQ
 h+fM5v+7Xq6oIPiLG5UTK4K4HyMzRNQM7gueroTLnXB8/RwrD+Rpud7/3YC1x84xMUxX
 /DjmDKb96y9mD/R3R7SFZRR9HtkB//3KiSKdhW1/Q9He4s2lnKdoRBTLl56pJrDCH5B7
 9Menf+9L+qPhypY4usGsKLQ2qcjGRksjPBvnDbdFY/yW+V0OX3B9CZuJ5m6n4PuOVdq9 ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33q5rg84m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Sep 2020 23:55:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LNpK6C188151;
        Mon, 21 Sep 2020 23:55:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33nuwxac35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 23:55:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08LNt19w015008;
        Mon, 21 Sep 2020 23:55:01 GMT
Received: from [192.168.1.102] (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 16:55:01 -0700
Subject: Re: [PATCH 2/2] btrfs: return error if we're unable to read device
 stats
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1600461724.git.josef@toxicpanda.com>
 <6f50f5be859468da38bd504c0f78a97dbcd0306d.1600461724.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <89f2e615-a7b8-3197-a4e4-205d52c9061b@oracle.com>
Date:   Tue, 22 Sep 2020 07:54:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <6f50f5be859468da38bd504c0f78a97dbcd0306d.1600461724.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210175
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 19/9/20 4:44 am, Josef Bacik wrote:
> I noticed when fixing device stats for seed devices that we simply threw
> away the return value from btrfs_search_slot().  This is because we may
> not have stat items, but we could very well get an error, and thus miss
> reporting the error up the chain.  Fix this by returning ret if it's an
> actual error, and then stop trying to init the rest of the devices stats
> and return the error up the chain.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>
