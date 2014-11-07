Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbaKGRGe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 12:06:34 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5CD2CAC89
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 17:06:33 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/5] btrfs-progs: update .gitignore
Date: Fri,  7 Nov 2014 18:06:32 +0100
Message-Id: <3d0b0111df10fadcf7928ec628c306863d0c2d5a.1415379676.git.dsterba@suse.cz>
In-Reply-To: <cover.1415379676.git.dsterba@suse.cz>
References: <cover.1415379676.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 .gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.gitignore b/.gitignore
index fc8c07a22f7f..e637b170714b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,6 +1,7 @@
 *.o
 *.static.o
 *.o.d
+tags
 .cc-defines.h
 version.h
 version
@@ -30,8 +31,11 @@ btrfs-show-super
 btrfs-zero-log
 btrfs-corrupt-block
 btrfs-select-super
+btrfs-calc-size
 btrfstune
 libbtrfs.a
 libbtrfs.so
 libbtrfs.so.0
 libbtrfs.so.0.1
+library-test
+library-test-static
-- 
1.8.4.5

