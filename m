From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] btrfs-progs: cast u64 to long long to avoid printf warnings
Date: Thu, 7 Apr 2011 21:02:04 +1000
Message-ID: <20110407210204.268daefd@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


When building on ppc64 I hit a number of warnings in printf:

btrfs-map-logical.c:69: error: format =E2=80=98%Lu=E2=80=99 expects typ=
e =E2=80=98long long
unsigned int=E2=80=99, but argument 4 has type =E2=80=98u64=E2=80=99

=46ix them.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..c602b87 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -249,7 +249,8 @@ static int resolve_root(struct root_lookup *rl, str=
uct root_info *ri)
 			break;
 		}
 	}
-	printf("ID %llu top level %llu path %s\n", ri->root_id, top_id,
+	printf("ID %llu top level %llu path %s\n",
+	       (unsigned long long)ri->root_id, (unsigned long long)top_id,
 	       full_path);
 	free(full_path);
 	return 0;
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a109c6a..9e9806d 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -65,8 +65,8 @@ struct extent_buffer *debug_read_block(struct btrfs_r=
oot *root, u64 bytenr,
 		eb->dev_bytenr =3D multi->stripes[0].physical;
=20
 		fprintf(info_file, "mirror %d logical %Lu physical %Lu "
-			"device %s\n", mirror_num, bytenr, eb->dev_bytenr,
-			device->name);
+			"device %s\n", mirror_num, (unsigned long long)bytenr,
+			(unsigned long long)eb->dev_bytenr, device->name);
 		kfree(multi);
=20
 		if (!copy || mirror_num =3D=3D copy)
diff --git a/btrfsctl.c b/btrfsctl.c
index 92bdf39..896999f 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -245,7 +245,7 @@ int main(int ac, char **av)
 		args.fd =3D fd;
 		ret =3D ioctl(snap_fd, command, &args);
 	} else if (command =3D=3D BTRFS_IOC_DEFAULT_SUBVOL) {
-		printf("objectid is %llu\n", objectid);
+		printf("objectid is %llu\n", (unsigned long long)objectid);
 		ret =3D ioctl(fd, command, &objectid);
 	} else
 		ret =3D ioctl(fd, command, &args);
diff --git a/debug-tree.c b/debug-tree.c
index 0525354..e8ee64e 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -166,7 +166,8 @@ int main(int ac, char **av)
 					      root->nodesize, 0);
 		}
 		if (!leaf) {
-			fprintf(stderr, "failed to read %llu\n", block_only);
+			fprintf(stderr, "failed to read %llu\n",
+				(unsigned long long)block_only);
 			return 0;
 		}
 		btrfs_print_tree(root, leaf, 0);
diff --git a/disk-io.c b/disk-io.c
index a6e1000..5295dca 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -678,7 +678,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char=
 *path, u64 sb_bytenr,
 		   ~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
 		printk("couldn't open because of unsupported "
-		       "option features (%Lx).\n", features);
+		       "option features (%Lx).\n",
+		       (unsigned long long)features);
 		BUG_ON(1);
 	}
=20
@@ -692,7 +693,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char=
 *path, u64 sb_bytenr,
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (writes && features) {
 		printk("couldn't open RDWR because of unsupported "
-		       "option features (%Lx).\n", features);
+		       "option features (%Lx).\n",
+		       (unsigned long long)features);
 		BUG_ON(1);
 	}
=20
diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..3a09f2f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1448,7 +1448,8 @@ int btrfs_lookup_extent_info(struct btrfs_trans_h=
andle *trans,
 		goto out;
 	if (ret !=3D 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
-		printk("failed to find block number %Lu\n", bytenr);
+		printk("failed to find block number %Lu\n",
+		       (unsigned long long)bytenr);
 		BUG();
 	}
=20
diff --git a/print-tree.c b/print-tree.c
index ac575d5..c673dcb 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -497,7 +497,7 @@ void btrfs_print_leaf(struct btrfs_root *root, stru=
ct extent_buffer *l)
 		case BTRFS_DIR_LOG_ITEM_KEY:
 			dlog =3D btrfs_item_ptr(l, i, struct btrfs_dir_log_item);
 			printf("\t\tdir log end %Lu\n",
-			       btrfs_dir_log_end(l, dlog));
+			       (unsigned long long)btrfs_dir_log_end(l, dlog));
 		       break;
 		case BTRFS_ORPHAN_ITEM_KEY:
 			printf("\t\torphan item\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
