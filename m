Return-Path: <SRS0=FZr9=CN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E92DC2BB84
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Sep 2020 23:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52CD72084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Sep 2020 23:27:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L2AZ7hyk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIDX1e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:27:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbgIDX1b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2020 19:27:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084NPo0a138853;
        Fri, 4 Sep 2020 23:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/ekKWjsSiSRP7jdvfJvHyaUCmLf/c7K2M6nk+sZvARI=;
 b=L2AZ7hykQ6coAFrtq9woa9W4kS934BQyMiA6Zt64Y1YpwUBT2pEBxkdJXcSAvnKjFso3
 JWNo6DYarIZYo0T193es2CbeT1rHuemCXImU6pmBrcTD4p93InVnolpqNvXtHUtuprTc
 /IFANHIl53jP+RJU0Tl0+Wg8EzXWrEKOpuqFWSkbqKLC1KWGxbUFtPnoryI81HVdn0TM
 dSfywwVGednijoQ4pPWHHd7siR/XQarXr7K7NbBE2vqBiO4Yzty6ADNEOEmHOvVZnZnR
 IburVeWvGzbYETfxhanqKmuiL0rHOBOduY4x2eNrQ98HhUplY8lmqIYfJYKOKhMccBP4 uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eergvcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Sep 2020 23:27:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084NOm9f019151;
        Fri, 4 Sep 2020 23:25:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380xehsus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Sep 2020 23:25:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 084NPOHg019044;
        Fri, 4 Sep 2020 23:25:24 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Sep 2020 16:25:24 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: [PATCH v2 0/2] fstests: btrfs seed device device operation tests
Date:   Sat,  5 Sep 2020 07:25:14 +0800
Message-Id: <cover.1599233551.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1599234146.git.anand.jain@oracle.com>
References: <cover.1599234146.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=13 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=13
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040197
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Tests and updates seed device operations test cases.

Anand Jain (2):
  btrfs: add a test case for btrfs seed device delete
  btrfs/163: replace sprout instead of seed

 tests/btrfs/163     | 21 +++++++++---
 tests/btrfs/163.out |  5 ++-
 tests/btrfs/219     | 83 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/219.out | 15 ++++++++
 tests/btrfs/group   |  1 +
 5 files changed, 119 insertions(+), 6 deletions(-)
 create mode 100755 tests/btrfs/219
 create mode 100644 tests/btrfs/219.out

-- 
2.25.1

