Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:40797 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752195AbeBEGrf (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 5 Feb 2018 01:47:35 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 4/4] btrfs-progs: gitignore: Ignore patches
Date: Mon,  5 Feb 2018 14:47:14 +0800
Message-Id: <20180205064714.15659-4-wqu@suse.com>
In-Reply-To: <20180205064714.15659-1-wqu@suse.com>
References: <20180205064714.15659-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although it's not a good practice to format all patches under project
directory, sometimes lazy bones like me just like to put patches under
project directory.

Just ignore such patches.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 7f1e1950cb77..fa2f9c40b7a9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -79,3 +79,4 @@ stamp-h.in
 stamp-h1
 config/*
 
+*.patch
-- 
2.16.1

