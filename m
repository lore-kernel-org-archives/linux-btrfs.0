Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:53540 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbeH2V3k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 17:29:40 -0400
Received: from mail.tty0.ch (hermes.tty0.ch [172.21.1.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPS id 6F22D307EA
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 19:23:15 +0200 (CEST)
From: Axel Burri <axel@tty0.ch>
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [RFC PATCH 6/6] btrfs-progs: add splitcmd binaries to gitignore
Date: Wed, 29 Aug 2018 19:24:09 +0200
Message-Id: <20180829172409.18064-7-axel@tty0.ch>
In-Reply-To: <20180829172409.18064-1-axel@tty0.ch>
References: <20180829172409.18064-1-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 .gitignore | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/.gitignore b/.gitignore
index 144ebb3b..299019e0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -42,6 +42,15 @@ library-test-static
 /fssum
 testsuite-id
 
+btrfs-filesystem-usage
+btrfs-qgroup-destroy
+btrfs-receive
+btrfs-send
+btrfs-subvolume-delete
+btrfs-subvolume-list
+btrfs-subvolume-show
+btrfs-subvolume-snapshot
+
 /tests/*-tests-results.txt
 /tests/test-console.txt
 /tests/test.img
-- 
2.16.4
