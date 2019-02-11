Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF57DC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CB0B21B25
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TxyYSW6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732293AbfBKSce (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:32:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37152 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbfBKSce (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 13:32:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1BIO7wg060598;
        Mon, 11 Feb 2019 18:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=xRFXeFe1XzWnvumWkPwu6pK+d7MMeRMI773SfxjsaLo=;
 b=TxyYSW6wIsHCurnlycCOhf2/KkG/lXmMe4+tGGJZulvOOevhTWnaloUfVCPQmCGkfSOQ
 6UkPKeaA1rw2qva+rTPfJhVGfKTLcn56IVbZkmI/f5yhzNKbRVA82K7YAp6th4Z1QkLL
 IjnCQ40mSX/tY23tk/h/e2FL7QYTZiWpm1rkRA2PzNNngbHeD6UtxHS+Jg6qobVlzlAR
 2FXaMy3f8sd1WVXqV/djz5jjFk07VH0d1vn772esBI2FEiUlV0RmNv+SOJ+ELQ/u2r4w
 yLiC7uEX0wPKFAXYmUo89uMt/x6VYKO8QwuCp/TcNO2aUOyq8Xmx3aBjCBjlrPm0z5TV oQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qhre57g19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 18:32:27 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1BIWKkK008893
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 18:32:21 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1BIWKRv028700;
        Mon, 11 Feb 2019 18:32:20 GMT
Received: from kadam (/41.202.241.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 10:32:19 -0800
Date:   Mon, 11 Feb 2019 21:32:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Chris Mason <clm@fb.com>, Anand Jain <anand.jain@oracle.com>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] btrfs: drop the lock on error in btrfs_dev_replace_cancel()
Message-ID: <20190211183209.GA13934@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=957 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902110136
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We should drop the lock on this error path.  This is from static
analysis and I don't know if it's possible to hit this error path in
real life.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/btrfs/dev-replace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 13863354ff9d..ee193c5222b2 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -862,6 +862,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 			btrfs_destroy_dev_replace_tgtdev(tgt_device);
 		break;
 	default:
+		up_write(&dev_replace->rwsem);
 		result = -EINVAL;
 	}
 
-- 
2.17.1

