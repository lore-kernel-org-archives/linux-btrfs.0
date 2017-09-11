Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:63625 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdIKFWz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 01:22:55 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 8FEFFAC00C6
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:22:48 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id D72A5BD66A3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:22:47 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: update btrfs-completion
Message-ID: <b5719816-3e51-e3fa-454c-f0da71bfe75d@jp.fujitsu.com>
Date: Mon, 11 Sep 2017 14:22:43 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch updates btrfs-completion:
 - add "filesystem du" and "rescure zero-log"
 - restrict _btrfs_mnts to show btrfs type only
 - add more completion in last case statements

(This file contains both spaces/tabs and may need cleanup.)

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-completion | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/btrfs-completion b/btrfs-completion
index 3ede77b..1f00add 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -16,7 +16,7 @@ _btrfs_mnts()
 	local MNTS
 	MNTS=''
 	while read mnt; do MNTS+="$mnt "
-	done < <(mount | awk '{print $3}')
+	done < <(mount -t btrfs | awk '{print $3}')
 	COMPREPLY+=( $( compgen -W "$MNTS" -- "$cur" ) )
 }
 
@@ -31,11 +31,11 @@ _btrfs()
 
     commands='subvolume filesystem balance device scrub check rescue restore inspect-internal property send receive quota qgroup replace help version'
     commands_subvolume='create delete list snapshot find-new get-default set-default show sync'
-    commands_filesystem='defragment sync resize show df label usage'
+    commands_filesystem='defragment sync resize show df du label usage'
     commands_balance='start pause cancel resume status'
     commands_device='scan add delete remove ready stats usage'
     commands_scrub='start cancel resume status'
-    commands_rescue='chunk-recover super-recover'
+    commands_rescue='chunk-recover super-recover zero-log'
     commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super tree-stats'
     commands_property='get set list'
     commands_quota='enable disable rescan'
@@ -114,6 +114,10 @@ _btrfs()
 						_filedir
 						return 0
 						;;
+					df|usage)
+						_btrfs_mnts
+						return 0
+						;;
 					label)
 						_btrfs_mnts
 						_btrfs_devs
@@ -125,6 +129,26 @@ _btrfs()
 				_btrfs_devs
                 return 0
                 ;;
+			inspect-internal)
+				case $prev in
+					min-dev-size)
+						_btrfs_mnts
+						return 0
+						;;
+					rootid)
+						_filedir
+						return 0
+						;;
+				esac
+				;;
+			receive)
+				case $prev in
+					-f)
+						_filedir
+						return 0
+						;;
+				esac
+				;;
             replace)
                 case $prev in
                     status|cancel)
@@ -137,14 +161,17 @@ _btrfs()
                         ;;
                 esac
                 ;;
+			subvolume)
+				case $prev in
+					list)
+						_btrfs_mnts
+						return 0
+						;;
+				esac
+				;;
         esac
     fi
 
-    if [[ "$cmd" == "receive" && "$prev" == "-f" ]]; then
-        _filedir
-        return 0
-    fi
-
     _filedir -d
     return 0
 }
-- 
2.9.5

