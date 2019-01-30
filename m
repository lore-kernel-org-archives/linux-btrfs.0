Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E8CC4151A
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 06:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD4E820989
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 06:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="osZu9nvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfA3GpS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:45:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfA3GpR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 01:45:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0U6ceC7064396
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=bRHXzfi7PtMPxZ4iac1dP/IQ8XUayPXfQkqvO47fPeA=;
 b=osZu9nvgx4hxDKvlEeJHG9L0dkcGWU+sPw+tZ1tZAxNkAGR/ETujk/tu6iBkH/xnkuFE
 GvAzn39gNDA8Ss+dBV6DuuyS3weJfIoV5Kc8ocn7r2EabqyDTUrkBWMSOlJcy0zCoRjT
 CAzYwftHlZgVIbHzkDUyeVBvuNkDCBKzN92ocknR+tLx6vFUFx51KUli4AhoVSEFobj0
 VAUSnfDFGnrAnszAbKhsJO2i+AwqZms74UU4nbxDmkVEXPCe0Le1C4LSFWrANS6rOOnQ
 ASt/oLSvwI2SU9cRn5ImMI/CqBDKx7so3t/lXXyhiXw7Shq5tNLdLJwaVrQeDJyezB+Z vQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2q8g6r8k6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:15 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0U6j9J0025452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:10 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0U6j9Ti019673
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:09 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jan 2019 22:45:09 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/3] btrfs: scrub: fix scrub_lock
Date:   Wed, 30 Jan 2019 14:44:59 +0800
Message-Id: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9151 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=475
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901300051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fixes the circular locking dependency warning as in patch 1/3,
and patch 2/3 adds lockdep_assert_held() to scrub_workers_get().
Patch 3/3 converts scrub_workers_refcnt into refcount_t.

Anand Jain (3):
  btrfs: scrub: fix circular locking dependency warning
  btrfs: scrub: add scrub_lock lockdep check in scrub_workers_get
  btrfs: scrub: convert scrub_workers_refcnt to refcount_t

 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c |  2 +-
 fs/btrfs/scrub.c   | 28 +++++++++++++++-------------
 3 files changed, 17 insertions(+), 15 deletions(-)

-- 
1.8.3.1

