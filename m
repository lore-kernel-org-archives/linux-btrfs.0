Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057A8C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 10:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE83E2147C
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 10:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D2qynGyG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfBGKg7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 05:36:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48308 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfBGKg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 05:36:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x17ATMaY177046;
        Thu, 7 Feb 2019 10:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=984NFvIaZAcXAL400g3Kvn4p7oAuet35geNfWGpGTCQ=;
 b=D2qynGyGzIJTTd+t2oIA96LlaPLvmSB47kauK9097RrmmDd7K9/ptnq5wlCwWTdXscxh
 lZ67MEI3XB7wNR5eZZXVMexmFxZskA9xsUEqVQ+KuymkTR5NPgXw9Z71T1VdL+YbiCS9
 oL6CaRd06iHfafmeCgn+VgPiz5x/xJ1uMW3xDyAmZyfQl78mvSTaJCVKZUP4chPZ0zKs
 kTUBw5zUIdyZ3y0RIilBdze8ZL03fg0cQeNAGb1CsdXbBQVS0rcArlNt2HLrpy8qjVMI
 M54T4DOOL/huN77yeisJENLJ49NLOusDtCOccDMtpXU4CrT7bmz+E5Fwl4+iuUDkZ4iR hw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qd9arp5rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Feb 2019 10:36:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x17Aaua7013473
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Feb 2019 10:36:56 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x17AatYL018008;
        Thu, 7 Feb 2019 10:36:55 GMT
Received: from kadam (/41.202.241.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 02:36:55 -0800
Date:   Thu, 7 Feb 2019 13:36:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dennis@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: change set_level() to bound the level passed in
Message-ID: <20190207103647.GA15902@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9159 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=774 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902070083
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello Dennis Zhou,

The patch a67dc67a2cb8: "btrfs: change set_level() to bound the level
passed in" from Jan 28, 2019, leads to the following static checker
warning:

	fs/btrfs/compression.c:1576 btrfs_compress_str2level()
	error: uninitialized symbol 'level'.

fs/btrfs/compression.c
    1566 unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
    1567 {
    1568 	unsigned int level;
    1569 	int ret;
    1570 
    1571 	if (!type)
    1572 		return 0;
    1573 
    1574 	if (str[0] == ':') {
    1575 		ret = kstrtouint(str + 1, 10, &level);
--> 1576 		if (ret)
    1577 			level = 0;

I feel like if the user gives bad input then we should just return an
error code instead of picking a level.

    1578 	}

level is not initialized if the first character is not ':'.

    1579 
    1580 	level = btrfs_compress_op[type]->set_level(level);
    1581 
    1582 	return level;
    1583 }

regards,
dan carpenter
