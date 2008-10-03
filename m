From: Chris Mason <chris.mason@oracle.com>
Subject: Re: different oops
Date: Fri, 03 Oct 2008 12:40:35 -0400
Message-ID: <1223052035.13375.27.camel@think.oraclecorp.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-fTdx78lUPubx1pVHcHh4"
Cc: linux-btrfs@vger.kernel.org
To: Martin =?ISO-8859-1?Q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>


--=-fTdx78lUPubx1pVHcHh4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-03 at 18:14 +0200, Martin B=C3=BCrger wrote:
> Hi,
> I'm using the sources from [1] which I checked out today. When=20
> testing the file system with compilebench [2] I traced oops [3]=20
> (with 2 cores, SMP), [4] (single core), [5] (no smp) and [6]=20
> (no-preemt).
>=20

> [1]=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
> [2] http://oss.oracle.com/~mason/compilebench/
> [3] http://rafb.net/p/1hUnky34.html
> [4] http://rafb.net/p/kEGqY199.html
> [5] http://rafb.net/p/pAHJrV88.html
> [6] http://rafb.net/p/tkz92m77.html

Hello,

This is a long standing bug that so far we've only heard about on gentoo
installs.  Could you please give the attached patch a try against your
sources?

-chris


--=-fTdx78lUPubx1pVHcHh4
Content-Disposition: attachment; filename=flush-on-mount.diff
Content-Type: text/x-patch; name=flush-on-mount.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0be044b..726aaf6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1482,6 +1482,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	__setup_root(4096, 4096, 4096, 4096, tree_root,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
+	filemap_write_and_wait(fs_devices->latest_bdev->bd_inode->i_mapping);
 
 	bh = __bread(fs_devices->latest_bdev,
 		     BTRFS_SUPER_INFO_OFFSET / 4096, 4096);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f63cf76..9555408 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -361,8 +361,12 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
 	list_for_each(cur, head) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		if (device->bdev)
+		if (device->bdev) {
+			struct address_space *mapping;
+			mapping = device->bdev->bd_inode->i_mapping;
+			filemap_write_and_wait(mapping);
 			continue;
+		}
 
 		if (!device->name)
 			continue;
@@ -374,6 +378,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			goto error;
 		}
 		set_blocksize(bdev, 4096);
+		filemap_write_and_wait(bdev->bd_inode->i_mapping);
 
 		bh = __bread(bdev, BTRFS_SUPER_INFO_OFFSET / 4096, 4096);
 		if (!bh)
@@ -442,6 +447,8 @@ int btrfs_scan_one_device(const char *path, int flags, void *holder,
 	ret = set_blocksize(bdev, 4096);
 	if (ret)
 		goto error_close;
+
+	filemap_write_and_wait(bdev->bd_inode->i_mapping);
 	bh = __bread(bdev, BTRFS_SUPER_INFO_OFFSET / 4096, 4096);
 	if (!bh) {
 		ret = -EIO;
@@ -951,6 +958,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 			goto out;
 		}
 
+		filemap_write_and_wait(bdev->bd_inode->i_mapping);
 		bh = __bread(bdev, BTRFS_SUPER_INFO_OFFSET / 4096, 4096);
 		if (!bh) {
 			ret = -EIO;

--=-fTdx78lUPubx1pVHcHh4--

