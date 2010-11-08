From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [RFC][PATCH2] exporting info via sysfs
Date: Mon, 8 Nov 2010 19:13:35 +0100
Message-ID: <201011081913.46171.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1854750.XnVj4qHUh6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1854750.XnVj4qHUh6
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

the enclosed patch is a second attempt to export some information from btrf=
s=20
filesystem through the sysfs interface.

At the moment there are two kinds of information available. The ones relate=
d=20
to the devices and the ones related to the filesystems.

Before explaining the sysfs filesystem layout, I have to refresh to everybo=
dy
 that btrfs manages the devices in "two step".

The first step is when the command "btrfs device scan" is started. The comm=
and=20
find all the suitable devices, and passes the devices name (/dev/sda1 for=20
example) to the btrfs subsystem. Then btrfs opens the device, reads the sup=
er=20
block, and *closes* the device.

The second step is the mount of a filesystem. From the device passed by the=
=20
mount command, the uuid is extracted. Then btrfs searches=20
from the list of the devices scanned the devices linked to the filesystem.

It must be noted that between the two steps, the devices exist in btrfs but=
=20
are not opened. At this thime the only thing know is the path of the device=
=2E=20

The info are under /sys/fs/btrfs, where two directories are created:
=2D devices
=2D filesystems

Under devices/ there are the devices used by btrfs. Under filesystem there
are the filesystem mounted.

Every device is identified by its uuid (look at the UUID_SUB tag in the out=
put=20
of blkid). The info exported are:
=2D major, minor	-> the major/minor of the exported device (only if the dev=
ice
		   is used, otherwise these are set to "none")
=2D name	-> path of the block device (valid only if the device is not used)
=2D state -> status of the device (online or offline)
=2D devid -> devid of the device (an index of the device)
=2D fsid  -> uuid of the filesystem
=2D writeable, total_byte,     |-> fields of the struct  btrfs_device (I ca=
n't=20
=2D disk_total_byte, byte_used |-> explain a more formal description )

Every filesystem is identified by its uuid (look at the UUID tag in the out=
put
of blkid). The info exported are:
=2D label  -> filesystem label
=2D total_devices -> total number of device
=2D open_devices  -> number of opened devices (total_devices - missing devi=
ces)
=2D num_devices   -> ??
=2D rw_devices    -> number of rw devices
=2D block_used, total_block -> space used / space available [raid is not
                             considered]


Using sysfs to export info from btrfs, can resolve a lot of issues that the=
=20
using of ioctl raises.=20
The code is onaly a proof of concpet, use at your risk (I use it under linux
user mode). Comments are welcome.

Regards
Goffredo

Example:

