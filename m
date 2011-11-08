From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/7][V2] btrfs-progs:  Add info for the commands.
Date: Tue, 08 Nov 2011 23:12:20 +0100
Message-ID: <7596355.m5Q0DHrRsP@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart8209272.oigRUo4nIC"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart8209272.oigRUo4nIC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"



Add info for every btrfs sub-commands in the sources.

Signed off by: Goffredo Baroncelli <kreijack@inwind.it>
---
 btrfs_cmds.c |  254 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub.c      |   79 ++++++++++++++++++
 2 files changed, 333 insertions(+), 0 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..517b0de 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -155,6 +155,42 @@ static int parse_compress_type(char *s)
 	};
 }
 
+
+/**** man: btrfs filesystem defragment
+ * 
+ * \Bbtrfs\b \Bfilesystem defragment\b -c[zlib|lzo] [-l \Ilen\i] [-s 
\Istart\i] [-t \Isize\i] -[vf] <\Ifile\i>|<\Idir\i> [<\Ifile\i>|<\Idir\i>...]
+ * 
+ * Defragment a file or a directory.
+ * 
+ * Defragment file data and/or directory metadata. To defragment all files in a
+ * directory you have to specify each one on its own or use your shell 
+ * wildcards.
+ * 
+ * The start position and the number of bytes to deframention can be specified 
+ * by \Istart\i and \Ilen\i. Any extent bigger than \Ithresh\i will be 
+ * considered already defragged. Use 0 to take the kernel default, and use 1 
+ * to say eveery single extent must be rewritten. You can also turn on 
+ * compression in defragment operations.
+ * 
+ * \B-v\b be verbose
+ * 
+ * \B-c\b compress file contents while defragmenting
+ * 
+ * \B-f\b flush filesystem after defragmenting
+ * 
+ * \B-s start\b defragment only from byte \Istart\i onward
+ * 
+ * \B-l len\b defragment only up to \Ilen\i bytes
+ * 
+ * \B-t size\b defragment only files at least \Isize\i bytes big
+ * 
+ * NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of 
+ * data, don't use it if you use snapshots, have de-duplicated your data or 
+ * made copies with 
+ *
+ * \Bcp --reflink\b.
+ ****/
+
 int do_defrag(int ac, char **av)
 {
 	int fd;
@@ -267,6 +303,16 @@ int do_defrag(int ac, char **av)
 	return errors + 20;
 }
 
