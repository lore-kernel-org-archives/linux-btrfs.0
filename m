From: Jim Meyering <jim@meyering.net>
Subject: btrfs-progs: minor buffer-overrun fixes (v2)
Date: Fri, 20 Apr 2012 21:27:22 +0200
Message-ID: <1334950046-24147-1-git-send-email-jim@meyering.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Same net result as before, but with the stray-parenthesis fix
moved to 2/4 where it belongs, rather than buried in 3/4.
Thanks to Josef for the reviews.

Also, I fixed this in 3/4:
-       args.name[BTRFS_PATH_NAME_MAX-1] = 0;
+       args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;

[PATCHv2 1/4] mkfs: use strdup in place of strlen,malloc,strcpy
[PATCHv2 2/4] restore: don't corrupt stack for a zero-length
[PATCHv2 3/4] avoid several strncpy-induced buffer overruns
[PATCHv2 4/4] mkfs: avoid heap-buffer-read-underrun for zero-length
