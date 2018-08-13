Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbeHMInf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 04:43:35 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7F52CAE95
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2018 06:02:51 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs-progs: completion: Use _filedir() to replace _btrfs_devs()
Date: Mon, 13 Aug 2018 14:02:43 +0800
Message-Id: <20180813060244.8795-2-wqu@suse.com>
In-Reply-To: <20180813060244.8795-1-wqu@suse.com>
References: <20180813060244.8795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For developers it's pretty common to call "btrfs check" on a raw image
dump other than real block device.
It's also possible to end users to do some tests on loop devices.

So current _btrfs_devs() is really making things worse. Use _filedir()
to replace _btrfs_devs() so it can complete any filenames, no matter if
it's just a file or a real block device.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-completion | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/btrfs-completion b/btrfs-completion
index ae683f4ecf61..b7628e6984c5 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -4,13 +4,6 @@
 # (http://lists.alioth.debian.org/pipermail/bash-completion-devel/2013-June/004868.html)
 # edited by John C F <john.ch.fr at gmail.com> on 2015-02-02
 
-_btrfs_devs()
-{
-	local DEVS
-	DEVS=''; while read dev; do DEVS+="$dev "; done < <(lsblk -pnro name)
-	COMPREPLY+=( $( compgen -W "$DEVS" -- "$cur" ) )
-}
-
 _btrfs_mnts()
 {
 	local MNTS
@@ -68,14 +61,14 @@ _btrfs()
 				opts="$commands_scrub"
 				;;
 			check)
-				_btrfs_devs
+				_filedir
 				return 0
 				;;
 			rescue)
 				opts="$commands_rescue"
 				;;
 			restore)
-				_btrfs_devs
+				_filedir
 				return 0
 				;;
 			inspect-internal)
@@ -120,13 +113,13 @@ _btrfs()
 						;;
 					label)
 						_btrfs_mnts
-						_btrfs_devs
+						_filedir
 						return 0
 						;;
 				esac
 				;;
 			device|rescue)
-				_btrfs_devs
+				_filedir
 				return 0
 				;;
 			inspect-internal)
@@ -156,7 +149,7 @@ _btrfs()
 						return 0
 						;;
 					start)
-						_btrfs_devs
+						_filedir
 						return 0
 						;;
 				esac
-- 
2.18.0
