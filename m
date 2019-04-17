Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936DAC282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56EF620674
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ywcqeoUV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfDQPhT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 11:37:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731472AbfDQPhT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 11:37:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFJ0Q5184584;
        Wed, 17 Apr 2019 15:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=RYYmY75JHgEXYlf0iBKQMsU0I5qFYi8nB6whpuMbGTs=;
 b=ywcqeoUVMjnJIELmMU422FI/+Xeo+6GI+QyskgV082+NVpnnzLTrdzMnoSLyyfgGotUh
 voEfIjJzlSTHVxFMJ7l/lmVCJWIoN6EVnPOG2rKQMfAY1esytyCJI/u0pjxcpEHnxRRE
 zrRD95393k/MpdAcbvJmcPKZppUA4E8uy35HVEcV6HY5N/APQMzqNMzb3VBNCBq4DHFu
 j83XzK6m9UaGkope966L2RJTbO20UJP5XYR+UQLsNCgqYDRUbbm7ZZDWVGDPPz5jgKkA
 l/u8+dvSZQ1fPcFJ9laywrekHRpzJZc9LE0nxrBJeZFeQLLaAMls61e/GZDffhr4Fs2w LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2rusnf1r0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:37:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFb4xt121682;
        Wed, 17 Apr 2019 15:37:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ru4vtvhkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:37:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HFbEka002563;
        Wed, 17 Apr 2019 15:37:14 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 08:37:13 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [PATCH 0/2 RFC] fix duplicate code in btrfs_ioctl_setflags
Date:   Wed, 17 Apr 2019 23:37:04 +0800
Message-Id: <20190417153706.29942-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=781
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=815 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170104
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are two reasons why I am marking this as RFC as of now.
I don't see the preparatory patches yet, I wonder if this should
be based on for-next-20190415? I couldn't reproduce the issue,
which theoretically should exist as in the patch 2/2.

Some more cleanups related to the inode flags such as [1]
[1]
(don't change binode->flags directly, but do all flag updates on a
 temporary variable)
is wip.