$ (cd /sys/fs/btrfs/; for i in */*/*; do echo -e "$i:\t$(cat $i)"; done )  =
       =20
devices/494d030e-d392-4275-985a-643ae0986e5b/bytes_used:        199229440
devices/494d030e-d392-4275-985a-643ae0986e5b/devid:     1
devices/494d030e-d392-4275-985a-643ae0986e5b/disk_total_bytes:  555745280
devices/494d030e-d392-4275-985a-643ae0986e5b/fsid:      df7db53b-4f62-4c91-=
a275-2928dcad06b7
devices/494d030e-d392-4275-985a-643ae0986e5b/major:     98
devices/494d030e-d392-4275-985a-643ae0986e5b/minor:     16
devices/494d030e-d392-4275-985a-643ae0986e5b/name:      98/16
devices/494d030e-d392-4275-985a-643ae0986e5b/status:    online
devices/494d030e-d392-4275-985a-643ae0986e5b/total_bytes:       555745280
devices/494d030e-d392-4275-985a-643ae0986e5b/writeable: 1
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/bytes_used:        75497472
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/devid:     4
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/disk_total_bytes:  555745280
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/fsid:      df7db53b-4f62-4c91-=
a275-2928dcad06b7
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/major:     98
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/minor:     64
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/name:      98/64
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/status:    online
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/total_bytes:       555745280
devices/666a6b42-f813-4104-a705-d795fc3d7dd1/writeable: 1
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/bytes_used:        178257920
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/devid:     2
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/disk_total_bytes:  555745280
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/fsid:      df7db53b-4f62-4c91-=
a275-2928dcad06b7
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/major:     98
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/minor:     32
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/name:      98/32
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/status:    online
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/total_bytes:       555745280
devices/cd4ca632-06f1-4935-8799-3f1bc8caf0e4/writeable: 1
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/bytes_used:        75497472
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/devid:     3
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/disk_total_bytes:  555745280
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/fsid:      df7db53b-4f62-4c91-=
a275-2928dcad06b7
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/major:     98
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/minor:     48
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/name:      98/48
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/status:    online
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/total_bytes:       555745280
devices/d1e2fb24-851d-4a0e-bc82-0ae36866f70c/writeable: 1
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/blocks_used:   28672
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/blocksize:     4096
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/label: btrfs-example
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/num_devices:   4
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/open_devices:  4
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/rw_devices:    4
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/total_blocks:  2222981120
filesystems/df7db53b-4f62-4c91-a275-2928dcad06b7/total_devices: 4

=2D-------------------


diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8299a25..2251faf 100644
=2D-- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -51,6 +51,7 @@
 #include "version.h"
 #include "export.h"
 #include "compression.h"
+#include "sysfs.h"
=20
 static const struct super_operations btrfs_super_ops;
=20
@@ -59,6 +60,7 @@ static void btrfs_put_super(struct super_block *sb)
 	struct btrfs_root *root =3D btrfs_sb(sb);
 	int ret;
=20
+	btrfs_sysfs_del_super(root->fs_info);
 	ret =3D close_ctree(root);
 	sb->s_fs_info =3D NULL;
=20
@@ -585,6 +587,7 @@ static struct dentry *btrfs_mount(struct file_system_ty=
pe *fs_type, int=20
flags,
 	char *subvol_name =3D NULL;
 	u64 subvol_objectid =3D 0;
 	int error =3D 0;
+	struct btrfs_root *broot;
=20
 	if (!(flags & MS_RDONLY))
 		mode |=3D FMODE_WRITE;
@@ -668,6 +671,10 @@ static struct dentry *btrfs_mount(struct file_system_t=
ype *fs_type, int=20
flags,
 		root =3D new_root;
 	}
=20
+
+	broot =3D s->s_fs_info;
+	btrfs_sysfs_add_super(broot->fs_info); /* FIXME: check error */
+
 	kfree(subvol_name);
 	return root;
=20
@@ -677,6 +684,7 @@ error_close_devices:
 	btrfs_close_devices(fs_devices);
 error_free_subvol_name:
 	kfree(subvol_name);
+/*error:*/
 	return ERR_PTR(error);
 }
=20
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4ce16ef..b64cf458 100644
=2D-- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -27,17 +27,70 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "volumes.h"
=20
=2Dstatic ssize_t root_blocks_used_show(struct btrfs_root *root, char *buf)
+/*
+ * This function converts the supplied UUID into a 36 chars (plus
+ * trailing '\0') string like
+ * 1b4e28ba-2fa1-11d2-883f-0016d3cca427
+ */
+static void uuid_unparse(u8 *uuid, char *out)
 {
=2D	return snprintf(buf, PAGE_SIZE, "%llu\n",
=2D		(unsigned long long)btrfs_root_used(&root->root_item));
+	static char i2x[]=3D"0123456789abcdef";
+	static int nchars[] =3D {4,2,2,2,6,0};
+	int	j;
+
+	for( j =3D 0 ; nchars[j] ; j++ ){
+		int	i;
+		for(i=3D0;i<nchars[j]; i++, uuid++){
+			*out++ =3D i2x[*uuid / 0x10];
+			*out++ =3D i2x[*uuid & 0x0f];
+		}
+		if(nchars[j+1])
+			*out++ =3D '-';
+	}
+	*out =3D 0;
 }
=20
=2Dstatic ssize_t root_block_limit_show(struct btrfs_root *root, char *buf)
+#define BTRFS_SYSFS_ATTR_SHOW_LLU(s, name, mode) \
+	BTRFS_SYSFS_ATTR_SHOW_LLU_EX(s, name, mode, name)
+
+#define BTRFS_SYSFS_ATTR_SHOW_LLU_EX(s, name, mode, param)                =
 \
+static ssize_t s##_##name##_show(struct s *obj, char *buf)                =
 \
