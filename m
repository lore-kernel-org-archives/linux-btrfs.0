Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33512 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934208AbcKMToB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 14:44:01 -0500
Received: by mail-pf0-f176.google.com with SMTP id d2so24731834pfd.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Nov 2016 11:44:01 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 6/6] btrfs-progs: document space_cache=v2 more thoroughly
Date: Sun, 13 Nov 2016 11:35:24 -0800
Message-Id: <215dd6b41e1aa835f46b2a28bdd3732c7f349845.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Documentation/btrfs-man5.asciidoc | 43 +++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index d12b059..3b003d3 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -319,25 +319,32 @@ May be resumed with *btrfs balance resume* or the paused state can be removed
 by *btrfs balance cancel*. The default behaviour is to start interrutpd balance.
 
 *space_cache*::
-*space_cache=v2*::
+*space_cache='version'*::
 *nospace_cache*::
-('nospace_cache' since: 3.2, 'space_cache=v2' since 4.5, default: on)
-+
-Options to control the free space cache.  This affects performance as searching
-for new free blocks could take longer if the space cache is not enabled. On the
-other hand, managing the space cache consumes some resources.  It can be
-disabled without clearing at mount time.
-+
-There are two implementations of how the space is tracked. The safe default is
-'v1'.  On large filesystems (many-terabytes) and certain workloads the 'v1'
-performance may degrade.  This problem is addressed by 'v2', that is based on
-b-trees, sometimes referred to as 'free-space-tree'.
-+
-'Compatibility notes:'
-+
-* the 'v2' has to be enabled manually at mount time, once
-* kernel without 'v2' support will be able to mount the filesystem in read-only mode
-* 'v2' can be removed by mounting with 'clear_cache'
+('nospace_cache' since: 3.2, 'space_cache=v1' and 'space_cache=v2' since 4.5, default: 'space_cache=v1')
++
+Options to control the free space cache. The free space cache greatly improves
+performance when reading block group free space into memory. However, managing
+the space cache consumes some resources, including a small amount of disk
+space.
++
+There are two implementations of the free space cache. The original
+implementation, 'v1', is the safe default. The 'v1' space cache can be disabled
+at mount time with 'nospace_cache' without clearing.
++
+On very large filesystems (many terabytes) and certain workloads, the
+performance of the 'v1' space cache may degrade drastically. The 'v2'
+implementation, which adds a new B-tree called the free space tree, addresses
+this issue. Once enabled, the 'v2' space cache will always be used and cannot
+be disabled unless it is cleared. Use 'clear_cache,space_cache=v1' or
+'clear_cache,nospace_cache' to do so. If 'v2' is enabled, kernels without 'v2'
+support will only be able to mount the filesystem in read-only mode. The
+`btrfs(8)` command currently only has read-only support for 'v2'. A read-write
+command may be run on a 'v2' filesystem by clearing the cache, running the
+command, and then remounting with 'space_cache=v2'.
++
+If a version is not explicitly specified, the default implementation will be
+chosen, which is 'v1' as of 4.9.
 
 *ssd*::
 *nossd*::
-- 
2.10.2

