Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:46370 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933035AbdCaPSn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 11:18:43 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 31 Mar 2017 17:19:04 +0200
Message-Id: <20170331151904.4091-1-kilobyte@angband.pl>
In-Reply-To: <0939c5df-3abd-ec68-16ef-538ad04251aa@mendix.com>
References: <0939c5df-3abd-ec68-16ef-538ad04251aa@mendix.com>
Subject: [PATCH] btrfs: drop the nossd flag when remounting with -o ssd
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The opposite case was already handled right in the very next switch entry.

Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
Not sure if setting NOSSD should also disable SSD_SPREAD, there's currently
no way to disable that option once set.

 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 06bd9b332e18..7342399951ad 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -549,11 +549,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_ssd:
 			btrfs_set_and_info(info, SSD,
 					   "use ssd allocation scheme");
+			btrfs_clear_opt(info->mount_opt, NOSSD);
 			break;
 		case Opt_ssd_spread:
 			btrfs_set_and_info(info, SSD_SPREAD,
 					   "use spread ssd allocation scheme");
 			btrfs_set_opt(info->mount_opt, SSD);
+			btrfs_clear_opt(info->mount_opt, NOSSD);
 			break;
 		case Opt_nossd:
 			btrfs_set_and_info(info, NOSSD,
-- 
2.11.0