+{                                                                         =
 \
+	return snprintf(buf, PAGE_SIZE, "%llu\n",                          \
+		(unsigned long long)obj->param);                           \
+}                                                                         =
 \
+static struct s##_attr s##_attr_##name =3D __ATTR(name, mode,             =
   \
+						s##_##name##_show, NULL)
+
+#define BTRFS_SYSFS_ATTR_SHOW_FUNC(s, name, mode)                         =
 \
+static ssize_t s##_##name##_show(struct s *obj, char *buf);               =
 \
+static struct s##_attr s##_attr_##name =3D __ATTR(name, mode,             =
   \
+						s##_##name##_show, NULL);  \
+static ssize_t s##_##name##_show(struct s *obj, char *buf)
+
+/* this is for super attrs (actual full fs) */
+struct btrfs_fs_info_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct btrfs_fs_info *, char *);
+	ssize_t (*store)(struct btrfs_fs_info *, const char *, size_t);
+};
+
+BTRFS_SYSFS_ATTR_SHOW_LLU_EX(btrfs_fs_info, num_devices, 0444,
+					 fs_devices->num_devices);
+BTRFS_SYSFS_ATTR_SHOW_LLU_EX(btrfs_fs_info, open_devices, 0444,
+					 fs_devices->open_devices);
+BTRFS_SYSFS_ATTR_SHOW_LLU_EX(btrfs_fs_info, rw_devices, 0444,
+					 fs_devices->rw_devices);
+BTRFS_SYSFS_ATTR_SHOW_LLU_EX(btrfs_fs_info, total_devices, 0444,
+					 super_copy.num_devices);
+BTRFS_SYSFS_ATTR_SHOW_FUNC(btrfs_fs_info, label, 0444)
 {
=2D	return snprintf(buf, PAGE_SIZE, "%llu\n",
=2D		(unsigned long long)btrfs_root_limit(&root->root_item));
+	strncpy(buf, obj->super_copy.label, PAGE_SIZE-2);
+	buf[PAGE_SIZE-2]=3D0;
+	strcat(buf,"\n");
+	return strlen(buf);
 }
=20
 static ssize_t super_blocks_used_show(struct btrfs_fs_info *fs, char *buf)
@@ -59,26 +112,6 @@ static ssize_t super_blocksize_show(struct btrfs_fs_inf=
o *fs, char *buf)
 		(unsigned long long)btrfs_super_sectorsize(&fs->super_copy));
 }