+
+/**** man: btrfs subvolume find-new
+ * 
+ * \Bbtrfs\b \Bsubvolume find-new\b\I <subvolume> <last_gen>\i
+ * 
+ * List the recently modified files in a filesystem.
+ * 
+ * List the recently modified files in a subvolume, after \I<last_gen>\i ID.
+ ****/
+
 int do_find_newer(int argc, char **argv)
 {
 	int fd;
@@ -298,6 +344,25 @@ int do_find_newer(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs subvolume list
+ * 
+ * \Bbtrfs\b \Bsubvolume list\b\I [-p] <path>\i
+ * 
+ * List the snapshot/subvolume of a filesystem.
+ * 
+ * List the subvolumes present in the filesystem \I<path>\i. For every
+ * subvolume the following information is shown by default.
+ * ID <ID> top level <ID> path <path>
+ * where path is the relative path of the subvolume to the \Itop level\i
+ * subvolume.
+ * The subvolume's ID may be used by the \Bsubvolume set-default\b command, 
or
+ * at mount time via the \Isubvol=\i option.
+ * If \I-p\i is given, then \Iparent <ID>\i is added to the output between ID
+ * and top level. The parent's ID may be used at mount time via the
+ * \Isubvolrootid=\i option.
+ ****/
+
 int do_subvol_list(int argc, char **argv)
 {
 	int fd;
@@ -345,6 +410,20 @@ int do_subvol_list(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs subvolume snapshot
+ * 
+ * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] <source> [<dest>/]<name>\i
+ * 
+ * Create a writable/readonly snapshot of the subvolume <source> with
+ * the name <name> in the <dest> directory.
+ * 
+ * Create a writable/readonly snapshot of the subvolume \I<source>\i with the
+ * name \I<name>\i in the \I<dest>\i directory. If \I<source>\i is not a
+ * subvolume, \Bbtrfs\b returns an error. If \I-r\i is given, the snapshot
+ * will be readonly.
+ ****/
+
 int do_clone(int argc, char **argv)
 {
 	char	*subvol, *dst;
@@ -462,6 +541,17 @@ int do_clone(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs subvolume delete
+ * 
+ * \Bbtrfs\b \Bsubvolume delete\b\I <subvolume>\i
+ * 
+ * Delete the subvolume <subvolume>.
+ * 
+ * Delete the subvolume \I<subvolume>\i. If \I<subvolume>\i is not a
+ * subvolume, \Bbtrfs\b returns an error.
+ ****/
+
 int do_delete_subvolume(int argc, char **argv)
 {
 	int	res, fd, len, e;
@@ -524,6 +614,18 @@ int do_delete_subvolume(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs subvolume create
+ * 
+ * \Bbtrfs\b \Bsubvolume create\b\I [<dest>/]<name>\i
+ * 
+ * Create a subvolume in <dest> (or the current directory if
+ * not passed).
+ * 
+ * Create a subvolume in \I<dest>\i (or in the current directory if
+ * \I<dest>\i is omitted).
+ ****/
+
 int do_create_subvol(int argc, char **argv)
 {
 	int	res, fddst, len, e;
@@ -580,6 +682,16 @@ int do_create_subvol(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs filesystem sync
+ * 
+ * \Bbtrfs\b \Bfilesystem sync\b\I <path> \i
+ * 
+ * Force a sync on the filesystem <path>.
+ * 
+ * Force a sync for the filesystem identified by \I<path>\i.
+ ****/
+
 int do_fssync(int argc, char **argv)
 {
 	int 	fd, res, e;
@@ -604,6 +716,21 @@ int do_fssync(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs device scan
+ * 
+ * \Bbtrfs\b \Bdevice scan\b \I[--all-devices|<device> [<device>...]\i
+ * 
+ * Scan all device for or the passed device for a btrfs
+ * filesystem.
+ * 
+ * If one or more devices are passed, these are scanned for a btrfs 
filesystem. 
+ * If no devices are passed, \Bbtrfs\b scans all the block devices listed
+ * in the /proc/partitions file.
+ * Finally, if \B--all-devices\b is passed, all the devices under /dev are 
+ * scanned.
+ ****/
+
 int do_scan(int argc, char **argv)
 {
 	int	i, fd, e;
@@ -671,6 +798,32 @@ int do_scan(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs filesystem resize
+ * 
+ * \Bbtrfs\b \Bfilesystem resize\b\I [+/\-]<size>[gkm]|max <path>\i
+ * 
+ * Resize the file system. If 'max' is passed, the filesystem
+ * will occupe all available space on the device.
+ * 
+ * Resize a filesystem identified by \I<path>\i.
+ * The \I<size>\i parameter specifies the new size of the filesystem.
+ * If the prefix \I+\i or \I\-\i is present the size is increased or decreased
+ * by the quantity \I<size>\i.
+ * If no units are specified, the unit of the \I<size>\i parameter defaults to
+ * bytes. Optionally, the size parameter may be suffixed by one of the 
following
+ * the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or 
gigabytes,
+ * respectively.
+ * 
+ * If 'max' is passed, the filesystem will occupy all available space on the
+ * volume(s).
+ * 
+ * The \Bresize\b command \Bdoes not\b manipulate the size of underlying
+ * partition.  If you wish to enlarge/reduce a filesystem, you must make sure
+ * you can expand the partition before enlarging the filesystem and shrink the
+ * partition after reducing the size of the filesystem.
+ ****/
+
 int do_resize(int argc, char **argv)
 {
 
@@ -761,6 +914,20 @@ static void print_one_uuid(struct btrfs_fs_devices 
*fs_devices)
 	printf("\n");
 }
 
+
+/**** man: btrfs filesystem show
+ * 
+ * \Bbtrfs\b \Bfilesystem show\b [--all-devices|<uuid>|<label>]\b
+ * 
+ * Show the info of a btrfs filesystem. If no argument
+ * is passed, info of all the btrfs filesystem are shown.
+ * 
+ * Show the btrfs filesystem with some additional info. If no \IUUID\i or 
+ * \Ilabel\i is passed, \Bbtrfs\b show info of all the btrfs filesystem.
+ * If \B--all-devices\b is passed, all the devices under /dev are scanned;
+ * otherwise the devices list is extracted from the /proc/partitions file.
+ ****/
+
 int do_show_filesystem(int argc, char **argv)
 {
 	struct list_head *all_uuids;
@@ -806,6 +973,16 @@ int do_show_filesystem(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs device add
+ * 
+ * \Bbtrfs\b \Bdevice add\b\I <dev> [<dev>..] <path>\i
+ * 
+ * Add a device to a filesystem.
+ * 
+ * Add device(s) to the filesystem identified by \I<path>\i.
+ ****/
+
 int do_add_volume(int nargs, char **args)
 {
 
@@ -888,6 +1065,34 @@ int do_add_volume(int nargs, char **args)
 
 }
 
+
+/**** man: btrfs filesystem balance
+ * 
+ * \Bbtrfs\b \Bfilesystem balance\b [\B-wcv\b] [\B--wait\b] [\B--count\b] 
[\B--verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ * 
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ * 
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ ****/
+
+/**** man: btrfs balance start
+ * 
+ * \Bbtrfs\b \Bbalance start\b [\B-wcv\b] [\B--wait\b] [\B--count\b] [\B--
verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ * 
+ * Synonym for "btrfs filesystem balance".
+ * 
+ * Balance the chunks of the filesystem identified by \I<path>\i across
+ * the devices. The command returns immediately, and the balance
+ * operation runs in the background. Use \B--wait\b to run
+ * synchronously instead. Use \B--count\b to scan the filesystem and
+ * report the number of chunks that would be processed. Use
+ * \B--verbose\b in synchronous mode to report the number of chunks
+ * examined and balanced. See \BBALANCE FILTERS\b, below, for details
+ * of the different filter types and syntax.
+ ****/
+
 int do_balance(int argc, char **argv)
 {
 
@@ -913,6 +1118,17 @@ int do_balance(int argc, char **argv)
 	}
 	return 0;
 }
+
+
+/**** man: btrfs device delete
+ * 
+ * \Bbtrfs\b \Bdevice delete\b\I <dev> [<dev>..] <path>\i
+ * 
+ * Remove a device from a filesystem.
+ * 
+ * Remove device(s) from a filesystem identified by \I<path>\i.
+ ****/
+ 
 int do_remove_volume(int nargs, char **args)
 {
 
@@ -946,6 +1162,19 @@ int do_remove_volume(int nargs, char **args)
 		return 0;
 }
 
+
+/**** man: btrfs subvolume set-default
+ * 
+ * \Bbtrfs\b \Bsubvolume set-default\b\I <id> <path>\i
+ * 
+ * Set the subvolume of the filesystem <path> which will be mounted
+ * as default.
+ * 
+ * Set the subvolume of the filesystem \I<path>\i which is mounted as 
+ * \Idefault\i. The subvolume is identified by \I<id>\i, which 
+ * is returned by the \Bsubvolume list\b command.
+ ****/
+
 int do_set_default_subvol(int nargs, char **argv)
 {
 	int	ret=0, fd, e;
@@ -975,6 +1204,31 @@ int do_set_default_subvol(int nargs, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs filesystem label
+ * 
+ * \Bbtrfs\b \Bfilesystem label\b\I <dev> [newlabel]\i
+ * 
+ * With one argument, get the label of filesystem on <device>.
+ * If <newlabel> is passed, set the filesystem label to <newlabel>.
+ * The filesystem must be unmounted.
+ * 
+ * Show or update the label of a filesystem. \I<dev>\i is used to identify the
+ * filesystem. 
+ * If a \Inewlabel\i optional argument is passed, the label is changed. The
+ * following costraints exist for a label:
+ * \t
+ * - the maximum allowable lenght shall be less or equal than 256 chars
+ * \t
+ * - the label shall not  contain the '/' or '\\' characters.
+ * 
+ * NOTE: Currently there are the following limitations:
+ * \t
+ * - the filesystem has to be unmounted
+ * \t
+ * - the filesystem should not have more than one device.
+ ****/
+
 int do_change_label(int nargs, char **argv)
 {
 	/* check the number of argument */
diff --git a/scrub.c b/scrub.c
index 9dca5f6..66761c5 100644
--- a/scrub.c
+++ b/scrub.c
@@ -1473,16 +1473,76 @@ out:
 	return 0;
 }
 
+
+/**** man: btrfs scrub start
+ * 
+ * \Bbtrfs\b \Bscrub start\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ * 
+ * Start a new scrub.
+ * 
+ * Start a scrub on all devices of the filesystem identified by \I<path>\i or 
on
+ * a single \I<device>\i. Without options, scrub is started as a background
+ * process. Progress can be obtained with the \Bscrub status\b command. 
+ * Scrubbing involves reading all data from all disks and verifying 
checksums. 
+ * Errors are corrected along the way if possible.
+ * \w
+ * 
+ * \IOptions\i
+ * \t -B 5
+ * Do not background and print scrub statistics when finished.
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem (-B only).
+ * \t -q 5
+ * Quiet. Omit error messages and statistics.
+ * \t -r 5
+ * Read only mode. Do not attempt to correct anything.
+ * \t -u 5
+ * Scrub unused space as well. (NOT IMPLEMENTED)
+ * \q
+ ****/
+
 int do_scrub_start(int argc, char **argv)
 {
 	return scrub_start(argc, argv, 0);
 }
 
+
+/**** man: btrfs scrub resume
+ * 
+ * \Bbtrfs\b \Bscrub resume\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ * 
+ * Resume previously canceled or interrupted scrub.
+ * 
+ * Resume a canceled or interrupted scrub cycle on the filesystem identified by
+ * \I<path>\i or on a given \I<device>\i. Does not start a new scrub if the
+ * last scrub finished successfully.
+ * \w
+ * 
+ * \IOptions\i
+ * \p
+ * see \Bscrub start\b.
+ * \q
+ ****/
+
 int do_scrub_resume(int argc, char **argv)
 {
 	return scrub_start(argc, argv, 1);
 }
 
+
+/**** man: btrfs scrub cancel
+ * 
+ * \Bbtrfs\b \Bscrub cancel\b {\I<path>\i|\I<device>\i}
+ * 
+ * Cancel a running scrub.
+ * 
+ * If a scrub is running on the filesystem identified by \I<path>\i, cancel it.
+ * Progress is saved in the scrub progress file and scrubbing can be resumed 
later
+ * using the \Bscrub resume\b command.
+ * If a \I<device>\i is given, the corresponding filesystem is found and
+ * \Bscrub cancel\b behaves as if it was called on that filesystem.
+ ****/
+
 int do_scrub_cancel(int argc, char **argv)
 {
 	char *path = argv[1];
@@ -1528,6 +1588,25 @@ again:
 	return 0;
 }
 
+
+/**** man: btrfs scrub status
+ * 
+ * \Bbtrfs\b \Bscrub status\b [-d] {\I<path>\i|\I<device>\i}
+ * 
+ * Show status of running or finished scrub.
+ * 
+ * Show status of a running scrub for the filesystem identified by \I<path>\i 
or
+ * for the specified \I<device>\i.
+ * If no scrub is running, show statistics of the last finished or canceled 
scrub
+ * for that filesystem or device.
+ * \w
+ * 
+ * \IOptions\i
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem.
+ * \q
+ ****/
+
 int do_scrub_status(int argc, char **argv)
 {
 
-- 
1.7.7.2

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart8209272.oigRUo4nIC
Content-Disposition: inline; filename="send-via-kmail-attach-28999-1320789398-5291.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-28999-1320789398-5291.msg"

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..517b0de 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -155,6 +155,42 @@ static int parse_compress_type(char *s)
 	};
 }
 
+
+/**** man: btrfs filesystem defragment
+ * 
+ * \Bbtrfs\b \Bfilesystem defragment\b -c[zlib|lzo] [-l \Ilen\i] [-s \Istart\i] [-t \Isize\i] -[vf] <\Ifile\i>|<\Idir\i> [<\Ifile\i>|<\Idir\i>...]
+ * 
+ * Defragment a file or a directory.
+ * 
+ * Defragment file data and/or directory metadata. To defragment all files in a
+ * directory you have to specify each one on its own or use your shell 
+ * wildcards.
+ * 
+ * The start position and the number of bytes to deframention can be specified 
+ * by \Istart\i and \Ilen\i. Any extent bigger than \Ithresh\i will be 
+ * considered already defragged. Use 0 to take the kernel default, and use 1 
+ * to say eveery single extent must be rewritten. You can also turn on 
+ * compression in defragment operations.
+ * 
+ * \B-v\b be verbose
+ * 
+ * \B-c\b compress file contents while defragmenting
+ * 
+ * \B-f\b flush filesystem after defragmenting
+ * 
+ * \B-s start\b defragment only from byte \Istart\i onward
+ * 
+ * \B-l len\b defragment only up to \Ilen\i bytes
+ * 
+ * \B-t size\b defragment only files at least \Isize\i bytes big
+ * 
+ * NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of 
+ * data, don't use it if you use snapshots, have de-duplicated your data or 
+ * made copies with 
+ *
+ * \Bcp --reflink\b.
+ ****/
+
 int do_defrag(int ac, char **av)
 {
 	int fd;
@@ -267,6 +303,16 @@ int do_defrag(int ac, char **av)
 	return errors + 20;
 }
 
+
+/**** man: btrfs subvolume find-new
+ * 
+ * \Bbtrfs\b \Bsubvolume find-new\b\I <subvolume> <last_gen>\i
+ * 
+ * List the recently modified files in a filesystem.
+ * 
+ * List the recently modified files in a subvolume, after \I<last_gen>\i ID.
+ ****/
+
 int do_find_newer(int argc, char **argv)
 {
 	int fd;
@@ -298,6 +344,25 @@ int do_find_newer(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs subvolume list
+ * 
+ * \Bbtrfs\b \Bsubvolume list\b\I [-p] <path>\i
+ * 
+ * List the snapshot/subvolume of a filesystem.
+ * 
+ * List the subvolumes present in the filesystem \I<path>\i. For every
+ * subvolume the following information is shown by default.
+ * ID <ID> top level <ID> path <path>
+ * where path is the relative path of the subvolume to the \Itop level\i
+ * subvolume.
+ * The subvolume's ID may be used by the \Bsubvolume set-default\b command, or
+ * at mount time via the \Isubvol=\i option.
+ * If \I-p\i is given, then \Iparent <ID>\i is added to the output between ID
+ * and top level. The parent's ID may be used at mount time via the
+ * \Isubvolrootid=\i option.
+ ****/
+
 int do_subvol_list(int argc, char **argv)
 {
 	int fd;
@@ -345,6 +410,20 @@ int do_subvol_list(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs subvolume snapshot
+ * 
+ * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] <source> [<dest>/]<name>\i
+ * 
+ * Create a writable/readonly snapshot of the subvolume <source> with
+ * the name <name> in the <dest> directory.
+ * 
+ * Create a writable/readonly snapshot of the subvolume \I<source>\i with the
+ * name \I<name>\i in the \I<dest>\i directory. If \I<source>\i is not a
+ * subvolume, \Bbtrfs\b returns an error. If \I-r\i is given, the snapshot
+ * will be readonly.
+ ****/
+
 int do_clone(int argc, char **argv)
 {
 	char	*subvol, *dst;
@@ -462,6 +541,17 @@ int do_clone(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs subvolume delete
+ * 
+ * \Bbtrfs\b \Bsubvolume delete\b\I <subvolume>\i
+ * 
+ * Delete the subvolume <subvolume>.
+ * 
+ * Delete the subvolume \I<subvolume>\i. If \I<subvolume>\i is not a
+ * subvolume, \Bbtrfs\b returns an error.
+ ****/
+
 int do_delete_subvolume(int argc, char **argv)
 {
 	int	res, fd, len, e;
@@ -524,6 +614,18 @@ int do_delete_subvolume(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs subvolume create
+ * 
+ * \Bbtrfs\b \Bsubvolume create\b\I [<dest>/]<name>\i
+ * 
+ * Create a subvolume in <dest> (or the current directory if
+ * not passed).
+ * 
+ * Create a subvolume in \I<dest>\i (or in the current directory if
+ * \I<dest>\i is omitted).
+ ****/
+
 int do_create_subvol(int argc, char **argv)
 {
 	int	res, fddst, len, e;
@@ -580,6 +682,16 @@ int do_create_subvol(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs filesystem sync
+ * 
+ * \Bbtrfs\b \Bfilesystem sync\b\I <path> \i
+ * 
+ * Force a sync on the filesystem <path>.
+ * 
+ * Force a sync for the filesystem identified by \I<path>\i.
+ ****/
+
 int do_fssync(int argc, char **argv)
 {
 	int 	fd, res, e;
@@ -604,6 +716,21 @@ int do_fssync(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs device scan
+ * 
+ * \Bbtrfs\b \Bdevice scan\b \I[--all-devices|<device> [<device>...]\i
+ * 
+ * Scan all device for or the passed device for a btrfs
+ * filesystem.
+ * 
+ * If one or more devices are passed, these are scanned for a btrfs filesystem. 
+ * If no devices are passed, \Bbtrfs\b scans all the block devices listed
+ * in the /proc/partitions file.
+ * Finally, if \B--all-devices\b is passed, all the devices under /dev are 
+ * scanned.
+ ****/
+
 int do_scan(int argc, char **argv)
 {
 	int	i, fd, e;
@@ -671,6 +798,32 @@ int do_scan(int argc, char **argv)
 
 }
 
+
+/**** man: btrfs filesystem resize
+ * 
+ * \Bbtrfs\b \Bfilesystem resize\b\I [+/\-]<size>[gkm]|max <path>\i
+ * 
+ * Resize the file system. If 'max' is passed, the filesystem
+ * will occupe all available space on the device.
+ * 
+ * Resize a filesystem identified by \I<path>\i.
+ * The \I<size>\i parameter specifies the new size of the filesystem.
+ * If the prefix \I+\i or \I\-\i is present the size is increased or decreased
+ * by the quantity \I<size>\i.
+ * If no units are specified, the unit of the \I<size>\i parameter defaults to
+ * bytes. Optionally, the size parameter may be suffixed by one of the following
+ * the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
+ * respectively.
+ * 
+ * If 'max' is passed, the filesystem will occupy all available space on the
+ * volume(s).
+ * 
+ * The \Bresize\b command \Bdoes not\b manipulate the size of underlying
+ * partition.  If you wish to enlarge/reduce a filesystem, you must make sure
+ * you can expand the partition before enlarging the filesystem and shrink the
+ * partition after reducing the size of the filesystem.
+ ****/
+
 int do_resize(int argc, char **argv)
 {
 
@@ -761,6 +914,20 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	printf("\n");
 }
 
+
+/**** man: btrfs filesystem show
+ * 
+ * \Bbtrfs\b \Bfilesystem show\b [--all-devices|<uuid>|<label>]\b
+ * 
+ * Show the info of a btrfs filesystem. If no argument
+ * is passed, info of all the btrfs filesystem are shown.
+ * 
+ * Show the btrfs filesystem with some additional info. If no \IUUID\i or 
+ * \Ilabel\i is passed, \Bbtrfs\b show info of all the btrfs filesystem.
+ * If \B--all-devices\b is passed, all the devices under /dev are scanned;
+ * otherwise the devices list is extracted from the /proc/partitions file.
+ ****/
+
 int do_show_filesystem(int argc, char **argv)
 {
 	struct list_head *all_uuids;
@@ -806,6 +973,16 @@ int do_show_filesystem(int argc, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs device add
+ * 
+ * \Bbtrfs\b \Bdevice add\b\I <dev> [<dev>..] <path>\i
+ * 
+ * Add a device to a filesystem.
+ * 
+ * Add device(s) to the filesystem identified by \I<path>\i.
+ ****/
+
 int do_add_volume(int nargs, char **args)
 {
 
@@ -888,6 +1065,34 @@ int do_add_volume(int nargs, char **args)
 
 }
 
+
+/**** man: btrfs filesystem balance
+ * 
+ * \Bbtrfs\b \Bfilesystem balance\b [\B-wcv\b] [\B--wait\b] [\B--count\b] [\B--verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ * 
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ * 
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ ****/
+
+/**** man: btrfs balance start
+ * 
+ * \Bbtrfs\b \Bbalance start\b [\B-wcv\b] [\B--wait\b] [\B--count\b] [\B--verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ * 
+ * Synonym for "btrfs filesystem balance".
+ * 
+ * Balance the chunks of the filesystem identified by \I<path>\i across
+ * the devices. The command returns immediately, and the balance
+ * operation runs in the background. Use \B--wait\b to run
+ * synchronously instead. Use \B--count\b to scan the filesystem and
+ * report the number of chunks that would be processed. Use
+ * \B--verbose\b in synchronous mode to report the number of chunks
+ * examined and balanced. See \BBALANCE FILTERS\b, below, for details
+ * of the different filter types and syntax.
+ ****/
+
 int do_balance(int argc, char **argv)
 {
 
@@ -913,6 +1118,17 @@ int do_balance(int argc, char **argv)
 	}
 	return 0;
 }
+
+
+/**** man: btrfs device delete
+ * 
+ * \Bbtrfs\b \Bdevice delete\b\I <dev> [<dev>..] <path>\i
+ * 
+ * Remove a device from a filesystem.
+ * 
+ * Remove device(s) from a filesystem identified by \I<path>\i.
+ ****/
+ 
 int do_remove_volume(int nargs, char **args)
 {
 
@@ -946,6 +1162,19 @@ int do_remove_volume(int nargs, char **args)
 		return 0;
 }
 
+
+/**** man: btrfs subvolume set-default
+ * 
+ * \Bbtrfs\b \Bsubvolume set-default\b\I <id> <path>\i
+ * 
+ * Set the subvolume of the filesystem <path> which will be mounted
+ * as default.
+ * 
+ * Set the subvolume of the filesystem \I<path>\i which is mounted as 
+ * \Idefault\i. The subvolume is identified by \I<id>\i, which 
+ * is returned by the \Bsubvolume list\b command.
+ ****/
+
 int do_set_default_subvol(int nargs, char **argv)
 {
 	int	ret=0, fd, e;
@@ -975,6 +1204,31 @@ int do_set_default_subvol(int nargs, char **argv)
 	return 0;
 }
 
+
+/**** man: btrfs filesystem label
+ * 
+ * \Bbtrfs\b \Bfilesystem label\b\I <dev> [newlabel]\i
+ * 
+ * With one argument, get the label of filesystem on <device>.
+ * If <newlabel> is passed, set the filesystem label to <newlabel>.
+ * The filesystem must be unmounted.
+ * 
+ * Show or update the label of a filesystem. \I<dev>\i is used to identify the
+ * filesystem. 
+ * If a \Inewlabel\i optional argument is passed, the label is changed. The
+ * following costraints exist for a label:
+ * \t
+ * - the maximum allowable lenght shall be less or equal than 256 chars
+ * \t
+ * - the label shall not  contain the '/' or '\\' characters.
+ * 
+ * NOTE: Currently there are the following limitations:
+ * \t
+ * - the filesystem has to be unmounted
+ * \t
+ * - the filesystem should not have more than one device.
+ ****/
+
 int do_change_label(int nargs, char **argv)
 {
 	/* check the number of argument */
diff --git a/scrub.c b/scrub.c
index 9dca5f6..66761c5 100644
--- a/scrub.c
+++ b/scrub.c
@@ -1473,16 +1473,76 @@ out:
 	return 0;
 }
 
+
+/**** man: btrfs scrub start
+ * 
+ * \Bbtrfs\b \Bscrub start\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ * 
+ * Start a new scrub.
+ * 
+ * Start a scrub on all devices of the filesystem identified by \I<path>\i or on
+ * a single \I<device>\i. Without options, scrub is started as a background
+ * process. Progress can be obtained with the \Bscrub status\b command. 
+ * Scrubbing involves reading all data from all disks and verifying checksums. 
+ * Errors are corrected along the way if possible.
+ * \w
+ * 
+ * \IOptions\i
+ * \t -B 5
+ * Do not background and print scrub statistics when finished.
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem (-B only).
+ * \t -q 5
+ * Quiet. Omit error messages and statistics.
+ * \t -r 5
+ * Read only mode. Do not attempt to correct anything.
+ * \t -u 5
+ * Scrub unused space as well. (NOT IMPLEMENTED)
+ * \q
+ ****/
+
 int do_scrub_start(int argc, char **argv)
 {
 	return scrub_start(argc, argv, 0);
 }
 
+
+/**** man: btrfs scrub resume
+ * 
+ * \Bbtrfs\b \Bscrub resume\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ * 
+ * Resume previously canceled or interrupted scrub.
+ * 
+ * Resume a canceled or interrupted scrub cycle on the filesystem identified by
+ * \I<path>\i or on a given \I<device>\i. Does not start a new scrub if the
+ * last scrub finished successfully.
+ * \w
+ * 
+ * \IOptions\i
+ * \p
+ * see \Bscrub start\b.
+ * \q
+ ****/
+
 int do_scrub_resume(int argc, char **argv)
 {
 	return scrub_start(argc, argv, 1);
 }
 
+
+/**** man: btrfs scrub cancel
+ * 
+ * \Bbtrfs\b \Bscrub cancel\b {\I<path>\i|\I<device>\i}
+ * 
+ * Cancel a running scrub.
+ * 
+ * If a scrub is running on the filesystem identified by \I<path>\i, cancel it.
+ * Progress is saved in the scrub progress file and scrubbing can be resumed later
+ * using the \Bscrub resume\b command.
+ * If a \I<device>\i is given, the corresponding filesystem is found and
+ * \Bscrub cancel\b behaves as if it was called on that filesystem.
+ ****/
+
 int do_scrub_cancel(int argc, char **argv)
 {
 	char *path = argv[1];
@@ -1528,6 +1588,25 @@ again:
 	return 0;
 }
 
+
+/**** man: btrfs scrub status
+ * 
+ * \Bbtrfs\b \Bscrub status\b [-d] {\I<path>\i|\I<device>\i}
+ * 
+ * Show status of running or finished scrub.
+ * 
+ * Show status of a running scrub for the filesystem identified by \I<path>\i or
+ * for the specified \I<device>\i.
+ * If no scrub is running, show statistics of the last finished or canceled scrub
+ * for that filesystem or device.
+ * \w
+ * 
+ * \IOptions\i
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem.
+ * \q
+ ****/
+
 int do_scrub_status(int argc, char **argv)
 {
 
-- 
1.7.7.2

--nextPart8209272.oigRUo4nIC--

