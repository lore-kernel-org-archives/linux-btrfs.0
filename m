Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39454 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbeEVAHZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 20:07:25 -0400
Received: by mail-pf0-f194.google.com with SMTP id a22-v6so7839814pfn.6
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 17:07:25 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] Btrfs: allow empty subvol= again
Date: Mon, 21 May 2018 17:07:19 -0700
Message-Id: <4daab3c9993c97f3f962b16fcb9b5d578853765d.1526947478.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

I got a report that after upgrading to 4.16, someone's filesystems
weren't mounting:

[   23.845852] BTRFS info (device loop0): unrecognized mount option 'subvol='

Before 4.16, this mounted the default subvolume. It turns out that this
empty "subvol=" is actually an application bug, but it was causing the
application to fail, so it's an ABI break if you squint.

The generic parsing code we use for mount options (match_token())
doesn't match an empty string as "%s". Previously, setup_root_args()
removed the "subvol=" string, but the mount path was cleaned up to not
need that. Add a dummy Opt_subvol_empty to fix this.

Fixes: 312c89fbca06 ("btrfs: cleanup btrfs_mount() using btrfs_mount_root()")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Hi, Dave,

This is silly but IMO it's a regression. If you agree, this should
probably go to 4.17 + stable. I'll submit an xfstests test shortly.

Thanks!

 fs/btrfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0628092b0b1b..f82152a0cb38 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -323,6 +323,7 @@ enum {
 	Opt_ssd, Opt_nossd,
 	Opt_ssd_spread, Opt_nossd_spread,
 	Opt_subvol,
+	Opt_subvol_empty,
 	Opt_subvolid,
 	Opt_thread_pool,
 	Opt_treelog, Opt_notreelog,
@@ -388,6 +389,7 @@ static const match_table_t tokens = {
 	{Opt_ssd_spread, "ssd_spread"},
 	{Opt_nossd_spread, "nossd_spread"},
 	{Opt_subvol, "subvol=%s"},
+	{Opt_subvol_empty, "subvol="},
 	{Opt_subvolid, "subvolid=%s"},
 	{Opt_thread_pool, "thread_pool=%u"},
 	{Opt_treelog, "treelog"},
@@ -461,6 +463,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_set_opt(info->mount_opt, DEGRADED);
 			break;
 		case Opt_subvol:
+		case Opt_subvol_empty:
 		case Opt_subvolid:
 		case Opt_subvolrootid:
 		case Opt_device:
-- 
2.17.0

