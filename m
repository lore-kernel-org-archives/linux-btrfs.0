Return-Path: <SRS0=bDrN=52=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23D1C2BB85
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Apr 2020 03:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD9B212CC
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Apr 2020 03:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586490823;
	bh=XjXYzZA3Blto0KWDpihAXvG8nbtE6sMohic1rqCj6FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QO9cB8O+Sf7sYocqJ6gqnUPaN0JjrmIuIEkIGwJO+EZYrxFxElbnduT6PBh+BZ4l4
	 CxYwMLlsLJfyWHEeFnpXb7SjKHMJvsZLYWCpkJhy7AgwpY68ugzX2yZXHLIlPBk1Od
	 E0fJ5O5c54EX2ZTHHQRCKU9haVbUWfiy1eEE4dKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgDJDxg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 23:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728946AbgDJDuj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Apr 2020 23:50:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA5B2137B;
        Fri, 10 Apr 2020 03:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490639;
        bh=XjXYzZA3Blto0KWDpihAXvG8nbtE6sMohic1rqCj6FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaTeNasiwsux7DhKGzDGKPpG47NYqvn0UD60o5aTobdkMF/QRP3ZKAHXOO+d8T/ru
         BjlaSkFqeW19IzuqduYueOVlKpexeBqw32URyNm/oMEoro7LpFrZWtlV0YYEimIjGh
         f+QJDRUpUUJQt+HrhoWVivuS8OVi7NTn9tYsECI4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 29/32] btrfs: hold a ref on the root in btrfs_recover_relocation
Date:   Thu,  9 Apr 2020 23:50:02 -0400
Message-Id: <20200410035005.9371-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410035005.9371-1-sashal@kernel.org>
References: <20200410035005.9371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 932fd26df8125a5b14438563c4d3e33f59ba80f7 ]

We look up the fs root in various places in here when recovering from a
crashed relcoation.  Make sure we hold a ref on the root whenever we
look them up.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f98913061a40c..377cf3785fbbd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4428,6 +4428,12 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 					err = ret;
 					goto out;
 				}
+			} else {
+				if (!btrfs_grab_fs_root(fs_root)) {
+					err = -ENOENT;
+					goto out;
+				}
+				btrfs_put_fs_root(fs_root);
 			}
 		}
 
@@ -4477,10 +4483,15 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			goto out_free;
 		}
+		if (!btrfs_grab_fs_root(fs_root)) {
+			err = -ENOENT;
+			goto out_free;
+		}
 
 		err = __add_reloc_root(reloc_root);
 		BUG_ON(err < 0); /* -ENOMEM or logic error */
 		fs_root->reloc_root = reloc_root;
+		btrfs_put_fs_root(fs_root);
 	}
 
 	err = btrfs_commit_transaction(trans);
@@ -4508,10 +4519,14 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	if (err == 0) {
 		/* cleanup orphan inode in data relocation tree */
 		fs_root = read_fs_root(fs_info, BTRFS_DATA_RELOC_TREE_OBJECTID);
-		if (IS_ERR(fs_root))
+		if (IS_ERR(fs_root)) {
 			err = PTR_ERR(fs_root);
-		else
-			err = btrfs_orphan_cleanup(fs_root);
+		} else {
+			if (btrfs_grab_fs_root(fs_root)) {
+				err = btrfs_orphan_cleanup(fs_root);
+				btrfs_put_fs_root(fs_root);
+			}
+		}
 	}
 	return err;
 }
-- 
2.20.1

