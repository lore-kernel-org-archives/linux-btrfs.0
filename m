Return-Path: <SRS0=myd1=DV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019B3C433E7
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Oct 2020 02:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978E621D7F
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Oct 2020 02:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BYObUBCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgJNCrI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 22:47:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgJNCrI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Oct 2020 22:47:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09E2j804024158;
        Wed, 14 Oct 2020 02:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=uVnsyxcHGW0c/HU+BRstfT07Ja6Su+mQgjhsGkUTUYw=;
 b=BYObUBCz2ZC5XBOK9Kn2mqpfU8ccLPexU+SvLNWdEO5uoKyKKmu9JP0TlV5oUbRqgsjO
 6n8EzCCtghMWPEDWkTSvjwQNQYEGSZuJxw0xQMo/F2FGSzm9RK2CXkleam6JaeqTNtDA
 jy2Nvu/cQpRfqRk7SczZRjzZlsQsDktG1iAqIV3lwXyvLouPBDlU1/MI0n1y4gmffnKp
 C129NtWty9jlyz7r2eQCLSEGdIZFiQT+9X76Cl+cLr0xAM1g60iSH3wbfV1VvZcjefEh
 n9L8l7Um30xCD+HgnUu4GukBaN319FvHc21NWoipZemqlVtPKg+YegQYti4yaV1J1Wtg SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wkn6w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Oct 2020 02:47:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09E2ZWwv120436;
        Wed, 14 Oct 2020 02:45:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 344by31yp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 02:44:59 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09E2iwBN009715;
        Wed, 14 Oct 2020 02:44:58 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 19:44:57 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, nborisov@suse.com, wqu@suse.com,
        jthumshirn@suse.de, josef@toxicpanda.com, dsterba@suse.com,
        anand.jain@oracle.com
Subject: [PATCH stable-5.4] backport enospc issues during balance
Date:   Wed, 14 Oct 2020 10:44:45 +0800
Message-Id: <cover.1602243894.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010140018
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Patch 1 is a preparatory patch to reduce conflicts. Patch 2 fixes
balance failure due to ENOSPC in btrfs/156 on arm64 systems with
pagesize=64k. Minor conflicts in fs/btrfs/block-group.c are resolved.
Thanks.

Josef Bacik (2):
  btrfs: don't pass system_chunk into can_overcommit
  btrfs: take overcommit into account in inc_block_group_ro

 fs/btrfs/block-group.c | 38 ++++++++++++++++++++++----------
 fs/btrfs/space-info.c  | 50 +++++++++++++++++-------------------------
 fs/btrfs/space-info.h  |  3 +++
 3 files changed, 49 insertions(+), 42 deletions(-)

-- 
2.18.4

