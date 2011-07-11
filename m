From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: R: [PATCH V2] Btrfs-progs: add "btrfs subvolume get-default"
 subcommand
Date: Mon, 11 Jul 2011 14:02:45 +0200 (CEST)
Message-ID: <1989742.2131011310385765409.JavaMail.defaultUser@defaultHost>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>----Messaggio originale----
>Da: xin.zhong@intel.com
>Data: 11/07/2011 10.56
>A: <linux-btrfs@vger.kernel.org>
>Cc: <xin.zhong@intel.com>
>Ogg: [PATCH V2] Btrfs-progs: add &quot;btrfs subvolume get-default&quot; 
subcommand
>
>Add subcommand to get the default subvolume of btrfs filesystem
>
>Reported-by: Yang, Yi <yi.y.yang@intel.com>
>Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
>---
> btrfs-list.c |   57 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++--
> btrfs.c      |    3 +++
> btrfs_cmds.c |   31 ++++++++++++++++++++++++++++++-
> btrfs_cmds.h |    3 ++-
> 4 files changed, 90 insertions(+), 4 deletions(-)

please update the man page too.

>
>diff --git a/btrfs-list.c b/btrfs-list.c
>index 93766a8..aa6a9b4 100644
>--- a/btrfs-list.c
>+++ b/btrfs-list.c
>@@ -536,7 +536,7 @@ build:
> 	return full;
[...]
>+	/* search dir item */
>+	sk->max_type = BTRFS_DIR_ITEM_KEY;
>+	sk->min_type = BTRFS_DIR_ITEM_KEY;
>+
>+	sk->max_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
>+	sk->min_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
>+	sk->max_offset = (u64)-1;
>+	sk->max_transid = (u64)-1;
>+
[...]
>+		/* go through each item to find dir item named "default" */
>+		for (i = 0; i < sk->nr_items; i++) {
>+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
>+								  off);
>+			off += sizeof(*sh);
>+			if (sh->type == BTRFS_DIR_ITEM_KEY) {
>+				di = (struct btrfs_dir_item *)(args.buf + off);
>+				name_len = le16_to_cpu(di->name_len);
>+				name = (char *)di + sizeof(struct btrfs_dir_item);
>+				if (!strncmp("default", name, name_len)) {
>+					subvol_id = btrfs_disk_key_objectid(
>+						&di->location);
>+					break;
>+				}
>+			}
>+
>+			off += sh->len;
>+		}

I am not familiar with the "default subvolume key", but are you sure that the 
key is always in the first set of returned keys ?

>+	}
>+
> 	/* now that we have all the subvol-relative paths filled in,
> 	 * we have to string the subvols together so that we can get
> 	 * a path all the way back to the FS root
>@@ -650,7 +698,12 @@ int list_subvols(int fd)
> 	while (n) {
> 		struct root_info *entry;
> 		entry = rb_entry(n, struct root_info, rb_node);
>-		resolve_root(&root_lookup, entry);
>+		if(!get_default)
>+			resolve_root(&root_lookup, entry);
>+		/* we only want the default subvolume */
>+		else if(subvol_id == entry->root_id)
>+			resolve_root(&root_lookup, entry);
>+		

What happens if there no is a default subvolume (for example a very old btrfs 
filesystem, and/or after removing the "default" subvolume) ?
I suggest to handle this case printing something like "No default subvolume 
found"


BR
G.Baroncelli
	
> 		n = rb_prev(n);
> 	}
> 
>diff --git a/btrfs.c b/btrfs.c
>index 46314cf..6b73f88 100644
>--- a/btrfs.c
>+++ b/btrfs.c
>@@ -73,6 +73,9 @@ static struct Command commands[] = {
> 		"Set the subvolume of the filesystem <path> which will be mounted\n"
> 		"as default."
> 	},
>+	{ do_get_default_subvol, 1, "subvolume get-default", "<path>\n"
>+		"Get the default subvolume of a filesystem."
>+	},
> 	{ do_fssync, 1,
> 	  "filesystem sync", "<path>\n"
> 		"Force a sync on the filesystem <path>."
>diff --git a/btrfs_cmds.c b/btrfs_cmds.c
>index 8031c58..11c56f6 100644
>--- a/btrfs_cmds.c
>+++ b/btrfs_cmds.c
>@@ -301,7 +301,7 @@ int do_subvol_list(int argc, char **argv)
> 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
> 		return 12;
> 	}
>-	ret = list_subvols(fd);
>+	ret = list_subvols(fd, 0);
> 	if (ret)
> 		return 19;
> 	return 0;
>@@ -834,6 +834,35 @@ int do_set_default_subvol(int nargs, char **argv)
> 	return 0;
> }
> 
>+int do_get_default_subvol(int nargs, char **argv)
>+{
>+	int fd;
>+	int ret;
>+	char *subvol;
>+
>+	subvol = argv[1];
>+
>+	ret = test_issubvolume(subvol);
>+	if (ret < 0) {
>+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
>+		return 12;
>+	}
>+	if (!ret) {
>+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
>+		return 13;
>+	}
>+
>+	fd = open_file_or_dir(subvol);
>+	if (fd < 0) {
>+		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
>+		return 12;
>+	}
>+	ret = list_subvols(fd, 1);
>+	if (ret)
>+		return 19;
>+	return 0;
>+}
>+
> int do_df_filesystem(int nargs, char **argv)
> {
> 	struct btrfs_ioctl_space_args *sargs;
>diff --git a/btrfs_cmds.h b/btrfs_cmds.h
>index 7bde191..9cf1ca1 100644
>--- a/btrfs_cmds.h
>+++ b/btrfs_cmds.h
>@@ -28,7 +28,8 @@ int do_scan(int nargs, char **argv);
> int do_resize(int nargs, char **argv);
> int do_subvol_list(int nargs, char **argv);
> int do_set_default_subvol(int nargs, char **argv);
>-int list_subvols(int fd);
>+int do_get_default_subvol(int nargs, char **argv);
>+int list_subvols(int fd, int get_default);
> int do_df_filesystem(int nargs, char **argv);
> int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
> int do_find_newer(int argc, char **argv);
>-- 
>1.7.0.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


