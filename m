Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbbE0QqD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 12:46:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 37238ADC1
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 16:46:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: receive: restore capabilities after chown
Date: Wed, 27 May 2015 18:45:59 +0200
Message-Id: <1432745159-29493-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Capabilities are cleared after chown, and the btrfs-stream encodes the
CHOWN command after any SET_XATTR command. So the capabilites are not
always preserved.

This could be fixed in kernel to emit the instructions in the right
order, but fix in userspace will make it work for older kernels.

If we see the capabilities among xattrs, cache the value and apply it
again in case it's followed by chown on that file.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=68891
Reported-by: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-receive.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index b0a312ca560a..13aa19a8f718 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -68,6 +68,14 @@ struct btrfs_receive
 	struct subvol_uuid_search sus;
 
 	int honor_end_cmd;
+
+	/*
+	 * Buffer to store capabilities from security.capabilities xattr,
+	 * usually 20 bytes, but make same room for potentially larger
+	 * encodings. Must be set only once per file, denoted by length > 0.
+	 */
+	char cached_capabilities[64];
+	int cached_capabilities_len;
 };
 
 static int finish_subvol(struct btrfs_receive *r)
@@ -652,6 +660,23 @@ static int process_set_xattr(const char *path, const char *name,
 	struct btrfs_receive *r = user;
 	char *full_path = path_cat(r->full_subvol_path, path);
 
+	if (strcmp("security.capability", name) == 0) {
+		if (g_verbose >= 3)
+			fprintf(stderr, "set_xattr: cache capabilities\n");
+		if (r->cached_capabilities_len)
+			fprintf(stderr, "WARNING: capabilities set multiple times per file: %s\n",
+					full_path);
+		if (len > sizeof(r->cached_capabilities)) {
+			fprintf(stderr,
+			  "ERROR: capabilities encoded to %d bytes, buffer too small\n",
+				len);
+			ret = -E2BIG;
+			goto out;
+		}
+		r->cached_capabilities_len = len;
+		memcpy(r->cached_capabilities, data, len);
+	}
+
 	if (g_verbose >= 2) {
 		fprintf(stderr, "set_xattr %s - name=%s data_len=%d "
 				"data=%.*s\n", path, name, len,
@@ -757,6 +782,23 @@ static int process_chown(const char *path, u64 uid, u64 gid, void *user)
 		goto out;
 	}
 
+	if (r->cached_capabilities_len) {
+		if (g_verbose >= 2)
+			fprintf(stderr, "chown: restore capabilities\n");
+		ret = lsetxattr(full_path, "security.capability",
+				r->cached_capabilities,
+				r->cached_capabilities_len, 0);
+		memset(r->cached_capabilities, 0,
+				sizeof(r->cached_capabilities));
+		r->cached_capabilities_len = 0;
+		if (ret < 0) {
+			ret = -errno;
+			fprintf(stderr, "ERROR: restoring capabilities %s: %s\n",
+					path, strerror(-ret));
+			goto out;
+		}
+	}
+
 out:
 	free(full_path);
 	return ret;
@@ -894,6 +936,14 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
 		goto out;
 
 	while (!end) {
+		if (r->cached_capabilities_len) {
+			if (g_verbose >= 3)
+				fprintf(stderr, "clear cached capabilities\n");
+			memset(r->cached_capabilities, 0,
+					sizeof(r->cached_capabilities));
+			r->cached_capabilities_len = 0;
+		}
+
 		ret = btrfs_read_and_process_send_stream(r_fd, &send_ops, r,
 							 r->honor_end_cmd,
 							 max_errors);
-- 
2.1.3

