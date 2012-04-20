From: Jim Meyering <jim@meyering.net>
Subject: btrfs-utils: minor buffer-overrun fixes
Date: Fri, 20 Apr 2012 19:36:44 +0200
Message-ID: <1334943408-6720-1-git-send-email-jim@meyering.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[PATCH 1/4] mkfs: use strdup in place of strlen,malloc,strcpy
[PATCH 2/4] restore: don't corrupt stack for a zero-length
[PATCH 3/4] avoid strncpy-induced buffer overrun
[PATCH 4/4] mkfs: avoid heap-buffer-read-underrun for zero-length

The first is just clean-up.
The other three fix one sort of corruption or another,
usually induced by an invalid input.
