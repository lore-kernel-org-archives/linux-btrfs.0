From: Jim Meyering <jim@meyering.net>
Subject: btrfs-progs: minor buffer-overrun fixes (v3)
Date: Sat, 21 Apr 2012 09:50:13 +0200
Message-ID: <1334994617-30016-1-git-send-email-jim@meyering.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[I realized I'd need this v3 as I was falling asleep last night. ]
Same net effect as v2, but bisectable, now that the fix

-       args.name[BTRFS_PATH_NAME_MAX-1] = 0;
+       args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;

is applied to 3/4, rather than to 4/4.

[PATCHv3 1/4] mkfs: use strdup in place of strlen,malloc,strcpy
[PATCHv3 2/4] restore: don't corrupt stack for a zero-length
[PATCHv3 3/4] avoid several strncpy-induced buffer overruns
[PATCHv3 4/4] mkfs: avoid heap-buffer-read-underrun for zero-length
