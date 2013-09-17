Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:57755 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3IQPax (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:30:53 -0400
Received: by mail-ve0-f177.google.com with SMTP id db12so4226860veb.22
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 08:30:52 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Sep 2013 11:30:52 -0400
Message-ID: <CAC4gV=40wHT3UcSbHsgei8zqcRwCT7-X0g7Vxzp7A_1nyNkOYw@mail.gmail.com>
Subject: Re: [RFC v2] btrfs-progs: Add recursive defrag using -r option
From: Frank Holton <fholton@gmail.com>
To: dsterba@suse.cz, Frank Holton <fholton@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for that hint to use ftw. I've updated the code to use it and
tried to make sure
that I caught all of the styling errors.

Since the ftw callback doesn't take any additional options I had to add several
global variables to pass the fancy_ioctl and range parameters. Should
I replace all
of the uses of those variables with the globals or just copy into the
globals like I did in
the code below.

It does not attempt to defrag directories anymore in the recursive
mode, however, the
non recursive mode will still attempt to defrag directories. I figured
since that only works
when you run as root that it is acceptable for now.

Thanks again for looking over it.

- Frank

---
 cmds-filesystem.c |  119 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 96 insertions(+), 23 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..9635066 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,8 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <fcntl.h>
+#include <ftw.h>

 #include "kerncompat.h"
 #include "ctree.h"
@@ -333,6 +335,7 @@ static const char * const cmd_defrag_usage[] = {
  "Defragment a file or a directory",
  "",
  "-v             be verbose",
+ "-r             defragment files recursively",
  "-c[zlib,lzo]   compress the file while defragmenting",
  "-f             flush data to disk immediately after defragmenting",
  "-s start       defragment only from byte onward",
@@ -341,6 +344,57 @@ static const char * const cmd_defrag_usage[] = {
  NULL
 };

+static int do_defrag(int fd, int fancy_ioctl,
+ struct btrfs_ioctl_defrag_range_args *range)
+{
+ int ret;
+
+ if (!fancy_ioctl) {
+ ret = ioctl(fd, BTRFS_IOC_DEFRAG, NULL);
+ } else {
+ ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, range);
+ }
+ return ret;
+}
+
+static int global_fancy_ioctl;
+static struct btrfs_ioctl_defrag_range_args global_range;
+static int global_verbose;
+static int global_errors;
+static int defrag_callback(const char *fpath, const struct stat *sb,
int typeflag)
+{
+ int ret = 0;
+ int e = 0;
+ int fd = 0;
+
+ if (typeflag == FTW_F) {
+ if (global_verbose)
+ printf("%s\n", fpath);
+ fd = open(fpath,O_RDWR);
+ e = errno;
+ if (fd < 0)
+ goto error;
+ ret = do_defrag(fd, global_fancy_ioctl, &global_range);
+ e = errno;
+ close(fd);
+ if (ret && e == ENOTTY) {
+ fprintf(stderr, "ERROR: defrag range ioctl not "
+ "supported in this kernel, please try "
+ "without any options.\n");
+ global_errors++;
+ return ENOTTY;
+ }
+ if (ret)
+ goto error;
+ }
+ return 0;
+
+error:
+ fprintf(stderr, "ERROR: defrag failed on %s - %s\n", fpath, strerror(e));
+ global_errors++;
+ return 0;
+}
+
 static int cmd_defrag(int argc, char **argv)
 {
  int fd;
@@ -349,7 +403,8 @@ static int cmd_defrag(int argc, char **argv)
  u64 len = (u64)-1;
  u32 thresh = 0;
  int i;
- int errors = 0;
+ int recursive = 0;
+ global_errors = 0;
  int ret = 0;
  int verbose = 0;
  int fancy_ioctl = 0;
@@ -359,7 +414,7 @@ static int cmd_defrag(int argc, char **argv)

  optind = 1;
  while(1) {
- int c = getopt(argc, argv, "vc::fs:l:t:");
+ int c = getopt(argc, argv, "vrc::fs:l:t:");
  if (c < 0)
  break;

@@ -389,6 +444,9 @@ static int cmd_defrag(int argc, char **argv)
  thresh = parse_size(optarg);
  fancy_ioctl = 1;
  break;
+ case 'r':
+ recursive = 1;
+ break;
  default:
  usage(cmd_defrag_usage);
  }
@@ -407,47 +465,62 @@ static int cmd_defrag(int argc, char **argv)
  }
  if (flush)
  range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
+
+ memcpy(&global_range, &range, sizeof(range));
+ global_verbose = verbose;
+ global_fancy_ioctl = fancy_ioctl;

  for (i = optind; i < argc; i++) {
- if (verbose)
- printf("%s\n", argv[i]);
  fd = open_file_or_dir(argv[i]);
  if (fd < 0) {
- fprintf(stderr, "failed to open %s\n", argv[i]);
+ fprintf(stderr, "ERROR: failed to open %s\n", argv[i]);
  perror("open:");
- errors++;
+ global_errors++;
  continue;
  }
- if (!fancy_ioctl) {
- ret = ioctl(fd, BTRFS_IOC_DEFRAG, NULL);
- e=errno;
- } else {
- ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, &range);
- if (ret && errno == ENOTTY) {
- fprintf(stderr, "ERROR: defrag range ioctl not "
- "supported in this kernel, please try "
- "without any options.\n");
- errors++;
- close(fd);
- break;
+ if (recursive) {
+ struct stat st;
+ fstat(fd, &st);
+ if (S_ISDIR(st.st_mode)) {
+ ret = ftw(argv[i], defrag_callback, 10);
+ if (ret == ENOTTY)
+ exit(1);
+ /* errors are handled in the callback */
+ ret = 0;
+ } else {
+ if (verbose)
+ printf("%s\n", argv[i]);
+ ret = do_defrag(fd, fancy_ioctl, &range);
+ e = errno;
  }
+ } else {
+ if (verbose)
+ printf("%s\n", argv[i]);
+ ret = do_defrag(fd, fancy_ioctl, &range);
  e = errno;
  }
+ close(fd);
+ if (ret && e == ENOTTY) {
+ fprintf(stderr, "ERROR: defrag range ioctl not "
+ "supported in this kernel, please try "
+ "without any options.\n");
+ global_errors++;
+ break;
+ }
  if (ret) {
  fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
  argv[i], strerror(e));
- errors++;
+ global_errors++;
  }
- close(fd);
  }
  if (verbose)
  printf("%s\n", BTRFS_BUILD_VERSION);
- if (errors) {
- fprintf(stderr, "total %d failures\n", errors);
+ if (global_errors) {
+ fprintf(stderr, "total %d failures\n", global_errors);
  exit(1);
  }

- return errors;
+ return 0;
 }

 static const char * const cmd_resize_usage[] = {
-- 
1.7.9.5

On Tue, Sep 17, 2013 at 9:03 AM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Sep 16, 2013 at 10:21:24PM -0400, Frank Holton wrote:
>> I'm working on a patch to add the recursive option to the
>> btrfs filesystem defrag command.
>
> Great!
>
>> I'd like some feedback on how the patch looks as written. I've added
>> two helper functions, which might need to be renamed, one to call the
>> ioctl and one to actually handle the recursion into the directory.
>
> Please use the 'ftw' function from glibc
> http://man7.org/linux/man-pages/man3/ftw.3.html
>
> (it's used in mkfs.c for example)
>
>> @@ -333,6 +336,7 @@ static const char * const cmd_defrag_usage[] = {
>>       "Defragment a file or a directory",
>>       "",
>>       "-v             be verbose",
>> +     "-r             defragment directories and files recursively",
>
> Directories do not get defragmented. Giving any directory to defragment
> will actually deframgent the subvolume fs_tree and then the shared
> extent tree.  This is hidden in implementation and has confused people.
>
> For now, I suggest to recursively defrag only files, that's IMHO the
> most frequent usecase.
>
> Deframgenting the subvol root or the extent tree are special cases and
> should be enabled only when requested, by a commandline option. This
> needs updating kernel. I can go into details later if needed.
>
> (I'ts possible to implement a per-directory defrag by extending
> btrfs_defrag_leaves with start/end key ranges that represent the
> directory items.)
>
> A few comments on the code follow, I hope you convert it to the 'ftw'
> callback, this will remove half of the code from this patch, so I'd
> rather see the result first. Basically, the contents of the ftw callback
> is done inside this loop:
>
>> +     while ((dent = readdir(dir)) != NULL) {
>> +             int fd = 0;
>> +             if (!strcmp(dent->d_name,".") || !strcmp(dent->d_name, ".."))
>> +                     continue;
>> +
>> +             fn[len] = 0;
>> +             strncat(fn+len, dent->d_name, FILENAME_MAX - len);
>> +
>> +             if (lstat(fn, &st) == -1) {
>> +                     fprintf(stderr,"ERROR: cannot stat %s\n", fn);
>> +                     error++;
>> +                     continue;
>> +             }
>> +
>> +             /* ignore symlinks ??*/
>> +             if (S_ISLNK(st.st_mode))
>> +                     continue;
>> +
>> +             if(verbose)
>> +                     printf("%s\n", fn);
>> +
>> +             /* directory entry */
>> +             if (S_ISDIR(st.st_mode)) {
>> +                     ret = walk_dir(fn, verbose, fancy_ioctl, range);
>> +                     errors += ret;
>> +             }
>> +             else {
>> +                     fd = open(fn,O_RDWR);
>> +                     e = errno;
>> +                     if (fd < 0) {
>> +                             fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
>> +                                     fn, strerror(e));
>> +                             error++;
>> +                             continue;
>> +                     }
>> +
>> +                     ret = do_defrag(fd, fancy_ioctl, range);
>> +                     e = errno;
>> +
>> +                     if (ret) {
>> +                             errors++;
>> +                             fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
>> +                                     fn, strerror(e));
>> +                             error++;
>> +                     }
>> +                     close(fd);
>> +             }
>> +     }
>> +
>> +     close(dir_fd);
>> +     closedir(dir);
>> +
>> +     return(errors);
>> +}
>
> The command line argument handling is ok.
>
> Please get familiar with the coding style
> https://www.kernel.org/doc/Documentation/CodingStyle
> eg. spacing and { } placement. It's not pointless to keep the style
> consistent, people who have to read the code appreciate if it looks the
> same all over the place.
>
> thanks,
> david
