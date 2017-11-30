Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41893 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdK3MOw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 07:14:52 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: make function update_share_count static
Date: Thu, 30 Nov 2017 12:14:47 +0000
Message-Id: <20171130121447.5118-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The function update_share_count is local to the source and does
not need to be in global scope, so make it static.

Cleans up sparse warning:
fs/btrfs/backref.c:219:6: warning: symbol 'update_share_count' was not
declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/backref.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7d0dc100a09a..e4054e533f6d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -216,7 +216,8 @@ static int prelim_ref_compare(struct prelim_ref *ref1,
 	return 0;
 }
 
-void update_share_count(struct share_check *sc, int oldcount, int newcount)
+static void update_share_count(struct share_check *sc, int oldcount,
+			       int newcount)
 {
 	if ((!sc) || (oldcount == 0 && newcount < 1))
 		return;
-- 
2.14.1

