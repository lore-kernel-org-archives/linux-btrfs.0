Return-Path: <SRS0=1T4y=43=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174DBC3F2C6
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 04:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4CB2467D
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 04:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xBAv9dSU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgCJEW3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 00:22:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgCJEW3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Mar 2020 00:22:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02A4MRbu183377;
        Tue, 10 Mar 2020 04:22:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=17pPcwbPO5mI7aM13d8yqxLx9Q4s1zy1qqA/BXrB8Jg=;
 b=xBAv9dSUW/Knh9uh0C2afo7ZviI+H/JEym+kF4lLl+9oi9kGB4sH07gWRF/Qo7N5LGY5
 Aq6jCBJOfgCyHJamLCnAmw3UGY/hkiW7GZpn2bwLFUOXnqitlXf0YD2zciTylrWXu+uW
 4Rg9vsskuwSzzwypwjPGo20b1egyCnFTANilq0mE4Z34B8mmcYqh3QJiLw0idvDUEKJt
 Fj9l/KWAuSzlpOb1mt1I2vJN7JhDEU2ny4PVJ3Lgbxf8h1uoLr+t/UCjkJjb1ODACmTN
 D88a1dBpnv23zTks1q3H+9QK2AJilYwZcLVhQtpCY7Z23q1qofEvf2W4k+NM44WPzcDm qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ym3jqjs3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 04:22:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02A4HTAv156741;
        Tue, 10 Mar 2020 04:20:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ymndh5r6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 04:20:21 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02A4KKnO032201;
        Tue, 10 Mar 2020 04:20:21 GMT
Received: from tp.localdomain (/39.109.145.141) by default (Oracle Beehive
 Gateway v4.0) with ESMTP ; Mon, 09 Mar 2020 21:20:12 -0700
MIME-Version: 1.0
Message-ID: <1583814004-15489-1-git-send-email-anand.jain@oracle.com>
Date:   Mon, 9 Mar 2020 21:20:04 -0700 (PDT)
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] fstests: btrfs/177 check for minsize of the scratch
 device
References: <20200309114036.5266-2-anand.jain@oracle.com>
In-Reply-To: <20200309114036.5266-2-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9555 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxscore=0 suspectscore=13 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9555 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=13 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This test case needs at least 3g scratch device space, check for it
before starting the test case.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Makes use of the helper _require_scratch_size() (Thanks Nikolay).

 tests/btrfs/177 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/btrfs/177 b/tests/btrfs/177
index 2b2c2fcc2198..f7c2436ee7e4 100755
--- a/tests/btrfs/177
+++ b/tests/btrfs/177
@@ -34,6 +34,8 @@ _require_scratch_swapfile
 
 swapfile="$SCRATCH_MNT/swap"
 
+_require_scratch_size $((3 * 1024 * 1024)) #kB
+
 # First, create a 1GB filesystem and fill it up.
 _scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
-- 
1.8.3.1

