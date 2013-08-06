Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab3HFMZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 08:25:21 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9748CA51B7
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Aug 2013 14:25:20 +0200 (CEST)
Date: Tue, 6 Aug 2013 14:25:20 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: introduce command namespace for development
 features
Message-ID: <79debec8a345c66dd0b02793de680e0438428ee0.1375791411.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1375791411.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We'd like to make it easier to preview a new feature and remove the
burden to invent sane user interface (command name, placement,
arguments, man) from the beginning. For this purpose the developer are
free to use the 1st level namespace called '_'. It will be hidden from
regular btrfs help output and the only way to get the commands is

  btrfs _ --help

The commands appear as if they are in the 1st level, but have to be used
from inside _, eg.

  btrfs _ newcommand

Once the interface is stable, the command will be moved to the right
place.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/btrfs.c b/btrfs.c
index 4e93e13..dff0d70 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -239,6 +239,28 @@ static int handle_options(int *argc, char ***argv)
 	return (*argv) - orig_argv;
 }
 
+static const char * const devel_features_cmd_usage[] = {
+	"btrfs _ <command> [<args>]",
+	NULL
+};
+
+const struct cmd_group devel_features_cmd_group = {
+	devel_features_cmd_usage,
+	"WARNING: this is a namespace for commands that are in development\n"
+	"and anything is subject to change. Once the user interface gets\n"
+	"stabilized, it'll be moved to the appropriate place.\n"
+	"NOTE: you have to call the commands as eg.\n"
+	"\tbtrfs _ newcommand --args\n",
+	{
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_devel_features(int argc, char **argv)
+{
+	return handle_command_group(&devel_features_cmd_group, argc, argv);
+}
+
 const struct cmd_group btrfs_cmd_group = {
 	btrfs_cmd_group_usage, btrfs_cmd_group_info, {
 		{ "subvolume", cmd_subvolume, NULL, &subvolume_cmd_group, 0 },
@@ -255,6 +277,8 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
+		{ "_", cmd_devel_features, devel_features_cmd_usage,
+			&devel_features_cmd_group, 1 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
-- 
1.8.3.1

