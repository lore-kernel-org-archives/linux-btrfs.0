Return-Path: <SRS0=dUzf=XF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054A4C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 07:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB7221479
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 07:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VV/jEztM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfIJH6s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 03:58:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbfIJH6s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Sep 2019 03:58:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8A7rux8000773;
        Tue, 10 Sep 2019 07:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DZQnOqDUjlInUceOxoauZBHaBtZGm7evSIVyT5FfYv0=;
 b=VV/jEztMBgEDii6fzqc8TUxXIbDQImQ5iaBNoeLqiOHNTwTsJ4OWG+K3Fv+MiK7Mui6C
 bGcjGO9A9CZJt+xOcro7pUB3nI+5nnaC7NVr5U2z9IJPKRpiijVtpSbHaMxD0tZzABQ6
 +wd9dsszCRi6ebVhQ1Q4ZRyJdKiC/Q4lZ9vpOkbr8cs5JlAlaTJiD5v8RzJR37dLbm9h
 vmRMR2P7d2c7a4itYXAq1LEuBgHBdJ/VT4MQBhaArUZe60JYtR7ZCK4BCvP44I5Qq2L9
 WsyzzUW91bgmWFc8zj6x4fePLebstH06zXEwLdIO56upu/HTq5FyUQeSde9fCcr62kuB LA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uw1jk9fb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 07:58:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8A7w218036676;
        Tue, 10 Sep 2019 07:58:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uwpjvgcf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 07:58:44 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8A7whSI003048;
        Tue, 10 Sep 2019 07:58:43 GMT
Received: from [10.190.130.61] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 00:58:43 -0700
Subject: Re: [PATCH 2/3] btrfs: ctree: Reduce one indent level for
 btrfs_search_old_slot()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190910074019.23158-1-wqu@suse.com>
 <20190910074019.23158-3-wqu@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <d2033bbd-9e2e-b08a-4968-b82a602682fd@oracle.com>
Date:   Tue, 10 Sep 2019 15:58:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190910074019.23158-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9375 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=894
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909100079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9375 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=962 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909100078
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks.