=20
=2D/* this is for root attrs (subvols/snapshots) */
=2Dstruct btrfs_root_attr {
=2D	struct attribute attr;
=2D	ssize_t (*show)(struct btrfs_root *, char *);
=2D	ssize_t (*store)(struct btrfs_root *, const char *, size_t);
=2D};
=2D
=2D#define ROOT_ATTR(name, mode, show, store) \
=2Dstatic struct btrfs_root_attr btrfs_root_attr_##name =3D __ATTR(name, mo=
de, \
=2D							      show, store)
=2D
=2DROOT_ATTR(blocks_used,	0444,	root_blocks_used_show,	NULL);
=2DROOT_ATTR(block_limit,	0644,	root_block_limit_show,	NULL);
=2D
=2Dstatic struct attribute *btrfs_root_attrs[] =3D {
=2D	&btrfs_root_attr_blocks_used.attr,
=2D	&btrfs_root_attr_block_limit.attr,
=2D	NULL,
=2D};
=2D
 /* this is for super attrs (actual full fs) */
 struct btrfs_super_attr {
 	struct attribute attr;
@@ -98,6 +131,11 @@ static struct attribute *btrfs_super_attrs[] =3D {
 	&btrfs_super_attr_blocks_used.attr,
 	&btrfs_super_attr_total_blocks.attr,
 	&btrfs_super_attr_blocksize.attr,
+	&btrfs_fs_info_attr_num_devices.attr,
+	&btrfs_fs_info_attr_open_devices.attr,
+	&btrfs_fs_info_attr_rw_devices.attr,
+	&btrfs_fs_info_attr_total_devices.attr,
+	&btrfs_fs_info_attr_label.attr,
 	NULL,
 };
=20
@@ -126,42 +164,13 @@ static ssize_t btrfs_super_attr_store(struct kobject =
*kobj,
 	return a->store ? a->store(fs, buf, len) : 0;
 }
=20
=2Dstatic ssize_t btrfs_root_attr_show(struct kobject *kobj,
=2D				    struct attribute *attr, char *buf)
=2D{
=2D	struct btrfs_root *root =3D container_of(kobj, struct btrfs_root,
=2D						root_kobj);
=2D	struct btrfs_root_attr *a =3D container_of(attr,
=2D						 struct btrfs_root_attr,
=2D						 attr);
=2D
=2D	return a->show ? a->show(root, buf) : 0;
=2D}
=2D
=2Dstatic ssize_t btrfs_root_attr_store(struct kobject *kobj,
=2D				     struct attribute *attr,
=2D				     const char *buf, size_t len)
=2D{
=2D	struct btrfs_root *root =3D container_of(kobj, struct btrfs_root,
=2D						root_kobj);
=2D	struct btrfs_root_attr *a =3D container_of(attr,
=2D						 struct btrfs_root_attr,
=2D						 attr);
=2D	return a->store ? a->store(root, buf, len) : 0;
=2D}
=2D
 static void btrfs_super_release(struct kobject *kobj)
 {
 	struct btrfs_fs_info *fs =3D container_of(kobj, struct btrfs_fs_info,
 						super_kobj);
+	printk("->complete(&fs->kobj_unregister)\n");
 	complete(&fs->kobj_unregister);
=2D}
=2D
=2Dstatic void btrfs_root_release(struct kobject *kobj)
=2D{
=2D	struct btrfs_root *root =3D container_of(kobj, struct btrfs_root,
=2D						root_kobj);
=2D	complete(&root->kobj_unregister);
+	printk("<-complete(&fs->kobj_unregister)\n");
 }
=20
 static const struct sysfs_ops btrfs_super_attr_ops =3D {
@@ -169,17 +178,6 @@ static const struct sysfs_ops btrfs_super_attr_ops =3D=
 {
 	.store	=3D btrfs_super_attr_store,
 };
=20
=2Dstatic const struct sysfs_ops btrfs_root_attr_ops =3D {
=2D	.show	=3D btrfs_root_attr_show,
=2D	.store	=3D btrfs_root_attr_store,
=2D};
=2D
=2Dstatic struct kobj_type btrfs_root_ktype =3D {
=2D	.default_attrs	=3D btrfs_root_attrs,
=2D	.sysfs_ops	=3D &btrfs_root_attr_ops,
=2D	.release	=3D btrfs_root_release,
=2D};
=2D
 static struct kobj_type btrfs_super_ktype =3D {
 	.default_attrs	=3D btrfs_super_attrs,
 	.sysfs_ops	=3D &btrfs_super_attr_ops,
@@ -187,83 +185,229 @@ static struct kobj_type btrfs_super_ktype =3D {
 };
=20
 /* /sys/fs/btrfs/ entry */
=2Dstatic struct kset *btrfs_kset;
+static struct kobject *btrfs_kobject=3DNULL;
+static struct kset *btrfs_devices_kset=3DNULL;
+static struct kset *btrfs_fs_kset=3DNULL;
=20
=2Dint btrfs_sysfs_add_super(struct btrfs_fs_info *fs)
+/*
+ * devices helper function
+ */
+struct btrfs_device_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct btrfs_device *, char *);
+	ssize_t (*store)(struct btrfs_device *, const char *, size_t);
+};
+
+BTRFS_SYSFS_ATTR_SHOW_FUNC(btrfs_device, fsid, 0444)
 {
=2D	int error;
=2D	char *name;
=2D	char c;
=2D	int len =3D strlen(fs->sb->s_id) + 1;
=2D	int i;
=2D
=2D	name =3D kmalloc(len, GFP_NOFS);
=2D	if (!name) {
=2D		error =3D -ENOMEM;
=2D		goto fail;
+	spin_lock(&obj->io_lock);
+	uuid_unparse(obj->fs_devices->fsid, buf);
+	spin_unlock(&obj->io_lock);
+	return 36;
+}
+BTRFS_SYSFS_ATTR_SHOW_FUNC(btrfs_device, minor, 0444)
+{
+	int	len;
+=09
+	if(!obj->bdev){
+		strcpy(buf,"none\n");
+		return 5;
 	}
+	spin_lock(&obj->io_lock);
+	len =3D snprintf(buf, PAGE_SIZE, "%llu\n",
+		(unsigned long long)MINOR(obj->bdev->bd_dev));
+	spin_unlock(&obj->io_lock);
+	return len;
+}
+BTRFS_SYSFS_ATTR_SHOW_FUNC(btrfs_device, major, 0444)
+{
+	int	len;
=20
=2D	for (i =3D 0; i < len; i++) {
=2D		c =3D fs->sb->s_id[i];
=2D		if (c =3D=3D '/' || c =3D=3D '\\')
=2D			c =3D '!';
=2D		name[i] =3D c;
+	if(!obj->bdev){
+		strcpy(buf,"none\n");
+		return 5;
 	}
=2D	name[len] =3D '\0';
+	spin_lock(&obj->io_lock);
+	len =3D snprintf(buf, PAGE_SIZE, "%llu\n",
+		(unsigned long long)MAJOR(obj->bdev->bd_dev));
+	spin_unlock(&obj->io_lock);
+	return len;
+}
+BTRFS_SYSFS_ATTR_SHOW_FUNC(btrfs_device, name, 0444)
+{
+	int	len=3D0;
+
+	spin_lock(&obj->io_lock);
+=09
+	if(obj->bdev){
+		len =3D snprintf(buf, PAGE_SIZE, "%d/%d\n",
+				MAJOR(obj->bdev->bd_dev),
+				MINOR(obj->bdev->bd_dev));
+		goto exit;
+	}
+	if(!obj->name)
+		goto exit;
+	strncpy(buf, obj->name,PAGE_SIZE-1);
+	buf[PAGE_SIZE-1]=3D0;
+	len =3D strlen(obj->name);
+
+exit:
+	spin_unlock(&obj->io_lock);
+	return len;
+}
+BTRFS_SYSFS_ATTR_SHOW_LLU(btrfs_device, devid,	 0444);
+BTRFS_SYSFS_ATTR_SHOW_LLU(btrfs_device, writeable,	 0444);
+BTRFS_SYSFS_ATTR_SHOW_LLU(btrfs_device, bytes_used,	 0444);
+BTRFS_SYSFS_ATTR_SHOW_LLU(btrfs_device, total_bytes, 0444);
+BTRFS_SYSFS_ATTR_SHOW_LLU(btrfs_device, disk_total_bytes, 0444);
+BTRFS_SYSFS_ATTR_SHOW_FUNC(btrfs_device, status, 0444)
+{
+	return snprintf(buf, PAGE_SIZE, obj->bdev ? "online\n" : "offline\n");
+}
=20
=2D	fs->super_kobj.kset =3D btrfs_kset;
=2D	error =3D kobject_init_and_add(&fs->super_kobj, &btrfs_super_ktype,
+static struct attribute *btrfs_device_attrs[] =3D {
+	&btrfs_device_attr_fsid.attr,
+	&btrfs_device_attr_devid.attr,
+	&btrfs_device_attr_writeable.attr,
+	&btrfs_device_attr_minor.attr,
+	&btrfs_device_attr_major.attr,
+	&btrfs_device_attr_total_bytes.attr,
+	&btrfs_device_attr_bytes_used.attr,
+	&btrfs_device_attr_disk_total_bytes.attr,
+	&btrfs_device_attr_name.attr,
+	&btrfs_device_attr_status.attr,
+	NULL,
+};
+
+static ssize_t btrfs_device_attr_show(struct kobject *kobj,
+				    struct attribute *attr, char *buf)
+{
+	struct btrfs_device *dev =3D container_of(kobj, struct btrfs_device,
+						device_kobj);
+	struct btrfs_device_attr *a =3D container_of(attr,
+						 struct btrfs_device_attr,
+						 attr);
+
+	return a->show ? a->show(dev, buf) : 0;
+}
+
+static ssize_t btrfs_device_attr_store(struct kobject *kobj,
+				     struct attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct btrfs_device *dev =3D container_of(kobj, struct btrfs_device,
+						device_kobj);
+	struct btrfs_device_attr *a =3D container_of(attr,
+						 struct btrfs_device_attr,
+						 attr);
+	return a->store ? a->store(dev, buf, len) : 0;
+}
+
+
+static const struct sysfs_ops btrfs_device_attr_ops =3D {
+	.show	=3D btrfs_device_attr_show,
+	.store	=3D btrfs_device_attr_store,
+};
+
+static void btrfs_device_release(struct kobject *kobj)
+{
+	struct btrfs_device *dev =3D container_of(kobj, struct btrfs_device,
+						device_kobj);
+	complete(&dev->kobj_unregister);
+}
+
+static struct kobj_type btrfs_device_ktype =3D {
+	.default_attrs	=3D btrfs_device_attrs,
+	.sysfs_ops	=3D &btrfs_device_attr_ops,
+	.release	=3D btrfs_device_release,
+};
+
+int btrfs_sysfs_add_device(struct btrfs_device *dev)
+{
+	int error =3D 0;
+	char name[37];
+
+	uuid_unparse(dev->uuid, name);
+
+	dev->device_kobj.kset =3D btrfs_devices_kset;
+	error =3D kobject_init_and_add(&dev->device_kobj, &btrfs_device_ktype,
 				     NULL, "%s", name);
=2D	kfree(name);
+	init_completion(&dev->kobj_unregister);
 	if (error)
=2D		goto fail;
+		printk(KERN_ERR "btrfs: sysfs creation for devices failed\n");
=20
=2D	return 0;
=2D
=2Dfail:
=2D	printk(KERN_ERR "btrfs: sysfs creation for super failed\n");
+	printk("dev->name =3D %s; dev->bdev =3D 0x%p\n",
+	       dev->name, dev->bdev);
 	return error;
+
 }
+void btrfs_sysfs_del_device(struct btrfs_device *dev)
+{
+	printk("btrfs_sysfs_del_device\n");
=20
=2Dint btrfs_sysfs_add_root(struct btrfs_root *root)
+	kobject_put(&dev->device_kobj);
+	wait_for_completion(&dev->kobj_unregister);
+}
+int btrfs_sysfs_add_super(struct btrfs_fs_info *fs)
 {
 	int error;
+	char name[37];
+
+	printk("btrfs_sysfs_add_super\n");
+=09
+	uuid_unparse(fs->fsid, name);
=20
=2D	error =3D kobject_init_and_add(&root->root_kobj, &btrfs_root_ktype,
=2D				     &root->fs_info->super_kobj,
=2D				     "%s", root->name);
+	fs->super_kobj.kset =3D btrfs_fs_kset;
+	error =3D kobject_init_and_add(&fs->super_kobj, &btrfs_super_ktype,
+				     NULL, "%s", name);
 	if (error)
 		goto fail;
=20
 	return 0;
=20
 fail:
=2D	printk(KERN_ERR "btrfs: sysfs creation for root failed\n");
+	printk(KERN_ERR "btrfs: sysfs creation for super failed\n");
 	return error;
 }
=20
=2Dvoid btrfs_sysfs_del_root(struct btrfs_root *root)
=2D{
=2D	kobject_put(&root->root_kobj);
=2D	wait_for_completion(&root->kobj_unregister);
=2D}
=2D
 void btrfs_sysfs_del_super(struct btrfs_fs_info *fs)
 {
+	printk("btrfs_sysfs_del_super\n");
+=09
 	kobject_put(&fs->super_kobj);
+	printk("->wait_for_completion(&fs->kobj_unregister)\n");
 	wait_for_completion(&fs->kobj_unregister);
+	printk("<-wait_for_completion(&fs->kobj_unregister)\n");
 }
=20
 int btrfs_init_sysfs(void)
 {
=2D	btrfs_kset =3D kset_create_and_add("btrfs", NULL, fs_kobj);
=2D	if (!btrfs_kset)
+	printk("start init btrfs-syfs\n");
+	btrfs_kobject =3D kobject_create_and_add("btrfs", fs_kobj);
+	if (!btrfs_kobject){
+		printk("Not enough memory\n");
+		return -ENOMEM;
+	}
+	btrfs_devices_kset =3D kset_create_and_add("devices", NULL, btrfs_kobject=
);
+	if (!btrfs_devices_kset){
+		btrfs_exit_sysfs();
 		return -ENOMEM;
+	}
+	btrfs_fs_kset =3D kset_create_and_add("filesystems", NULL, btrfs_kobject);
+	if (!btrfs_fs_kset){
+		btrfs_exit_sysfs();
+		return -ENOMEM;
+	}
 	return 0;
 }
=20
 void btrfs_exit_sysfs(void)
 {
=2D	kset_unregister(btrfs_kset);
+	printk("exit sysfs\n");
+	if(btrfs_fs_kset) kset_unregister(btrfs_fs_kset);
+	if(btrfs_devices_kset) kset_unregister(btrfs_devices_kset);
+	if(btrfs_kobject) kobject_put(btrfs_kobject);
+	btrfs_kobject=3DNULL;
+	btrfs_fs_kset=3Dbtrfs_devices_kset=3DNULL;
 }
=20
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc04dc1..61f348b 100644
=2D-- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -31,6 +31,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "async-thread.h"
+#include "sysfs.h"
=20
 struct map_lookup {
 	u64 type;
@@ -82,6 +83,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_d=
evices)
 		device =3D list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
+		btrfs_sysfs_del_device(device);
 		kfree(device->name);
 		kfree(device);
 	}
@@ -412,6 +414,9 @@ static noinline int device_list_add(const char *path,
=20
 		device->fs_devices =3D fs_devices;
 		fs_devices->num_devices++;
+
+		btrfs_sysfs_add_device(device);
+	=09
 	} else if (strcmp(device->name, path)) {
 		name =3D kstrdup(path, GFP_NOFS);
 		if (!name)
@@ -468,6 +473,12 @@ static struct btrfs_fs_devices *clone_fs_devices(struc=
t btrfs_fs_devices=20
*orig)
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices =3D fs_devices;
 		fs_devices->num_devices++;
+
+		/* TODO: these code means that may exists two devices with the
+		 * same UUID ?
+		 */
+		btrfs_sysfs_add_device(device);
+	=09
 	}
 	mutex_unlock(&orig->device_list_mutex);
 	return fs_devices;
@@ -488,6 +499,8 @@ again:
 		if (device->in_fs_metadata)
 			continue;
=20
+
+		btrfs_sysfs_del_device(device);
 		if (device->bdev) {
 			close_bdev_exclusive(device->bdev, device->mode);
 			device->bdev =3D NULL;
@@ -1224,7 +1237,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *de=
vice_path)
 		goto error_brelse;
=20
 	device->in_fs_metadata =3D 0;
=2D
+	btrfs_sysfs_del_device(device);
 	/*
 	 * the device list mutex makes sure that we don't change
 	 * the device list while someone else is writing out all
@@ -1561,6 +1574,7 @@ int btrfs_init_new_device(struct btrfs_root *root, ch=
ar *device_path)
 		ret =3D btrfs_relocate_sys_chunks(root);
 		BUG_ON(ret);
 	}
+	btrfs_sysfs_add_device(device); /* FIXME: check the error */
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
 	return ret;
@@ -3084,6 +3098,9 @@ static struct btrfs_device *add_missing_dev(struct bt=
rfs_root *root,
 	spin_lock_init(&device->io_lock);
 	INIT_LIST_HEAD(&device->dev_alloc_list);
 	memcpy(device->uuid, dev_uuid, BTRFS_UUID_SIZE);
+
+	btrfs_sysfs_add_device(device);
+		=09
 	return device;
 }
=20
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2b638b6..8e16b7f 100644
=2D-- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -82,6 +82,10 @@ struct btrfs_device {
 	u8 uuid[BTRFS_UUID_SIZE];
=20
 	struct btrfs_work work;
+=09
+	/* sysfs stuff */
+	struct kobject	device_kobj;
+	struct completion kobj_unregister;
 };
=20
 struct btrfs_fs_devices {






--nextPart1854750.XnVj4qHUh6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBM2D3QvwTxYT3FBRIRAjuHAJ9w+a7lujGVVPmt5enqWhx92s2XaACggrcy
hDB0YXwbNSc0DG+pUthN5DM=
=IowB
-----END PGP SIGNATURE-----

--nextPart1854750.XnVj4qHUh6--
