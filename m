Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC9FC282DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1962183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LgXcasDU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfDTLvL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:51:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50848 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfDTLvL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:51:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmhGp049325
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=4pDi8R5fA78e30QZFkswyJaWR4xWmkGytlyX6p4JQ8U=;
 b=LgXcasDUDET6XJ/ynQmVgiHkcHRt2e4CmOH+XSos13XBN9QMu0gjjLOD1LEIuEH1TBCK
 SEjwDre6X4Ai4TTISrPprgIYllDZoyIno8oiJjU374Fo0SD44KA+PQC/HySKDpeRMgOZ
 KDyvWQeVpC8MsT4NYWwwUH/91n8OcSNGG20Jij/oHVkVl08q8O+Y7ajIEtRKhwRcM1XH
 wQP31c71egmio6d6rm2q8S+yNhVArBcy6TE36Eq9G38GX00BmgVMj/737dwvTKQP1aoj
 H/40nBnJ1WtJ6NCht/eVUJFkS1eUVaV0YdlHlt4eMq0q8fhFCfqr3pzgYeQNQnQ6/VK8 lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2ryrxch2ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:51:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmcbe003548
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2rysf8vqh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:09 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3KBn8PU022320
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:08 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:08 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 00/10] cleanup btrfs_ioctl_setflags and btrfs_set_prop
Date:   Sat, 20 Apr 2019 19:48:50 +0800
Message-Id: <20190420114900.15472-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=481
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=511 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A set of pathes to clean up btrfs_ioctl_setflags(), btrfs_set_prop_trans()
and btrfs_set_prop(). So as to avoidi duplicate code in
btrfs_ioctl_setflags() and killing of btrfs_set_prop_trans().

Anand Jain (10):
  btrfs: refactor btrfs_set_props to validate externally
  btrfs: export btrfs_set_prop
  btrfs: start transaction in btrfs_ioctl_setflags()
  btrfs: drop useless inode i_flags copy and restore
  btrfs: make a local copy of btrfs_inode flags before update
  btrfs: drop old_fsflags in btrfs_ioctl_setflags
  btrfs: drop local copy of inode i_mode
  btrfs: start transaction in xattr_handler_set_prop
  btrfs: delete unused function btrfs_set_prop_trans
  btrfs: btrfs_set_prop trans is never null

 fs/btrfs/ioctl.c | 111 ++++++++++++++++++++++-------------------------
 fs/btrfs/props.c |  56 ++++++++++--------------
 fs/btrfs/props.h |   6 ++-
 fs/btrfs/xattr.c |  26 ++++++++++-
 4 files changed, 105 insertions(+), 94 deletions(-)

-- 
2.20.1 (Apple Git-117)

