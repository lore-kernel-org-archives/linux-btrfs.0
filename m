Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:63040 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdHXGGu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 02:06:50 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 01BB6AC03F5
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 15:06:47 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 276646D681B
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 15:06:46 +0900 (JST)
Subject: [PATCH] btrfs-progs: change document in accordance with usage info
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Message-ID: <c87a8f49-3d68-6b22-7348-a32adb981de4@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 15:06:41 +0900
MIME-Version: 1.0
In-Reply-To: <2ea1dea7-13b5-b984-03ce-2d88d4f9d220@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Usage info of "btrfs check" shows "-Q|--qgroup-report" (and first patch 
enables -Q), but the document only shows "--qgroup-report".

Therefore add -Q to the doc.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
  Documentation/btrfs-check.asciidoc | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-check.asciidoc 
b/Documentation/btrfs-check.asciidoc
index 28ed9dd..fa054e4 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -60,7 +60,7 @@ show extent state for the given subvolume
  -p|--progress::
  indicate progress at various checking phases

---qgroup-report::
+-Q|--qgroup-report::
  verify qgroup accounting and compare against filesystem accounting

  -r|--tree-root <bytenr>::
--
2.9.5

