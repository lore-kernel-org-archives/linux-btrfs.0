Return-Path: <SRS0=UWtY=4X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAE5C10DCE
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 22:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94FCE20705
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 22:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="MwGKYUS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgCFWex (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 17:34:53 -0500
Received: from gateway21.websitewelcome.com ([192.185.46.113]:48568 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbgCFWex (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Mar 2020 17:34:53 -0500
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2020 17:34:53 EST
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 9B4894010B96C
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Mar 2020 16:10:26 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ALAoj6829Sl8qALAojiADS; Fri, 06 Mar 2020 16:10:26 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FZpoqtpL0CDwGKnAs+sqrIJ5mXXApjq5UeHNcIv2g+k=; b=MwGKYUS8Y4iJ1WQLplUThEuaPm
        f5KUIjqpqvTNSzzOW/vCbs8PPOFV7Fod+TXrJTy1avisRb2+UbDFMXFtBsk2BVnQa3fGmqq+VlwBy
        9L2SicBSIeby7jdCPRouGtBJ4tuEmlsGhtM8ScByWD/ez9i/8QzUnxUZpA3IpFbOeLKCgZlVCthc6
        G/icLYf04sjeaFSwlo2AcZPSWmtgl2NX29uMAOb1LqEhzsaKmd+vOoApial8CjwvAX39nBhm/EHIW
        HWABE2nc0gHC3IADRK/5HtRlP9QYef/dyjPPj58jm6IuOLzMmeCI55WlgOQoIja0WSsi42+w/cdqu
        G6vSsYhw==;
Received: from [201.162.241.123] (port=7991 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jALAm-000HxE-K5; Fri, 06 Mar 2020 16:10:25 -0600
Date:   Fri, 6 Mar 2020 16:13:33 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] btrfs: scrub: Replace zero-length array with
 flexible-array member
Message-ID: <20200306221333.GA31084@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.241.123
X-Source-L: No
X-Exim-ID: 1jALAm-000HxE-K5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.241.123]:7991
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 16aa680134fd..adaf8ab694d5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -149,7 +149,7 @@ struct scrub_parity {
 	 */
 	unsigned long		*ebitmap;
 
-	unsigned long		bitmap[0];
+	unsigned long		bitmap[];
 };
 
 struct scrub_ctx {
-- 
2.25.0

