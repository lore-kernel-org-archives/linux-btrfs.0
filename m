Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469BDC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD3820672
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N6itOEf2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DD3820672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbeKZUAp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:00:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbeKZUAp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 15:00:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAQ94SVr153257
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=b2epHm3oOi1sDvqdZwvgvnud+sASPdd15tCgMXzXghE=;
 b=N6itOEf2n7bejDct0DZrQ8oYNrh11g/ay4GyZqk6zatFymaKkmIMXgyN3cZZw00LVZnw
 mTqF/fyPZHtG8bXq/2ziJ/6MTQowZJ5aVY5Pfc6XPZXUJrfTyg395m/R9ds4L6apJ9pi
 Q3LspRK3Tspb/xzd1k2pj1G93XXQbHcVO/4J/E8Ftyq2JKfvEOJeqvdWA8J+2mzl+D2B
 2naArrrpazYrrKddg8xtJRCKoBLzpKiO+f/+m+eXvt5J7ug2lGxxxBt+IU0cXsgkNI7p
 lH6GeCRomG/Dvfv0SxLoAS9w+8MiP4/aICeRs/XbMbjn+uLSwCO85zup3r4EnGAW1pE4 pQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nxx2tve23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:17 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAQ97GrQ021075
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:16 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAQ97GY9021054
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:16 GMT
Received: from tpasj.sg.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Nov 2018 01:07:15 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: scrub: fix scrub_lock
Date:   Mon, 26 Nov 2018 17:07:06 +0800
Message-Id: <1543223228-28232-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9088 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=479
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811260085
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Anand Jain (2):
  btrfs: scrub: maintain the unlock order in scrub thread
  btrfs: scrub: fix circular locking dependency warning

 fs/btrfs/scrub.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
1.8.3.1

