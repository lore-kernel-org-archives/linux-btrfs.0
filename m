Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59830 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2JINZ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 09:25:59 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so4737167wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 06:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121009111830.GC31743@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
	<50733D66.5020600@gmx.net>
	<20121009111830.GC31743@campbell-lange.net>
Date: Tue, 9 Oct 2012 15:25:57 +0200
Message-ID: <CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
Subject: Re: btrfs receive to subdirectory
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Rory, Arne,
I think the problem is that currently mnt_fd in struct btrfs_receive
is used both as "mount root" and "directory in which the
subvolume/snapshot needs to be created".
Arne, does the following patch make sense? It uses Jan's
find_mount_root function. With this patch both Rory's tests seem to
work for me.

Thanks,
Alex.



diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..ed53326 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -52,11 +52,13 @@ static int g_verbose = 0;
 struct btrfs_receive
 {
 	int mnt_fd;
+	int dest_dir_fd;

 	int write_fd;
 	char *write_path;

 	char *root_path;
+	char *dest_dir_path; /* relative to root_path */
 	char *full_subvol_path;

 	struct subvol_info *cur_subvol;
@@ -150,8 +152,11 @@ static int process_subvol(const char *path, const
u8 *uuid, u64 ctransid,
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
 	r->parent_subvol = NULL;

-	r->cur_subvol->path = strdup(path);
-	r->full_subvol_path = path_cat(r->root_path, path);
+	if (strlen(r->dest_dir_path) == 0)
+		r->cur_subvol->path = strdup(path);
+	else
+		r->cur_subvol->path = path_cat(r->dest_dir_path, path);
+	r->full_subvol_path = path_cat3(r->root_path, r->dest_dir_path, path);

 	fprintf(stderr, "At subvol %s\n", path);

@@ -167,7 +172,7 @@ static int process_subvol(const char *path, const
u8 *uuid, u64 ctransid,

 	memset(&args_v1, 0, sizeof(args_v1));
 	strcpy(args_v1.name, path);
-	ret = ioctl(r->mnt_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
+	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: creating subvolume %s failed. "
@@ -195,8 +200,11 @@ static int process_snapshot(const char *path,
const u8 *uuid, u64 ctransid,
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
 	r->parent_subvol = NULL;

-	r->cur_subvol->path = strdup(path);
-	r->full_subvol_path = path_cat(r->root_path, path);
+	if (strlen(r->dest_dir_path) == 0)
+		r->cur_subvol->path = strdup(path);
+	else
+		r->cur_subvol->path = path_cat(r->dest_dir_path, path);
+	r->full_subvol_path = path_cat3(r->root_path, r->dest_dir_path, path);

 	fprintf(stderr, "At snapshot %s\n", path);

@@ -243,7 +251,7 @@ static int process_snapshot(const char *path,
const u8 *uuid, u64 ctransid,
 		goto out;
 	}

-	ret = ioctl(r->mnt_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
+	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
 	close(args_v2.fd);
 	if (ret < 0) {
 		ret = -errno;
@@ -790,17 +798,44 @@ struct btrfs_send_ops send_ops = {
 int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 {
 	int ret;
+	char *dest_dir_full_path;
 	int end = 0;

-	r->root_path = strdup(tomnt);
-	r->mnt_fd = open(tomnt, O_RDONLY | O_NOATIME);
+	dest_dir_full_path = realpath(tomnt, NULL);
+	if (!dest_dir_full_path) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: realpath(%s) failed. %s\n", tomnt,
+				strerror(-ret));
+		goto out;
+	}
+	r->dest_dir_fd = open(tomnt, O_RDONLY | O_NOATIME);
+	if (r->dest_dir_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to open destination directory %s.
%s\n", tomnt,
+				strerror(-ret));
+		goto out;
+	}
+	
+	ret = find_mount_root(tomnt, &r->root_path);
+	if (ret < 0) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: failed to determine mount point "
+				"for %s\n", tomnt);
+		goto out;
+	}
+	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
 	if (r->mnt_fd < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: failed to open %s. %s\n", tomnt,
+		fprintf(stderr, "ERROR: failed to open %s. %s\n", r->root_path,
 				strerror(-ret));
 		goto out;
 	}

+	/* Find the destination dir relative to mount root */
+	r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
+	if (r->dest_dir_path[0] == '/')
+		r->dest_dir_path++;
+		
 	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
 	if (ret < 0)
 		return ret;
diff --git a/send-utils.h b/send-utils.h
index da407eb..a3e038b 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -65,5 +65,6 @@ void subvol_uuid_search_add(struct subvol_uuid_search *s,
 char *path_cat(const char *p1, const char *p2);
 char *path_cat3(const char *p1, const char *p2, const char *p3);

+int find_mount_root(const char *path, char **mount_root);

 #endif /* SEND_UTILS_H_ */









On Tue, Oct 9, 2012 at 1:18 PM, Rory Campbell-Lange
<rory@campbell-lange.net> wrote:
> On 08/10/12, Arne Jansen (sensille@gmx.net) wrote:
>> On 10/08/12 18:30, Rory Campbell-Lange wrote:
>> > I can send snapshots to <volume>, but not <volume>/<dir>. Please advise
>> > if what I am doing is incorrect.
>
>> > Try and snap to /mnt/<subdir>
>> >     root@orchard:/bkp# mkdir /mnt/snaps
>> >     root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt/snaps
>> >     > At subvol snaps/snap_081012_1715
>> >     > At subvol snap_081012_1715
>> >     root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
>> >                        snaps/snap_081012_1716 | btrfs receive /mnt/snaps
>> >     > At subvol snaps/snap_081012_1716
>> >     > At snapshot snap_081012_1716
>> >     > ERROR: open snaps/snap_081012_1715 failed. No such file or directory
>> >     root@orchard:/bkp# ls /mnt/snaps
>> >     > snap_081012_1715
>>
>> The target has to be a subvol also. But interestingly enough, it also
>> fails for a subvol. The base send works, the incremental fails, because
>> btrfs receive can't find snaps/snap_081012_1715. If you give /mnt/snaps
>> as the target for the base and just /mnt for the incremental, it works.
>> There's clearly something broken there...
>
> Actually, this does work:
>
>     root@orchard:~# mkfs.btrfs /dev/sdb1
>         ...snip...
>         > Btrfs v0.20-rc1-37-g91d9eec
>     root@orchard:/bkp# ls
>         > snaps  subvol
>     root@orchard:/bkp# mount /dev/sdb1 /mnt
>     root@orchard:/bkp# btrfs subvolume create /mnt/subvol
>         > Create subvolume '/mnt/subvol'
>     root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt/subvol
>         > At subvol snaps/snap_081012_1715
>         > At subvol snap_081012_1715
>     root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
>                              snaps/snap_081012_1716 | btrfs receive /mnt/subvol
>         > At subvol snaps/snap_081012_1716
>         > At snapshot snap_081012_1716
>
> It certainly seems to work if the receive target is a subvolume other
> than the implicit subvolume at the root of the mount point.
>
> So one can only btrfs receive to a subvolume, which makes sense, and is
> I believe the reason one cannot 'btrfs receive to a subdirectory' as set
> out in the subject of my original email.
>
> Are there any other problem cases you can see, Arne?
>
> Regards
> Rory
>
> --
> Rory Campbell-Lange
> rory@campbell-lange.net
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
