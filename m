From: Daniel Baumann <daniel@debian.org>
Subject: PULL: Properly cast and avoid compiler warnings, fixes build on alpha
 and ia64.
Date: Sat, 05 Jun 2010 09:05:17 +0200
Message-ID: <4C09F72D.6080803@debian.org>
Reply-To: daniel@debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

please apply the following patch to fix building btfs-progs on alpha and
ia64 from:

git://git.debian-maintainers.org/git/daniel/btrfs-tools.git

- ---snip---
commit 561e811286c52f141cf4944fe219e6b61fab0ac9
Author: Daniel Baumann <daniel@debian.org>
Date:   Sat Jun 5 08:53:46 2010 +0200

    Properly cast and avoid compiler warnings,
    fixes build on alpha and ia64.

    Patch from Luca Bruno <lucab@debian.org>,
    Alexander Kurtz <kurtz.alex@googlemail.com>,
    and Daniel Baumann <daniel@debian.org>
    (see Debian Bugs #539433 and #583768).

diff --git a/btrfs-list.c b/btrfs-list.c
index 7741705..c2c5712 100644
- --- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -248,8 +248,9 @@ static int resolve_root(struct root_lookup *rl,
struct root_info *ri)
                        break;
                }
        }
- -       printf("ID %llu top level %llu path %s\n", ri->root_id, top_id,
- -              full_path);
+       printf("ID %llu top level %llu path %s\n",
+               (long long unsigned int) ri->root_id,
+               (long long unsigned int) top_id, full_path);
        free(full_path);
        return 0;
 }
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a109c6a..1487bc2 100644
- --- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -65,8 +65,9 @@ struct extent_buffer *debug_read_block(struct
btrfs_root *root, u64 bytenr,
                eb->dev_bytenr = multi->stripes[0].physical;

                fprintf(info_file, "mirror %d logical %Lu physical %Lu "
- -                       "device %s\n", mirror_num, bytenr, eb->dev_bytenr,
- -                       device->name);
+                       "device %s\n", mirror_num,
+                       (long long unsigned int) bytenr,
+                       (long long unsigned int) eb->dev_bytenr,
device->name);
                kfree(multi);

                if (!copy || mirror_num == copy)
diff --git a/btrfsctl.c b/btrfsctl.c
index be6bf25..45e7aa3 100644
- --- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -234,7 +234,7 @@ int main(int ac, char **av)
                args.fd = fd;
                ret = ioctl(snap_fd, command, &args);
        } else if (command == BTRFS_IOC_DEFAULT_SUBVOL) {
- -               printf("objectid is %llu\n", objectid);
+               printf("objectid is %llu\n", (long long unsigned int)
objectid);
                ret = ioctl(fd, command, &objectid);
        } else
                ret = ioctl(fd, command, &args);
diff --git a/convert.c b/convert.c
index d037c98..cf656a0 100644
- --- a/convert.c
+++ b/convert.c
@@ -2572,7 +2572,7 @@ int do_rollback(const char *devname, int force)
        ext2_root = btrfs_read_fs_root(root->fs_info, &key);
        if (!ext2_root || IS_ERR(ext2_root)) {
                fprintf(stderr, "unable to open subvol %llu\n",
- -                       key.objectid);
+                       (unsigned long long) key.objectid);
                goto fail;
        }

diff --git a/debug-tree.c b/debug-tree.c
index 40628e0..d94f7e7 100644
- --- a/debug-tree.c
+++ b/debug-tree.c
@@ -162,7 +162,8 @@ int main(int ac, char **av)
                                              root->nodesize, 0);
                }
                if (!leaf) {
- -                       fprintf(stderr, "failed to read %llu\n",
block_only);
+                       fprintf(stderr, "failed to read %llu\n",
+                       (long long unsigned int) block_only);
                        return 0;
                }
                btrfs_print_tree(root, leaf, 0);
diff --git a/disk-io.c b/disk-io.c
index addebe1..463c8bc 100644
- --- a/disk-io.c
+++ b/disk-io.c
@@ -678,7 +678,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char
*path, u64 sb_bytenr,
                   ~BTRFS_FEATURE_INCOMPAT_SUPP;
        if (features) {
                printk("couldn't open because of unsupported "
- -                      "option features (%Lx).\n", features);
+                      "option features (%Lx).\n",
+                       (unsigned long long)features);
                BUG_ON(1);
        }

@@ -692,7 +693,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char
*path, u64 sb_bytenr,
                ~BTRFS_FEATURE_COMPAT_RO_SUPP;
        if (writes && features) {
                printk("couldn't open RDWR because of unsupported "
- -                      "option features (%Lx).\n", features);
+                      "option features (%Lx).\n",
+                       (unsigned long long) features);
                BUG_ON(1);
        }

diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..4531ba4 100644
- --- a/extent-tree.c
+++ b/extent-tree.c
@@ -1448,7 +1448,8 @@ int btrfs_lookup_extent_info(struct
btrfs_trans_handle *trans,
                goto out;
        if (ret != 0) {
                btrfs_print_leaf(root, path->nodes[0]);
- -               printk("failed to find block number %Lu\n", bytenr);
+               printk("failed to find block number %Lu\n",
+               (unsigned long long) bytenr);
                BUG();
        }

diff --git a/print-tree.c b/print-tree.c
index bd8af13..bf921e0 100644
- --- a/print-tree.c
+++ b/print-tree.c
@@ -494,7 +494,7 @@ void btrfs_print_leaf(struct btrfs_root *root,
struct extent_buffer *l)
                case BTRFS_DIR_LOG_ITEM_KEY:
                        dlog = btrfs_item_ptr(l, i, struct
btrfs_dir_log_item);
                        printf("\t\tdir log end %Lu\n",
- -                              btrfs_dir_log_end(l, dlog));
+                              (unsigned long long) btrfs_dir_log_end(l,
dlog));
                       break;
                case BTRFS_ORPHAN_ITEM_KEY:
                        printf("\t\torphan item\n");
- ---snap---

Regards,
Daniel

- -- 
Address:        Daniel Baumann, Burgunderstrasse 3, CH-4562 Biberist
Email:          daniel.baumann@panthera-systems.net
Internet:       http://people.panthera-systems.net/~daniel-baumann/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwJ9y0ACgkQ+C5cwEsrK57GYACfb8ckQXaE6gmY9+T2vPDHEmnn
lGcAoNGbfXfvlCLdZWv697f3oESOEvbE
=GyDc
-----END PGP SIGNATURE-----
