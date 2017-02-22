Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36506 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933823AbdBVW6a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 17:58:30 -0500
Received: by mail-wr0-f196.google.com with SMTP id z61so2119329wrc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 14:56:43 -0800 (PST)
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Benedikt Morbach <benedikt.morbach@googlemail.com>
Subject: [PATCH 2/2] btrfs-progs: receive: handle root subvol path in clone
Date: Wed, 22 Feb 2017 23:56:37 +0100
Message-Id: <20170222225637.21858-2-benedikt.morbach@googlemail.com>
In-Reply-To: <20170222225637.21858-1-benedikt.morbach@googlemail.com>
References: <20170222225637.21858-1-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

testcase:
    # ro subvol /src/parent
    # rw subvol /src/foo
    clone /src/parent/file /src/foo/file
    subvol snapshot -r /src/foo /src/foo.snap

    # generates a "clone parent/file -> foo.snap/file" send command
    send -p /src/parent /src/foo.snap

    # target fs:
    #    dest/
    #        |--- parent/...
    # mounted with -o subvol=dest, such that "parent" is at <target>/parent
    receive <target>

result:
    ERROR: cannot open dest/parent/file: No such file or directory

expected:
    "dest/" get's stripped from the clone source path to get the actual
    path in the target fs, if reachable from the mount point/chroot.

    This is exactly what process_snapshot does, which gets called on
    _every_ incremental receive and I'm quite certain is correct in
    doing so

Signed-off-by: Benedikt Morbach <benedikt.morbach@googlemail.com>
---

Hi,

I first tried fixing this ages ago with [1], which was met with some scepticism.
While that patch wasn't 100% correct I believe this is, and as mentioned it does
exacly the same thing as process_snapshot because that has the exact same problem.

An fstest to reproduce this will be following shortly

[1] https://patchwork.kernel.org/patch/9177155/

 cmds-receive.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 790218c..01345a4 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -782,7 +782,24 @@ static int process_clone(const char *path, u64 offset, u64 len,
 						r->subvol_parent_name);
 			}
 		}*/
-		subvol_path = strdup(si->path);
+
+		/* strip the subvolume that we are receiving to from the start of subvol_path */
+		if (rctx->full_root_path) {
+			size_t root_len = strlen(rctx->full_root_path);
+			size_t sub_len = strlen(si->path);
+
+			if (sub_len > root_len &&
+			    strstr(si->path, rctx->full_root_path) == si->path &&
+			    si->path[root_len] == '/') {
+				subvol_path = strdup(si->path + root_len + 1);
+			} else {
+				error("clone: source subvol path %s unreachable from %s",
+					si->path, rctx->full_root_path);
+				goto out;
+			}
+		} else {
+			subvol_path = strdup(si->path);
+		}
 	}
 
 	ret = path_cat_out(full_clone_path, subvol_path, clone_path);
-- 
2.11.1

