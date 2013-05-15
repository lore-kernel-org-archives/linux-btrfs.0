Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:28469 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009Ab3EONyw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 09:54:52 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.27 OK)
	with ESMTP id X02f08p4EHbUuY for <linux-btrfs@vger.kernel.org>;
	Wed, 15 May 2013 15:54:49 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: detect when scrub is started twice
Date: Wed, 15 May 2013 15:54:49 +0200
Message-Id: <1368626089-20710-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check whether any involved device is already busy running a
scrub. This would cause damaged status messages and the state
"aborted" without the explanation that a scrub was already
running. Therefore check it first, prevent it and give some
feedback to the user if scrub is already running.
Note that if scrub is started with a block device as the
parameter, only that particular block device is checked. It
is a normal mode of operation to start scrub on multiple
single devices, there is no reason to prevent this.

Here is an example:
/mnt2 is the mountpoint of a filesystem.
/dev/sdk and /dev/sdl are the block devices for that filesystem.

case 1:
btrfs scrub start /mnt2
btrfs scrub start /mnt2
-> complain

case 1:
btrfs scrub start /dev/sdk
btrfs scrub start /dev/sdk
-> complain

case 3:
btrfs scrub start /dev/sdk
btrfs scrub start /dev/sdl
-> don't complain

case 4:
btrfs scrub start /dev/sdk
btrfs scrub start /mnt2
-> complain

case 5:
btrfs scrub start /mnt2
btrfs scrub start /dev/sdk
-> complain if the scrub on /dev/sdk is still running.
-> don't complain if the scrub on /dev/sdk is finished, the
   status messages will be fine.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-scrub.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index c0dc584..95dfee3 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1025,6 +1025,27 @@ int mkdir_p(char *path)
 	return 0;
 }
 
+static int is_scrub_running_on_fs(struct btrfs_ioctl_fs_info_args *fi_args,
+				  struct btrfs_ioctl_dev_info_args *di_args,
+				  struct scrub_file_record **past_scrubs)
+{
+	int i;
+
+	if (!fi_args || !di_args || !past_scrubs)
+		return 0;
+
+	for (i = 0; i < fi_args->num_devices; i++) {
+		struct scrub_file_record *sfr =
+			last_dev_scrub(past_scrubs, di_args[i].devid);
+
+		if (!sfr)
+			continue;
+		if (!(sfr->stats.finished || sfr->stats.canceled))
+			return 1;
+	}
+	return 0;
+}
+
 static const char * const cmd_scrub_start_usage[];
 static const char * const cmd_scrub_resume_usage[];
 
@@ -1162,6 +1183,27 @@ static int scrub_start(int argc, char **argv, int resume)
 		close(fdres);
 	}
 
+	/*
+	 * check whether any involved device is already busy running a
+	 * scrub. This would cause damaged status messages and the state
+	 * "aborted" without the explanation that a scrub was already
+	 * running. Therefore check it first, prevent it and give some
+	 * feedback to the user if scrub is already running.
+	 * Note that if scrub is started with a block device as the
+	 * parameter, only that particular block device is checked. It
+	 * is a normal mode of operation to start scrub on multiple
+	 * single devices, there is no reason to prevent this.
+	 */
+	if (is_scrub_running_on_fs(&fi_args, di_args, past_scrubs)) {
+		ERR(!do_quiet,
+		    "ERROR: scrub is already running.\n"
+		    "To cancel use 'btrfs scrub cancel %s'.\n"
+		    "To see the status use 'btrfs scrub status [-d] %s'.\n",
+		    path, path);
+		err = 1;
+		goto out;
+	}
+
 	t_devs = malloc(fi_args.num_devices * sizeof(*t_devs));
 	sp = calloc(fi_args.num_devices, sizeof(*sp));
 	spc.progress = calloc(fi_args.num_devices * 2, sizeof(*spc.progress));
-- 
1.8.2.3

