Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1FDC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 07:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE67207E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 07:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ozHuDrLB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfBVHAh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:00:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47824 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfBVHAh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 02:00:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1M6xt5s182682;
        Fri, 22 Feb 2019 07:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=8F3kJX6KHTTXtYc5qcrnAGMEcLco0IjhjhYKTNiLZfY=;
 b=ozHuDrLBnqVBycKVllzKUSnDNmyQbn4FBaVLnG0yPmfXElHUy4bZVcIR/JF0r/ioxj56
 b9gaZCLEbaDWJMFZCc7/mJWw/5M78vrq+f+pMybGU25ZFmGcDZrAsMyCBzKMxTwgxJ/y
 zyrv6ukz5UignMksMll4k1YmOFcy4QgSwUe73RDySEBYTRsnIpkyuTycwzIJgA9oycEI
 Bop6/NpQgyEKQA7gYNvNRV3/N7hgQADcbH0pXJY3yj2yjGirAsM9FigZRzK/evxJtfmf
 6Rtc5mlbPNixgwmbnUb/n96p7+TR3KNVAs3xI2ROdvD81Xu9XaTX35ZRgJR8dcmED6yf 9w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qp81emq5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 07:00:31 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1M70UIL020157
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 07:00:30 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1M70T6F014628;
        Fri, 22 Feb 2019 07:00:29 GMT
Received: from kadam (/197.157.0.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 23:00:29 -0800
Date:   Fri, 22 Feb 2019 10:00:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix possible NULL pointer dereference in btrfs
 selftest
Message-ID: <20190222070022.GE1711@kadam>
References: <20190222005350.7535-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222005350.7535-1-wqu@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9174 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=676 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220048
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm sorry, I feel bad for passing this work on to you when you didn't
introduce the problems at all.

I think you're doing to the right thing to change it all to error
pointers, and most of callers expect that but there are a couple that
need to be changed:  btrfs_test_qgroups() and run_test().

regards,
dan carpenter


