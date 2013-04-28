Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:56325 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3D1Kjw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Apr 2013 06:39:52 -0400
Received: by mail-da0-f50.google.com with SMTP id a4so2506008dad.23
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2013 03:39:52 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH RFC] btrfs-progs: don't allow to delete default subvolume
Date: Sun, 28 Apr 2013 18:39:28 +0800
Message-Id: <1367145568-3813-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Default subvolume set via 'set-default' command can be deleted now

    # Create btrfs and a subvolume
    [root@localhost ~]# mkfs -t btrfs /dev/sda5
    [root@localhost ~]# mount /dev/sda5 /mnt/btrfs
    [root@localhost ~]# btrfs sub create /mnt/btrfs/vol_1
    Create subvolume '/mnt/btrfs/vol_1'
    [root@localhost ~]# btrfs sub list -a /mnt/btrfs
    ID 256 gen 7 top level 5 path vol_1

    # Set subvolid 256 as default volume
    [root@localhost ~]# btrfs sub set-default 256 /mnt/btrfs
    [root@localhost ~]# btrfs sub get-default /mnt/btrfs/
    ID 256 gen 5 top level 5 path vol_1

    # Delete it
    [root@localhost ~]# btrfs sub delete /mnt/btrfs/vol_1/
    Delete subvolume '/mnt/btrfs/vol_1'
    # list shows nothing
    [root@localhost ~]# btrfs sub list -a /mnt/btrfs

    # mount default subvolume failed, it's been deleted
    [root@localhost ~]# umount /mnt/btrfs
    [root@localhost ~]# mount /dev/sda5 /mnt/btrfs
    mount: mount(2) failed: No such file or directory

    # Have to specify which subvolume to mount
    [root@localhost ~]# mount -o subvol=/ /dev/sda5 /mnt/btrfs

It makes more sense to prevent deleting default subvolume.

Also fix some code style issues and magical return values.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-subvolume.c | 58 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 74e2130..00712c3 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -198,10 +198,11 @@ static const char * const cmd_subvol_delete_usage[] = {
 
 static int cmd_subvol_delete(int argc, char **argv)
 {
-	int	res, fd, len, e, cnt = 1, ret = 0;
+	int	res, fd, vol_fd, len, e, cnt = 1, ret = 1;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*path;
+	u64	default_id, root_id;
 
 	if (argc < 2)
 		usage(cmd_subvol_delete_usage);
@@ -210,29 +211,25 @@ again:
 	path = argv[cnt];
 
 	res = test_issubvolume(path);
-	if(res<0){
+	if (res < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", path);
-		ret = 12;
 		goto out;
 	}
-	if(!res){
+	if (!res) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", path);
-		ret = 13;
 		goto out;
 	}
 
-	cpath = realpath(path, 0);
+	cpath = realpath(path, NULL);
 	dname = strdup(cpath);
 	dname = dirname(dname);
 	vname = strdup(cpath);
 	vname = basename(vname);
 	free(cpath);
 
-	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
-	     strchr(vname, '/') ){
+	if (!strcmp(vname, ".") || !strcmp(vname, "..") || strchr(vname, '/')) {
 		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
 			vname);
-		ret = 14;
 		goto out;
 	}
 
@@ -240,31 +237,58 @@ again:
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
 			vname);
-		ret = 14;
 		goto out;
 	}
 
 	fd = open_file_or_dir(dname);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
-		ret = 12;
 		goto out;
 	}
 
+	res = btrfs_list_get_default_subvolume(fd, &default_id);
+	if (res) {
+		fprintf(stderr, "ERROR: can't perform the search - %s\n",
+			strerror(errno));
+		goto out_close;
+	}
+	if (default_id == 0) {
+		fprintf(stderr, "ERROR: 'default' dir item not found\n");
+		goto out_close;
+	}
+
+	vol_fd = open_file_or_dir(path);
+	if (vol_fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		goto out_close;
+	}
+	res = btrfs_list_get_path_rootid(vol_fd, &root_id);
+	close(vol_fd);
+	if (res)
+		goto out_close;
+
+	if (root_id == default_id) {
+		fprintf(stderr,
+			"Unable to delete current default subvolume '%s/%s'\n",
+			dname, vname);
+		goto out_close;
+	}
+
 	printf("Delete subvolume '%s/%s'\n", dname, vname);
 	strncpy_null(args.name, vname);
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 	e = errno;
 
-	close(fd);
-
-	if(res < 0 ){
-		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
+	if (res < 0) {
+		fprintf(stderr, "ERROR: cannot delete '%s/%s' - %s\n",
 			dname, vname, strerror(e));
-		ret = 11;
-		goto out;
+		ret = 1;
+		goto out_close;
 	}
 
+	ret = 0;
+out_close:
+	close(fd);
 out:
 	cnt++;
 	if (cnt < argc)
-- 
1.8.2.1

