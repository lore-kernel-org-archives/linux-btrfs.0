From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [RFC][BTRFS-PROG] Avoid to scan cdrom and floppy
Date: Wed, 15 Jun 2011 22:28:58 +0200
Message-ID: <4DF9160A.4020102@libero.it>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

thanks to the last Hugo's email, I restart to work on the patch which 
avoid to scan cdrom and floppy during a "btrfs filesystem show" and a 
"btrfs device scan". Comparing to my previous patch I modified the 
strategy, and now the scan of the devices is based on the content of the 
file /proc/partitions. The old behavior may be set  passing the 
"--all-devices" options.

I resend as RFC, because this change may be incompatible with the old 
behavior. Frankly speaking I don't see any problem, but I think that it 
is better to discuss in the mailing list.

You can pull the patch also from
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
	scan-proc-partitions

Comment are welcome

The diff is computed against the Hugo's repository

  btrfs.c        |    4 +-
  btrfs_cmds.c   |   47 ++++++++++++++++++++++++++++++++++++++++----
  man/btrfs.8.in |   26 +++++++++++++++---------
  utils.c        |   58 +++++++++++++++++++++++++++++++++++++++++++++++++
  utils.h        |    2 +
  5 files changed, 120 insertions(+), 17 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 87cc680..c6ae692 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -104,7 +104,7 @@ static struct Command commands[] = {
           NULL
         },
         { do_show_filesystem, 999,
-         "filesystem show", "[<device>|<uuid>|<label>]\n"
+         "filesystem show", "[--all-devices][<uuid>|<label>]\n"
                 "Show the info of a btrfs filesystem. If no argument\n"
                 "is passed, info of all the btrfs filesystem are shown.",
           NULL
@@ -157,7 +157,7 @@ static struct Command commands[] = {
                 "Cancel the balance operation running on <path>."
         },
         { do_scan,
-         999, "device scan", "[<device> [<device>..]\n"
+         999, "device scan", "[--all-devices|<device> [<device>..]\n"
                 "Scan all device for or the passed device for a btrfs\n"
                 "filesystem.",
           NULL
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 062e7d7..21b1dd5 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -590,11 +590,29 @@ int do_fssync(int argc, char **argv)
  int do_scan(int argc, char **argv)
  {
         int     i, fd, e;
-       if(argc<=1){
+       int     checklist = 1;
+       int     devstart = 1;
+
+       if( argc >= 2 && !strcmp(argv[1],"--all-devices")){
+
+               if( argc >2 ){
+                       fprintf(stderr, "ERROR: too may arguments\n");
+                        return 22;
+                }
+
+               checklist = 0;
+               devstart += 1;
+       }
+
+       if(argc<=devstart){
+
                 int ret;

                 printf("Scanning for Btrfs filesystems\n");
ghigo@venice:~/btrfs/btrfs-progs-unstable$ git diff 
integration-hugo-mills | cat
diff --git a/btrfs.c b/btrfs.c
index 87cc680..c6ae692 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -104,7 +104,7 @@ static struct Command commands[] = {
           NULL
         },
         { do_show_filesystem, 999,
-         "filesystem show", "[<device>|<uuid>|<label>]\n"
+         "filesystem show", "[--all-devices][<uuid>|<label>]\n"
                 "Show the info of a btrfs filesystem. If no argument\n"
                 "is passed, info of all the btrfs filesystem are shown.",
           NULL
@@ -157,7 +157,7 @@ static struct Command commands[] = {
                 "Cancel the balance operation running on <path>."
         },
         { do_scan,
-         999, "device scan", "[<device> [<device>..]\n"
+         999, "device scan", "[--all-devices|<device> [<device>..]\n"
                 "Scan all device for or the passed device for a btrfs\n"
                 "filesystem.",
           NULL
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 062e7d7..21b1dd5 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -590,11 +590,29 @@ int do_fssync(int argc, char **argv)
  int do_scan(int argc, char **argv)
  {
         int     i, fd, e;
-       if(argc<=1){
+       int     checklist = 1;
+       int     devstart = 1;
+
+       if( argc >= 2 && !strcmp(argv[1],"--all-devices")){
+
+               if( argc >2 ){
+                       fprintf(stderr, "ERROR: too may arguments\n");
+                        return 22;
+                }
+
+               checklist = 0;
+               devstart += 1;
+       }
+
+       if(argc<=devstart){
+
                 int ret;

                 printf("Scanning for Btrfs filesystems\n");
-               ret = btrfs_scan_one_dir("/dev", 1);
+               if(checklist)
+                       ret = btrfs_scan_block_devices(1);
+               else
+                       ret = btrfs_scan_one_dir("/dev", 1);
                 if (ret){
                         fprintf(stderr, "ERROR: error %d while 
scanning\n", ret);
                         return 18;
@@ -608,7 +626,7 @@ int do_scan(int argc, char **argv)
                 return 10;
         }

-       for( i = 1 ; i < argc ; i++ ){
+       for( i = devstart ; i < argc ; i++ ){
                 struct btrfs_ioctl_vol_args args;
                 int ret;

@@ -731,14 +749,33 @@ int do_show_filesystem(int argc, char **argv)
         struct list_head *all_uuids;
         struct btrfs_fs_devices *fs_devices;
         struct list_head *cur_uuid;
-       char *search = argv[1];
+       char *search = 0;
         int ret;
+       int checklist = 1;
+       int searchstart = 1;
+
+       if( argc >= 2 && !strcmp(argv[1],"--all-devices")){
+               checklist = 0;
+               searchstart += 1;
+       }
+
+       if( argc > searchstart+1 ){
+               fprintf(stderr, "ERROR: too many arguments\n");
+               return 22;
+       }
+
+       if(checklist)
+               ret = btrfs_scan_block_devices(0);
+       else
+               ret = btrfs_scan_one_dir("/dev", 0);

-       ret = btrfs_scan_one_dir("/dev", 0);
         if (ret){
                 fprintf(stderr, "ERROR: error %d while scanning\n", ret);
                 return 18;
         }
+
+       if(searchstart < argc)
+               search = argv[searchstart];

         all_uuids = btrfs_scanned_uuids();
         list_for_each(cur_uuid, all_uuids) {
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index cd436f9..91663e5 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -22,6 +22,7 @@ btrfs \- control a btrfs filesystem
  \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
  .PP
  \fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> 
[<file>|<dir>...]\fP
+.PP
  \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
  .PP
  \fBbtrfs\fP \fBfilesystem balance\fP [\fB-wcv\fP] [\fB--wait\fP] 
[\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] 
\fI<path>\fP
@@ -34,9 +35,9 @@ btrfs \- control a btrfs filesystem
  .PP
  \fBbtrfs\fP \fBfilesystem defragment\fP\fI <file>|<dir> 
[<file>|<dir>...]\fP
  .PP
-\fBbtrfs\fP \fBdevice scan\fP\fI [<device>...]\fP
+\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
  .PP
-\fBbtrfs\fP \fBdevice show\fP\fI [<device>|<uuid>|<label>]\fP
+\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
  .PP
  \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
  .PP
@@ -148,11 +149,6 @@ use it if you use snapshots, have de-duplicated 
your data or made copies with
  List the recently modified files in a subvolume, after 
\fI<last_gen>\fR ID.
  .TP

-\fBdevice scan\fR \fI[<device>...]\fR
-Scan devices for a btrfs filesystem. If no devices are passed, 
\fBbtrfs\fR scans
-all the block devices.
-.TP
-
  \fBfilesystem sync\fR\fI <path> \fR
  Force a sync for the filesystem identified by \fI<path>\fR.
  .TP
@@ -197,9 +193,11 @@ NOTE: Currently there are the following limitations:
  - the filesystem should not have more than one device.
  .TP

-\fBfilesystem show\fR [<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no UUID or label is
-passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
+Show the btrfs filesystem with some additional info. If no \fIUUID\fP or
+\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
+otherwise the devices list is extracted from the /proc/partitions file.
  .TP

  \fBdevice balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] 
[\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
@@ -224,6 +222,14 @@ Add device(s) to the filesystem identified by 
\fI<path>\fR.
  Remove device(s) from a filesystem identified by \fI<path>\fR.
  .TP

+\fBdevice scan\fR \fI[--all-devices|<device> [<device>...]\fR
+If one or more devices are passed, these are scanned for a btrfs 
filesystem.
+If no devices are passed, \fBbtrfs\fR scans all the block devices listed
+in the /proc/partitions file.
+Finally, if \fB--all-devices\fP is passed, all the devices under /dev are
+scanned.
+.TP
+
  \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
  Start a scrub on all devices of the filesystem identified by 
\fI<path>\fR or on
  a single \fI<device>\fR. Without options, scrub is started as a background
diff --git a/utils.c b/utils.c
index da54b75..c4f3fd1 100644
--- a/utils.c
+++ b/utils.c
@@ -1114,3 +1114,61 @@ int check_label(char *input)

         return 0;
  }
+
+int btrfs_scan_block_devices(int run_ioctl)
+{
+
+       struct stat st;
+       int ret;
+       int fd;
+       struct btrfs_fs_devices *tmp_devices;
+       u64 num_devices;
+       FILE *proc_partitions;
+       int i;
+       char buf[1024];
+       char fullpath[110];
+
+       proc_partitions = fopen("/proc/partitions","r");
+       if (!proc_partitions) {
+               fprintf(stderr, "Unable to open '/proc/partitions' for 
scanning\n");
+               return -ENOENT;
+       }
+       /* skip the header */
+       for(i=0; i < 2 ; i++)
+               if(!fgets(buf, 1023, proc_partitions)){
+               fprintf(stderr, "Unable to read '/proc/partitions' for 
scanning\n");
+               fclose(proc_partitions);
+               return -ENOENT;
+       }
+
+       strcpy(fullpath,"/dev/");
+       while(fgets(buf, 1023, proc_partitions)) {
+
+               i = sscanf(buf," %*d %*d %*d %99s", fullpath+5);
+               ret = lstat(fullpath, &st);
+               if (ret < 0) {
+                       fprintf(stderr, "failed to stat %s\n", fullpath);
+                       continue;
+               }
+               if (!S_ISBLK(st.st_mode)) {
+                       continue;
+               }
+
+               fd = open(fullpath, O_RDONLY);
+               if (fd < 0) {
+                       fprintf(stderr, "failed to read %s\n", fullpath);
+                       continue;
+               }
+               ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
+                                           &num_devices,
+                                           BTRFS_SUPER_INFO_OFFSET);
+               if (ret == 0 && run_ioctl > 0) {
+                       btrfs_register_one_device(fullpath);
+               }
+               close(fd);
+       }
+
+       fclose(proc_partitions);
+       return 0;
+}
+
diff --git a/utils.h b/utils.h
index 167021a..0d7ba43 100644
--- a/utils.h
+++ b/utils.h
@@ -44,4 +44,6 @@ int btrfs_device_already_in_root(struct btrfs_root 
*root, int fd,
  char *pretty_sizes(u64 size);
  int check_label(char *input);
  int get_mountpt(char *dev, char *mntpt, size_t size);
+
+int btrfs_scan_block_devices(int run_ioctl);
  #endif
