Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48681 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbeBEGre (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 5 Feb 2018 01:47:34 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 3/4] btrfs-progs: gitignore: Ignore *.restored test image
Date: Mon,  5 Feb 2018 14:47:13 +0800
Message-Id: <20180205064714.15659-3-wqu@suse.com>
In-Reply-To: <20180205064714.15659-1-wqu@suse.com>
References: <20180205064714.15659-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 8e607f6e3ce2..7f1e1950cb77 100644
--- a/.gitignore
+++ b/.gitignore
@@ -48,6 +48,7 @@ library-test-static
 /tests/test-console.txt
 /tests/test.img
 /tests/mnt/
+*.restored
 
 aclocal.m4
 autom4te.cache
-- 
2.16.1

