Return-Path: <SRS0=Rh/l=5U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE41C2BA1A
	for <linux-btrfs@archiver.kernel.org>; Sat,  4 Apr 2020 10:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D907F20719
	for <linux-btrfs@archiver.kernel.org>; Sat,  4 Apr 2020 10:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="AoTqIbq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgDDKcV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 4 Apr 2020 06:32:21 -0400
Received: from smtp-16-i2.italiaonline.it ([213.209.12.16]:53448 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbgDDKcU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Apr 2020 06:32:20 -0400
Received: from venice.bhome ([94.37.173.46])
        by smtp-16.iol.local with ESMTPA
        id Kg63jDxJE6Q7RKg66jI6Wo; Sat, 04 Apr 2020 12:32:18 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1585996338; bh=NvzAaTARaLJ96vxBk5dd3zVfmf+EeFgB/b1nhVCFYZU=;
        h=From;
        b=AoTqIbq+7jt+9U1Oe3dqFFZmHE/LS9OCmnlK62yGBEGQaSTVUvPsWh1G0iIHWxJxo
         EQr2X9Kes/lLG2vf2Fcxa6N+Akqd9rs7h4FRo3l2DWsRNMzzkz12zUn0kDwF88awAP
         eo47prsCKe4u2cJ+6N4UV9CTg0bZz0/B8i4G2878DlbkK3dos2A0wBIgd4gLmlnNKB
         SfC+2sOA2WPwAfviBc3634X6wmHXhqidkwTk3XIizCGs1jppL1d+GfPkd7bI8eWcf9
         8esk+HG5l4+c84r7ZtDvEbMyIXHvEhEm/FcvKUwsLinEk589gizkcJXuEYSlBKMG0m
         6g7wPWi6ynX6A==
X-CNFS-Analysis: v=2.3 cv=LelCFQXi c=1 sm=1 tr=0
 a=TpQr5eyM7/bznjVQAbUtjA==:117 a=TpQr5eyM7/bznjVQAbUtjA==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=T92Z9xJX5iHLdJxoEloA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>,
        Graham Cobb <g.btrfs@cobb.uk.net>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/5] Update the man page in order to give a guideline about mixed profiles.
Date:   Sat,  4 Apr 2020 12:32:12 +0200
Message-Id: <20200404103212.40986-6-kreijack@libero.it>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200404103212.40986-1-kreijack@libero.it>
References: <20200404103212.40986-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKAGwLMXXr86U8TsKLPeJGlM+Q5SkBcu5LXuqJE0AUZ3SD8jePIyqFazIUOPNZKtP7UTnBT/YGIHndjwJAVetsrOQ8Cp2j97j7vaQVrpe/4YoqPkcRQc
 JtFUMFANXp6j0977pueoUYGdoc/cmd53kdzMaqQ3SyLf3tfq+qoPAO51P47QDAOJyabDXcrWovCwKw6/Dod3kPZZCCG2DDvjtaGVETf2mDylX7Y1/cki8mot
 71x3cl/Me0b3BfG7wM3s/nCekk9Mniw2FD26Wn7P8+bCkb7FpiaZLhhKFoCPNei2cbHrOX0732vS+D5dMzY7CcLpa59jxw2DgeA5Gn39sgI=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs-man5.asciidoc | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index 56b1ed58..88f1c5ed 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -846,6 +846,37 @@ work and a workaround would need to be used to mount a multi-device filesystem.
 The mount option 'device' can trigger the device scanning during mount.
 
 
+FILESYSTEM WITH MULTIPLE PROFILES
+---------------------------------
+
+It is possible that a btrfs filesystem features block group of the same
+type (e.g. data) with different profiles.
+This could happen when a profile conversion is interrupted (see
+`btrfs-balance(8)`).
+Some 'btrfs' commands perform a test to detect this kind of condition. In such
+case a warning like this is showed:
+
+--------------------
+WARNING: Multiple profiles detected.  See 'man btrfs(5)'.
+WARNING: data -> [raid1, single], metadata -> [raid1, single]
+--------------------
+
+In a case like this, it is suggested to complete the conversion running
+`btrfs balance`. This because the next block group allocation
+is performed on the basis of the set of the profiles present on the disks,
+according to the following priorities:
+
+* RAID6
+* RAID5
+* RAID10
+* RAID1
+* RAID0
+
+For example if both the profile RAID6 and RAID1 are present on the disks,
+the next block group allocation will be RAID6, regardeless of the last
+`btrfs balance`.
+
+
 SEE ALSO
 --------
 `acl`(5),
-- 
2.26.0

