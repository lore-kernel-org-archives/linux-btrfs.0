Return-Path: <SRS0=T3D7=7K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03062C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 18:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D50722078C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 18:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="nE6fLpuK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405939AbgE1SnS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 May 2020 14:43:18 -0400
Received: from smtp-35-i2.italiaonline.it ([213.209.12.35]:54700 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391486AbgE1SnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 May 2020 14:43:14 -0400
Received: from venice.bhome ([78.12.136.199])
        by smtp-35.iol.local with ESMTPA
        id eNMpjt6z1LNQWeNMqjtDfg; Thu, 28 May 2020 20:35:00 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1590690900; bh=me/YDVlE9+xUXPkPpB1eA7osrZeuF909rw9P7eSJxjc=;
        h=From;
        b=nE6fLpuKBGbDCKqtwW9wKf7xw2Ry7XBOu9T9MinXbClAUn3RPLgp3KqxeX4LAluo8
         Z/E9l2vzfo7verI8WfgtTr9rJzNGn6irSbA8AUNIuI19xdJm34/ry/18WEjCbvsWsr
         /2V876rZsI1/5riYdtYQCRRNsMLkEkV1AjTBahUKH8swQ7uVvx5I47jYBCiamMkcoP
         tffHjtsWkekae2hljliiID6s60SvEd79XC292aW+mDxLAex1ir91NAKYN9c/dlvVVI
         HPh/zgOIEn09L2du4nhRnDwx1WBSYSpPbkSHwSoY0qPEKRdli84ruZrbrOhzq1YpAP
         jKBTacaliGREQ==
X-CNFS-Analysis: v=2.3 cv=LKsYv6e9 c=1 sm=1 tr=0
 a=kx39m2EDZI1V9vDwKCQCcA==:117 a=kx39m2EDZI1V9vDwKCQCcA==:17
 a=ql0qUeC1yQfw4kYLIM0A:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/3] Update man page for preferred_metadata property.
Date:   Thu, 28 May 2020 20:34:56 +0200
Message-Id: <20200528183456.18030-4-kreijack@libero.it>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200528183456.18030-1-kreijack@libero.it>
References: <20200528183456.18030-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLMktXZF/NLz8gW5JWErp17mvovLSk3VXUW20thWXTr8hbT3unapcCAqjKxNdJdNwAd8tMv4+ohQzRZLbu+2QPw2PdfPhyaZShww1V9z/wKAKOF51aTC
 tYvZXiM25snZBOsDgVi9Mum4NM9uvkOOY7tnew8yBYCsmnOhud85lJdLN7ld/DcGAMASlhyrFMN5lwba9g0/euCjkwTidlfwQMQ=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Update the man page of the btrfs property subcommand to show the use
of the device property "preferred_metadata".

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs-property.asciidoc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/btrfs-property.asciidoc b/Documentation/btrfs-property.asciidoc
index 47960833..e1396bd2 100644
--- a/Documentation/btrfs-property.asciidoc
+++ b/Documentation/btrfs-property.asciidoc
@@ -48,6 +48,9 @@ device as object. For a mounted filesystem, specify a mount point.
 compression::::
 compression algorithm set for an inode, possible values: 'lzo', 'zlib', 'zstd'.
 To disable compression use "" (empty string), 'no' or 'none'.
+preferred_metadata::::
+flag that designate a device as reserved only for metadata/system chunks.
+Possible values: 0 or 1.
 
 *list* [-t <type>] <object>::
 Lists available properties with their descriptions for the given object.
-- 
2.27.0.rc2

