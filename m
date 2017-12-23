Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35588 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752157AbdLWU7B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 15:59:01 -0500
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 539402001A
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 21:52:38 +0100 (CET)
From: Hans van Kranenburg <hans@knorrie.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: Fix progs_extra build failures
Date: Sat, 23 Dec 2017 21:52:36 +0100
Message-Id: <20171223205238.19678-1-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alternatively, it might be a better idea to just remove the deprecated source
files, since this is not the first time build failures in them went unnoticed.

Hans van Kranenburg (2):
  btrfs-progs: Fix progs_extra build dependencies
  btrfs-progs: Fix build of btrfs-calc-size

 Makefile          | 2 +-
 btrfs-calc-size.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.11.0

