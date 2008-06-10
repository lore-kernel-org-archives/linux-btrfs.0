From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] btrfs: allow scanning multiple devices during mount
Date: Tue, 10 Jun 2008 15:23:52 +0200
Message-ID: <20080610132352.GA1852@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Allows to specify one or multiple device=/dev/foo options during mount
so that ioctls on the control device can be avoided.  Especially useful
when trying to mount a multi-device setup as root.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/super.c
===================================================================
--- btrfs-unstable.orig/super.c	2008-06-10 10:40:18.000000000 +0200
+++ btrfs-unstable/super.c	2008-06-10 10:47:47.000000000 +0200
@@ -65,7 +65,7 @@ static void btrfs_put_super (struct supe
 }
 
 enum {
-	Opt_degraded, Opt_subvol, Opt_nodatasum, Opt_nodatacow,
+	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
 	Opt_ssd, Opt_err,
 };
@@ -73,6 +73,7 @@ enum {
 static match_table_t tokens = {
 	{Opt_degraded, "degraded"},
 	{Opt_subvol, "subvol=%s"},
+	{Opt_device, "device=%s"},
 	{Opt_nodatasum, "nodatasum"},
 	{Opt_nodatacow, "nodatacow"},
 	{Opt_nobarrier, "nobarrier"},
@@ -142,8 +143,9 @@ int btrfs_parse_options(struct btrfs_roo
 			btrfs_set_opt(info->mount_opt, DEGRADED);
 			break;
 		case Opt_subvol:
+		case Opt_device:
 			/*
-			 * This one is parsed by btrfs_parse_early_options
+			 * These are parsed by btrfs_parse_early_options
 			 * and can be happily ignored here.
 			 */
 			break;
@@ -212,8 +214,9 @@ int btrfs_parse_options(struct btrfs_roo
  * All other options will be parsed on much later in the mount process and
  * only when we need to allocate a new super block.
  */
-static int btrfs_parse_early_options(const char *options,
-			char **subvol_name)
+static int btrfs_parse_early_options(const char *options, int flags,
+		void *holder, char **subvol_name,
+		struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *opts, *p;
@@ -240,11 +243,18 @@ static int btrfs_parse_early_options(con
 		case Opt_subvol:
 			*subvol_name = match_strdup(&args[0]);
 			break;
+		case Opt_device:
+			error = btrfs_scan_one_device(match_strdup(&args[0]),
+					flags, holder, fs_devices);
+			if (error)
+				goto out_free_opts;
+			break;
 		default:
 			break;
 		}
 	}
 
+ out_free_opts:
 	kfree(opts);
  out:
 	/*
@@ -380,7 +390,8 @@ static int btrfs_get_sb(struct file_syst
 	struct btrfs_fs_devices *fs_devices = NULL;
 	int error = 0;
 
-	error = btrfs_parse_early_options(data, &subvol_name);
+	error = btrfs_parse_early_options(data, flags, fs_type,
+					  &subvol_name, &fs_devices);
 	if (error)
 		goto error;
 
