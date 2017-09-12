Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:63996 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdILBEV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 21:04:21 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 611ABAC0153
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 10:04:17 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: cleanup whitespaces of btrfs-completion
Message-ID: <d95e0221-6079-3f80-93b7-de0e76a5785b@jp.fujitsu.com>
Date: Tue, 12 Sep 2017 10:04:10 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clean up spaces and use only tabs. No functional change.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-completion | 188 +++++++++++++++++++++++++++----------------------------
 1 file changed, 94 insertions(+), 94 deletions(-)

diff --git a/btrfs-completion b/btrfs-completion
index 1f00add..ae683f4 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -6,8 +6,8 @@
 
 _btrfs_devs()
 {
-    local DEVS
-    DEVS=''; while read dev; do DEVS+="$dev "; done < <(lsblk -pnro name)
+	local DEVS
+	DEVS=''; while read dev; do DEVS+="$dev "; done < <(lsblk -pnro name)
 	COMPREPLY+=( $( compgen -W "$DEVS" -- "$cur" ) )
 }
 
@@ -23,92 +23,92 @@ _btrfs_mnts()
 _btrfs()
 {
 	local cur prev words cword
-    _init_completion || return
+	_init_completion || return
 
-    COMPREPLY=()
+	COMPREPLY=()
 
 	local cmd=${words[1]}
 
-    commands='subvolume filesystem balance device scrub check rescue restore inspect-internal property send receive quota qgroup replace help version'
-    commands_subvolume='create delete list snapshot find-new get-default set-default show sync'
-    commands_filesystem='defragment sync resize show df du label usage'
-    commands_balance='start pause cancel resume status'
-    commands_device='scan add delete remove ready stats usage'
-    commands_scrub='start cancel resume status'
-    commands_rescue='chunk-recover super-recover zero-log'
-    commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super tree-stats'
-    commands_property='get set list'
-    commands_quota='enable disable rescan'
-    commands_qgroup='assign remove create destroy show limit'
-    commands_replace='start status cancel'
+	commands='subvolume filesystem balance device scrub check rescue restore inspect-internal property send receive quota qgroup replace help version'
+	commands_subvolume='create delete list snapshot find-new get-default set-default show sync'
+	commands_filesystem='defragment sync resize show df du label usage'
+	commands_balance='start pause cancel resume status'
+	commands_device='scan add delete remove ready stats usage'
+	commands_scrub='start cancel resume status'
+	commands_rescue='chunk-recover super-recover zero-log'
+	commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super tree-stats'
+	commands_property='get set list'
+	commands_quota='enable disable rescan'
+	commands_qgroup='assign remove create destroy show limit'
+	commands_replace='start status cancel'
 
 	if [[ "$cur" == -* && $cword -le 3 && "$cmd" != "help" ]]; then
 		COMPREPLY=( $( compgen -W '--help' -- "$cur" ) )
 		return 0
 	fi
 
-    if [[ $cword -eq 1 ]]; then
-        COMPREPLY=( $( compgen -W "$commands" -- "$cur" ) )
-        return 0
-    elif [[ $cword -eq 2 ]]; then
-        case $cmd in
-            subvolume)
-                opts="$commands_subvolume"
-                ;;
-            filesystem)
-                opts="$commands_filesystem"
-                ;;
-            balance)
-                opts="$commands_balance"
-                ;;
-            device)
-                opts="$commands_device"
-                ;;
-            scrub)
-                opts="$commands_scrub"
-                ;;
-            check)
-                _btrfs_devs
+	if [[ $cword -eq 1 ]]; then
+		COMPREPLY=( $( compgen -W "$commands" -- "$cur" ) )
+		return 0
+	elif [[ $cword -eq 2 ]]; then
+		case $cmd in
+			subvolume)
+				opts="$commands_subvolume"
+				;;
+			filesystem)
+				opts="$commands_filesystem"
+				;;
+			balance)
+				opts="$commands_balance"
+				;;
+			device)
+				opts="$commands_device"
+				;;
+			scrub)
+				opts="$commands_scrub"
+				;;
+			check)
+				_btrfs_devs
+				return 0
+				;;
+			rescue)
+				opts="$commands_rescue"
+				;;
+			restore)
+				_btrfs_devs
 				return 0
-                ;;
-            rescue)
-                opts="$commands_rescue"
-                ;;
-            restore)
-                _btrfs_devs
+				;;
+			inspect-internal)
+				opts="$commands_inspect_internal"
+				;;
+			property)
+				opts="$commands_property"
+				;;
+			send|receive)
+				_filedir -d
 				return 0
-                ;;
-            inspect-internal)
-                opts="$commands_inspect_internal"
-                ;;
-            property)
-                opts="$commands_property"
-                ;;
-            send|receive)
-                _filedir -d
-                return 0
-                ;;
-            quota)
-                opts="$commands_quota"
-                ;;
-            qgroup)
-                opts="$commands_qgroup"
-                ;;
-            replace)
-                opts="$commands_replace"
-                ;;
-            help)
-                opts="--full"
-                ;;
-            version)
-                return 0
-                ;;
-        esac
-        COMPREPLY=( $( compgen -W "$opts" -- "$cur" ) )
-        return 0
-    elif [[ $cword -eq 3 ]]; then
-        case $cmd in
-            filesystem)
+				;;
+			quota)
+				opts="$commands_quota"
+				;;
+			qgroup)
+				opts="$commands_qgroup"
+				;;
+			replace)
+				opts="$commands_replace"
+				;;
+			help)
+				opts="--full"
+				;;
+			version)
+				return 0
+				;;
+		esac
+		COMPREPLY=( $( compgen -W "$opts" -- "$cur" ) )
+		return 0
+	elif [[ $cword -eq 3 ]]; then
+		case $cmd in
+			filesystem)
 				case $prev in
 					defragment)
 						_filedir
@@ -124,11 +124,11 @@ _btrfs()
 						return 0
 						;;
 				esac
-                ;;
-            device|rescue)
+				;;
+			device|rescue)
 				_btrfs_devs
-                return 0
-                ;;
+				return 0
+				;;
 			inspect-internal)
 				case $prev in
 					min-dev-size)
@@ -149,18 +149,18 @@ _btrfs()
 						;;
 				esac
 				;;
-            replace)
-                case $prev in
-                    status|cancel)
+			replace)
+				case $prev in
+					status|cancel)
 						_btrfs_mnts
-                        return 0
-                        ;;
-                    start)
+						return 0
+						;;
+					start)
 						_btrfs_devs
-                        return 0
-                        ;;
-                esac
-                ;;
+						return 0
+						;;
+				esac
+				;;
 			subvolume)
 				case $prev in
 					list)
@@ -169,11 +169,11 @@ _btrfs()
 						;;
 				esac
 				;;
-        esac
-    fi
+		esac
+	fi
 
-    _filedir -d
-    return 0
+	_filedir -d
+	return 0
 }
 
 complete -F _btrfs btrfs
-- 
2.9.5

