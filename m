Return-Path: <SRS0=T3D7=7K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B531CC433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 18:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 445F5206A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 18:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="HavJfKbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405880AbgE1SfB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 May 2020 14:35:01 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:47090 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405868AbgE1Se7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 May 2020 14:34:59 -0400
Received: from venice.bhome ([78.12.136.199])
        by smtp-35.iol.local with ESMTPA
        id eNMjjt6vcLNQWeNMnjtDeO; Thu, 28 May 2020 20:34:57 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1590690897; bh=H9WRSFd82hbCDotLF6a/tKsukwxA6ocUzLx0ZSBBwwI=;
        h=From;
        b=HavJfKbJA0qh+niC3RXbBFeM0gw1gdMwrcviaAbVvh3ZXA6kWTdrN4ZrNFHIMPcMa
         v95+C49F0YZJKFuDnpZCCZ99sR5+XO62sfYAEeFqu1TvP1ojtFHWfjFdAcICL+mfra
         gSAyN+N/lJid0LIGl3RohEQaYpJqwAfUdNLgjRS9oxBZh6cSSH52XvyH3xBnGxIaQO
         s0rR5PdXYhJnjhs8n2AwU+J6D9vpCu7SemURoV6r1a2/efzpZ0SoLfBZifNnrNXloS
         M3CIxqWPRy8qpzFUOfuAfC/0WOEHbHrI0EVRd1d9SQ4+sVBMSCbOA/NiHlM4gNggM1
         bfpztHILfnn4A==
X-CNFS-Analysis: v=2.3 cv=LKsYv6e9 c=1 sm=1 tr=0
 a=kx39m2EDZI1V9vDwKCQCcA==:117 a=kx39m2EDZI1V9vDwKCQCcA==:17
 a=V5MRcGaKH_fqCW5OQCMA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Michael <mclaud@roznica.com.ua>, Hugo Mills <hugo@carfax.org.uk>,
        Martin Svec <martin.svec@zoner.cz>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Paul Jones <paul@pauljones.id.au>,
        Adam Borowski <kilobyte@angband.pl>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/4] Add flags for dedicated metadata disks
Date:   Thu, 28 May 2020 20:34:49 +0200
Message-Id: <20200528183451.16654-3-kreijack@libero.it>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200528183451.16654-1-kreijack@libero.it>
References: <20200528183451.16654-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDrXuWwqW9ik1CG+woYMSGvNfWh9IhnmcXwPbE8nfDLRf4NfgySGejXwrgFP7yFQQnItySqGDeTWk+6WpDrHqrs7f5/5Q+dXlaH5VbLUDBl3F059ypjE
 X3Xtq4rMt2ZBHXvPUzalvLQ+8Jl9bHdA69EVN399/ZGPOlgSD1658C0hf9mc6TjEErDwSyLmVwkZFwJBEnzaEngys9yzvq7AKE3802VxIxk4UsesQytgqLkO
 zurn1hiwQZ7sRGSWpGD5ol8FlF4Cp82U+gB/NCojpIkXkxlNIxvdxaSrBTxE6+/JlicmdJZuXrSDO/rtxIvqMBDq+NMOIvkb/7gAbIZCiSzHT5fIpX+ODEkd
 vh0ml1XrsIwk0c5Ul7kzpUZ8CN1l4vFWVIeZPsasJCikVh5lg6hPzSa1ocg6K1a6CyJKBrjQi51gH3ZptvB0l3oc8orHCg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 include/uapi/linux/btrfs_tree.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 8e322e2c7e78..a45d09591db8 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -355,6 +355,9 @@ struct btrfs_key {
 	__u64 offset;
 } __attribute__ ((__packed__));
 
+/* dev_item.type */
+#define BTRFS_DEV_PREFERRED_METADATA	(1ULL << 0)
+
 struct btrfs_dev_item {
 	/* the internal btrfs device id */
 	__le64 devid;
-- 
2.27.0.rc2

