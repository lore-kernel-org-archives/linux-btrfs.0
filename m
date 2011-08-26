From: Jeff Liu <jeff.liu@oracle.com>
Subject: bug#8061: Introduce SEEK_DATA/SEEK_HOLE to extent_scan module
Date: Fri, 26 Aug 2011 17:43:24 +0800
Message-ID: <4E576ABC.4080705@oracle.com>
References: <2DB776C1-EF34-423D-8BE5-71C2F49DFF01@oracle.com>	<BE690E2C-C275-4B28-8ACB-9616D367EF96@oracle.com>
	<3E3FBE56-4D89-44A4-94ED-13F3D1F693A3@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: zfs-discuss@opensolaris.org, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: 8061@debbugs.gnu.org
Return-path: <bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org>
In-Reply-To: <3E3FBE56-4D89-44A4-94ED-13F3D1F693A3@oracle.com>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=unsubscribe>
List-Archive: </archive/html/bug-coreutils>
List-Post: <mailto:bug-coreutils@gnu.org>
List-Help: <mailto:bug-coreutils-request@gnu.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=subscribe>
Errors-To: bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear All,

As the SEEK_HOLE/SEEK_DATA has been implemented on Btrfs in 3.1.0+ and 
Glibc, I have worked out a new version for your guys review.

Changes:
======
extent_scan.[c|h]:
1.  add a function pointer to "struct extent_scan":
/* Scan method.  */
bool (*extent_scan) (struct extent_scan *scan);

2. add  a structure item to indicate seek back issue maybe occurred:
/* Failed to seek back to position 0 or not.  */
bool seek_back_failed;
If the file system support SEEK_HOLE, the file offset will pointed to 
somewhere > 0, so need to
seek back to the beginning after support_seek_hole() checking for the 
proceeding extent scan.

3. rename extent_scan to fiemap_extent_scan.

4. add a new seek_extent_scan method.

5. add a new method to check SEEK stuff is supported or not.
if the underlaying file system support SEEK_HOLE, assign 
seek_extent_scan to scan->extent_scan, or else, fiemap_extent_scan() 
will be assigned to it.

copy.c:
1. pass src_total_size to extent_scan_init ().
2. for the first round extent scan,  we need to seek back to position 0 
too, if the data extent is started at the beginning of source file.

Tested:
======
1. make syntax-check.
2. verify a copied sparse file with 4697 extents on btrfs
jeff@pibroch:~/gnu/coreutils$ python -c "f=open('/btrfs/sparse_test', 
'w'); [(f.seek(x) or f.write(str(x))) for x in range(1, 1000000000, 
99999)]; f.close()"
jeff@pibroch:~/gnu/coreutils$ ./src/cp --sparse=always 
/btrfs/sparse_test /btrfs/sp.seek
jeff@pibroch:~/gnu/coreutils$ cmp /btrfs/sparse_test /btrfs/sp.seek
jeff@pibroch:~/gnu/coreutils$ echo $?
0

Also, the previous patch was developed on Solaris ZFS,  but my test env 
was lost now. :(  so anyone can help testing it on ZFS would be 
appreciated!!


 From 5892744f977a06b5557042682c39fd007eec8030 Mon Sep 17 00:00:00 2001
From: Jie Liu <jeff.liu@oracle.com>
Date: Fri, 26 Aug 2011 17:11:33 +0800
Subject: [PATCH 1/1] copy: add SEEK_DATA/SEEK_HOLE support to 
extent_scan module

* src/extent_scan.h: introduce src_total_size to struct extent_info, we
   need it for lseek(2) iteration, add seek_back_failed to indicate that the
   seek back to position 0 failed in seek captical check or not, and it can
   be used for further debugging IMHO.
   add bool (*extent_scan) (struct extent_scan *scan) to switch the scan 
method.
* src/extent_scan.c: implement a new seek_scan_read() through SEEK_DATA
   and SEEK_HOLE.
* src/copy.c: a few code changes according to the new extent call interface.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
  src/copy.c        |   26 +++++++++-
  src/extent-scan.c |  149 
++++++++++++++++++++++++++++++++++++++++++++++++++--
  src/extent-scan.h |   16 +++++-
  3 files changed, 183 insertions(+), 8 deletions(-)

diff --git a/src/copy.c b/src/copy.c
index bc4d7bd..c5e8714 100644
--- a/src/copy.c
+++ b/src/copy.c
@@ -309,7 +309,18 @@ extent_copy (int src_fd, int dest_fd, char *buf, 
size_t buf_size,
       We may need this at the end, for a final ftruncate.  */
    off_t dest_pos = 0;

-  extent_scan_init (src_fd, &scan);
+  bool init_ok = extent_scan_init (src_fd, src_total_size, &scan);
+  /* If the underlaying file system support SEEK_HOLE, but failed
+     to seek back to position 0 after the initial seek checking,
+     let extent copy failure in this case.  */
+  if (! init_ok)
+    {
+      if (scan.seek_back_failed)
+        error (0, errno,
+          _("%s: extent_scan_init () failed, cannot seek back to 
position 0"),
+               quote (src_name));
+      return false;
+    }

    *require_normal_copy = false;
    bool wrote_hole_at_eof = true;
@@ -356,6 +367,19 @@ extent_copy (int src_fd, int dest_fd, char *buf, 
size_t buf_size,

            wrote_hole_at_eof = false;

+          /* For the first round scan, if the data extent start at the
+             beginning, and the current file pointer is not at position
+             0, set it back first, otherwise, we'll read from undesired
+             file offset.  */
+          if (ext_start == 0 && lseek (src_fd, 0, SEEK_CUR) != 0)
+            {
+              if (lseek (src_fd, 0, SEEK_SET) < 0)
+                {
+                  error (0, errno, _("cannot lseek %s"), quote (src_name));
+                  return false;
+                }
+            }
+
            if (hole_size)
              {
                if (lseek (src_fd, ext_start, SEEK_SET) < 0)
diff --git a/src/extent-scan.c b/src/extent-scan.c
index 37445b8..c835b63 100644
--- a/src/extent-scan.c
+++ b/src/extent-scan.c
@@ -27,6 +27,12 @@
  #include "fiemap.h"
  #include "xstrtol.h"

+#ifndef SEEK_DATA
+# define SEEK_DATA 3  /* Seek to next data.  */
+#endif
+#ifndef SEEK_HOLE
+# define SEEK_HOLE 4  /* Seek to next hole.  */
+#endif

  /* Work around Linux kernel issues on BTRFS and EXT4 before 2.6.39.
     FIXME: remove in 2013, or whenever we're pretty confident
@@ -65,10 +71,48 @@ extent_need_sync (void)
  #endif
  }

+static bool
+support_seek_hole (struct extent_scan *scan)
+{
+  off_t hole_pos;
+
+# ifdef _PC_MIN_HOLE_SIZE
+  /* To determine if the underlaying file system support
+     SEEK_HOLE, if not, fall back to fiemap extent scan or
+     the standard copy.  */
+  if (fpathconf (scan->fd, _PC_MIN_HOLE_SIZE) < 0)
+      return false;
+# endif
+
+  /* Inspired by STAR, If we have been compiled on an OS that
+     supports SEEK_HOLE but run on an OS that does not support
+     SEEK_HOLE, we get EINVAL.  If the underlying file system
+     does not support the SEEK_HOLE call, we get ENOTSUP, fall
+     back to the fiemap scan or standard copy in either case.  */
+  hole_pos = lseek (scan->fd, (off_t) 0, SEEK_HOLE);
+  if (hole_pos < 0)
+    {
+      if (errno == EINVAL || errno == ENOTSUP)
+          return false;
+    }
+
+  /* Seek back to position 0 first if we detected a real hole.  */
+  if (hole_pos > 0)
+    {
+      if (lseek (scan->fd, (off_t) 0, SEEK_SET) != 0)
+        {
+          scan->seek_back_failed = true;
+          return false;
+        }
+    }
+
+  return true;
+}
+
  /* Allocate space for struct extent_scan, initialize the entries if
     necessary and return it as the input argument of 
extent_scan_read().  */
-extern void
-extent_scan_init (int src_fd, struct extent_scan *scan)
+extern bool
+extent_scan_init (int src_fd, size_t src_total_size, struct extent_scan 
*scan)
  {
    scan->fd = src_fd;
    scan->ei_count = 0;
@@ -76,17 +120,110 @@ extent_scan_init (int src_fd, struct extent_scan 
*scan)
    scan->scan_start = 0;
    scan->initial_scan_failed = false;
    scan->hit_final_extent = false;
-  scan->fm_flags = extent_need_sync () ? FIEMAP_FLAG_SYNC : 0;
+  scan->seek_back_failed = false;
+
+  if (support_seek_hole (scan))
+    {
+      scan->src_total_size = src_total_size;
+      scan->extent_scan = seek_extent_scan;
+    }
+  else
+    {
+      /* The underlying file system support SEEK_HOLE, but failed
+         to seek back to position 0 after seek checking, Oops!  */
+      if (scan->seek_back_failed)
+        return false;
+
+      scan->extent_scan = fiemap_extent_scan;
+      scan->fm_flags = extent_need_sync () ? FIEMAP_FLAG_SYNC : 0;
+    }
+
+  return true;
+}
+
+extern inline bool
+extent_scan_read (struct extent_scan *scan)
+{
+  return scan->extent_scan (scan);
+}
+
+extern bool
+seek_extent_scan (struct extent_scan *scan)
+{
+  off_t data_pos, hole_pos;
+  union { struct extent_info ei; char c[4096]; } extent_buf;
+  struct extent_info *ext_info = &extent_buf.ei;
+  enum { count = (sizeof extent_buf / sizeof *ext_info) };
+  verify (count != 0);
+
+  memset (&extent_buf, 0, sizeof extent_buf);
+
+  unsigned int i = 0;
+  /* If lseek(2) failed and the errno is set to ENXIO, for
+     SEEK_DATA there are no more data regions past the supplied
+     offset.  For SEEK_HOLE, there are no more holes past the
+     supplied offset.  Set scan->hit_final_extent to true for
+     either case.  */
+  do {
+    data_pos = lseek (scan->fd, scan->scan_start, SEEK_DATA);
+    if (data_pos < 0)
+      {
+        if (errno == ENXIO)
+          {
+            scan->hit_final_extent = true;
+            return true;
+          }
+        return false;
+      }
+
+    /* We hit the final extent if the data offset is equal to
+       the source file size.  */
+    if (data_pos == scan->src_total_size)
+      {
+        scan->hit_final_extent = true;
+        break;
+      }
+
+    hole_pos = lseek (scan->fd, data_pos, SEEK_HOLE);
+    if (hole_pos < 0)
+      {
+        if (errno != ENXIO)
+          return false;
+        else
+          {
+            scan->hit_final_extent = true;
+            return true;
+          }
+      }
+
+    ext_info[i].ext_logical = data_pos;
+    ext_info[i].ext_length = hole_pos - data_pos;
+    scan->scan_start = hole_pos;
+    ++i;
+  } while (scan->scan_start < scan->src_total_size && i < count);
+
+  scan->ei_count = i;
+  scan->ext_info = xnmalloc (scan->ei_count, sizeof (struct extent_info));
+
+  for (i = 0; i < scan->ei_count; i++)
+    {
+      assert (ext_info[i].ext_logical <= OFF_T_MAX);
+
+      scan->ext_info[i].ext_logical = ext_info[i].ext_logical;
+      scan->ext_info[i].ext_length = ext_info[i].ext_length;
+    }
+
+  return true;
  }

-#ifdef __linux__
+#if defined __linux__
  # ifndef FS_IOC_FIEMAP
  #  define FS_IOC_FIEMAP _IOWR ('f', 11, struct fiemap)
  # endif
  /* Call ioctl(2) with FS_IOC_FIEMAP (available in linux 2.6.27) to
     obtain a map of file extents excluding holes.  */
  extern bool
-extent_scan_read (struct extent_scan *scan)
+fiemap_extent_scan (struct extent_scan *scan)
  {
    unsigned int si = 0;
    struct extent_info *last_ei IF_LINT ( = scan->ext_info);
@@ -212,7 +349,7 @@ extent_scan_read (struct extent_scan *scan)
  }
  #else
  extern bool
-extent_scan_read (struct extent_scan *scan ATTRIBUTE_UNUSED)
+fiemap_extent_scan (struct extent_scan *scan ATTRIBUTE_UNUSED)
  {
    scan->initial_scan_failed = true;
    errno = ENOTSUP;
diff --git a/src/extent-scan.h b/src/extent-scan.h
index 5b4ded5..e751810 100644
--- a/src/extent-scan.h
+++ b/src/extent-scan.h
@@ -38,6 +38,9 @@ struct extent_scan
    /* File descriptor of extent scan run against.  */
    int fd;

+  /* Source file size, i.e, (struct stat) &statbuf.st_size.  */
+  size_t src_total_size;
+
    /* Next scan start offset.  */
    off_t scan_start;

@@ -47,6 +50,9 @@ struct extent_scan
    /* How many extent info returned for a scan.  */
    uint32_t ei_count;

+  /* Failed to seek back to position 0 or not.  */
+  bool seek_back_failed;
+
    /* If true, fall back to a normal copy, either set by the
       failure of ioctl(2) for FIEMAP or lseek(2) with SEEK_DATA.  */
    bool initial_scan_failed;
@@ -54,14 +60,22 @@ struct extent_scan
    /* If true, the total extent scan per file has been finished.  */
    bool hit_final_extent;

+  /* Scan method.  */
+  bool (*extent_scan) (struct extent_scan *scan);
+
    /* Extent information: a malloc'd array of ei_count structs.  */
    struct extent_info *ext_info;
  };

-void extent_scan_init (int src_fd, struct extent_scan *scan);
+bool extent_scan_init (int src_fd, size_t src_total_size,
+                       struct extent_scan *scan);

  bool extent_scan_read (struct extent_scan *scan);

+bool fiemap_extent_scan (struct extent_scan *scan);
+
+bool seek_extent_scan (struct extent_scan *scan);
+
  static inline void
  extent_scan_free (struct extent_scan *scan)
  {
-- 
1.7.4.1



Thanks,
-Jeff

On 04/19/2011 04:51 PM, Jeff liu wrote:
>> Hi All,
>>
>> Please ignore the current patch, I will submit another patch with a few fixes soon.
> Now the new patch set coming,
>
> In previous post, I have tried to change the extent_scan_init() interface by adding a new argument to indicate the source file size,
> this will reduce the overhead of call fstat(2)  in extent_scan_read(), since the file size is definitely needed for SEEK* stuff, however, the file size is redundant for FIEMAP.
> so I changed my idea to keep extent_scan_init() as before,  instead, to retrieve the file size in extent_scan_read() when launching the first scan, one benefit is, there is nothing need to
> be modified in extent_copy() for this patch.
>
> Tests:
> ====
> A new test sparse-lseek was introduced in this post, it make use of the sparse file generation function in Perl, and do `cmp` against the target copied file.
> I have also took a look at the `sdb` utility shipped with ZFS, but did not found any interesting stuff can be used for this test.
>
> Test run passed on my environment as below,
>
> bash-3.00# make check TESTS=cp/sparse-lseek VERBOSE=yes
> make  check-TESTS
> make[1]: Entering directory `/coreutils/tests'
> make[2]: Entering directory `/coreutils/tests'
> PASS: cp/sparse-lseek
> =============
> 1 test passed
> =============
> make[2]: Leaving directory `/coreutils/tests'
> make[1]: Leaving directory `/coreutils/tests'
>    GEN    vc_exe_in_TESTS
> No differences encountered
>
> Manual tests:
> ===========
> 1. Ensure trailing blanks, test 0 size sparse file, non-sparse file,  sparse file with hole start and hole end.
> 2. make syntax-check failed, I have no idea of this issue at the moment,  I also tried to run make distcheck, looks the package building, install and uninstall procedures all passed,
> but it also failed at the final stage, am I missing something here?
>
> The logs which were shown as following,
> bash-3.00# make syntax-check
> GFDL_version
> awk: syntax error near line 1
> awk: bailing out near line 1
> make: *** [sc_GFDL_version.z] Error 2
>
> make distcheck:
> ==============
> ......
> make[1]: Entering directory `/coreutils'
>    GEN    check-ls-dircolors
> make my-distcheck
> make[2]: Entering directory `/coreutils'
> make syntax-check
> make[3]: Entering directory `/coreutils'
> GFDL_version
> awk: syntax error near line 1
> awk: bailing out near line 1
> make[3]: *** [sc_GFDL_version.z] Error 2
> make[3]: Leaving directory `/coreutils'
> make[2]: *** [my-distcheck] Error 2
> make[2]: Leaving directory `/coreutils'
> make[1]: *** [distcheck-hook] Error 2
> make[1]: Leaving directory `/coreutils'
> make: *** [distcheck] Error 1
>
>
>
> Below is the revised patch,
>
>  From 4f966c1fe6226f3f711faae120cd8bea78e722b8 Mon Sep 17 00:00:00 2001
> From: Jie Liu<jeff.liu@oracle.com>
> Date: Tue, 19 Apr 2011 15:24:50 -0700
> Subject: [PATCH 1/1] copy: add SEEK_DATA/SEEK_HOLE support to extent_scan module
>
> * src/extent_scan.h: introduce src_total_size to struct extent_info, we
>    need it for lseek(2) iteration.
> * src/extent_scan.c: implement a new extent_scan_read() through SEEK_DATA
>    and SEEK_HOLE if those stuff are supported.
> * tests/cp/sparse-lseek: add a new test for lseek(2) extent copy.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---
>   src/extent-scan.c     |  119 +++++++++++++++++++++++++++++++++++++++++++++++++
>   src/extent-scan.h     |    5 ++
>   tests/Makefile.am     |    1 +
>   tests/cp/sparse-lseek |   56 +++++++++++++++++++++++
>   4 files changed, 181 insertions(+), 0 deletions(-)
>   create mode 100755 tests/cp/sparse-lseek
>
> diff --git a/src/extent-scan.c b/src/extent-scan.c
> index da7eb9d..a54eca0 100644
> --- a/src/extent-scan.c
> +++ b/src/extent-scan.c
> @@ -17,7 +17,9 @@
>      Written by Jie Liu (jeff.liu@oracle.com).  */
>
>   #include<config.h>
> +#include<fcntl.h>
>   #include<sys/types.h>
> +#include<sys/stat.h>
>   #include<sys/ioctl.h>
>   #include<sys/utsname.h>
>   #include<assert.h>
> @@ -71,6 +73,9 @@ extent_scan_init (int src_fd, struct extent_scan *scan)
>     scan->initial_scan_failed = false;
>     scan->hit_final_extent = false;
>     scan->fm_flags = extent_need_sync () ? FIEMAP_FLAG_SYNC : 0;
> +#if defined (SEEK_DATA)&&  defined (SEEK_HOLE)
> +  scan->src_total_size = 0;
> +#endif
>   }
>
>   #ifdef __linux__
> @@ -204,6 +209,120 @@ extent_scan_read (struct extent_scan *scan)
>
>     return true;
>   }
> +#elif defined (SEEK_HOLE)&&  defined (SEEK_DATA)
> +extern bool
> +extent_scan_read (struct extent_scan *scan)
> +{
> +  off_t data_pos, hole_pos;
> +  union { struct extent_info ei; char c[4096]; } extent_buf;
> +  struct extent_info *ext_info =&extent_buf.ei;
> +  enum { count = (sizeof extent_buf / sizeof *ext_info) };
> +  verify (count != 0);
> +
> +  memset (&extent_buf, 0, sizeof extent_buf);
> +
> +  if (scan->scan_start == 0)
> +    {
> +# ifdef _PC_MIN_HOLE_SIZE
> +      /* To determine if the underlaying file system support
> +         SEEK_HOLE.  If not, fall back to the standard copy.  */
> +      if (fpathconf (scan->fd, _PC_MIN_HOLE_SIZE)<  0)
> +        {
> +          scan->initial_scan_failed = true;
> +          return false;
> +        }
> +# endif
> +
> +      /* If we have been compiled on an OS that supports SEEK_HOLE
> +         but run on an OS that does not support SEEK_HOLE, we get
> +         EINVAL.  If the underlying file system does not support the
> +         SEEK_HOLE call, we get ENOTSUP, setting initial_scan_failed
> +         to true to fall back to the standard copy in either case.  */
> +      hole_pos = lseek (scan->fd, (off_t) 0, SEEK_HOLE);
> +      if (hole_pos<  0)
> +        {
> +          if (errno == EINVAL || errno == ENOTSUP)
> +            scan->initial_scan_failed = true;
> +          return false;
> +        }
> +
> +      /* Seek back to position 0 first.  */
> +      if (hole_pos>  0)
> +        {
> +          if (lseek (scan->fd, (off_t) 0, SEEK_SET)<  0)
> +            return false;
> +        }
> +
> +      struct stat sb;
> +      if (fstat (scan->fd,&sb)<  0)
> +        return false;
> +
> +      /* This is definitely not a sparse file, we treat it as a big extent.  */
> +      if (hole_pos>= sb.st_size)
> +        {
> +          scan->ei_count = 1;
> +          scan->ext_info = xnmalloc (scan->ei_count, sizeof (struct extent_info));
> +          scan->ext_info[0].ext_logical = 0;
> +          scan->ext_info[0].ext_length = sb.st_size;
> +          scan->hit_final_extent = true;
> +          return true;
> +        }
> +      scan->src_total_size = sb.st_size;
> +    }
> +
> +  unsigned int i = 0;
> +  /* If lseek(2) failed and the errno is set to ENXIO, for
> +     SEEK_DATA there are no more data regions past the supplied
> +     offset.  For SEEK_HOLE, there are no more holes past the
> +     supplied offset.  Set scan->hit_final_extent to true in
> +     either case.  */
> +  while (scan->scan_start<  scan->src_total_size&&  i<  count)
> +    {
> +      data_pos = lseek (scan->fd, scan->scan_start, SEEK_DATA);
> +      if (data_pos<  0)
> +        {
> +          if (errno == ENXIO)
> +            {
> +              scan->hit_final_extent = true;
> +              break;
> +            }
> +          return false;
> +        }
> +
> +      hole_pos = lseek (scan->fd, data_pos, SEEK_HOLE);
> +      if (hole_pos<  0)
> +        {
> +          if (errno == ENXIO)
> +            {
> +              scan->hit_final_extent = true;
> +              hole_pos = scan->src_total_size;
> +              if (data_pos<  hole_pos)
> +                goto preserve_ext_info;
> +              break;
> +            }
> +          return false;
> +        }
> +
> +preserve_ext_info:
> +      ext_info[i].ext_logical = data_pos;
> +      ext_info[i].ext_length = hole_pos - data_pos;
> +      scan->scan_start = hole_pos;
> +      ++i;
> +    }
> +
> +  scan->ei_count = i;
> +  scan->ext_info = xnmalloc (scan->ei_count, sizeof (struct extent_info));
> +
> +  for (i = 0; i<  scan->ei_count; i++)
> +    {
> +      assert (ext_info[i].ext_logical<= OFF_T_MAX);
> +
> +      scan->ext_info[i].ext_logical = ext_info[i].ext_logical;
> +      scan->ext_info[i].ext_length = ext_info[i].ext_length;
> +    }
> +
> +  return (lseek (scan->fd, (off_t) 0, SEEK_SET)<  0) ? false : true;
> +}
>   #else
>   extern bool
>   extent_scan_read (struct extent_scan *scan ATTRIBUTE_UNUSED)
> diff --git a/src/extent-scan.h b/src/extent-scan.h
> index 5b4ded5..4fc05c6 100644
> --- a/src/extent-scan.h
> +++ b/src/extent-scan.h
> @@ -38,6 +38,11 @@ struct extent_scan
>     /* File descriptor of extent scan run against.  */
>     int fd;
>
> +# if defined (SEEK_DATA)&&  defined (SEEK_HOLE)
> +  /* Source file size, i.e, (struct stat)&statbuf.st_size.  */
> +  size_t src_total_size;
> +#endif
> +
>     /* Next scan start offset.  */
>     off_t scan_start;
>
> diff --git a/tests/Makefile.am b/tests/Makefile.am
> index 685eb52..6c596b9 100644
> --- a/tests/Makefile.am
> +++ b/tests/Makefile.am
> @@ -28,6 +28,7 @@ root_tests =					\
>     cp/cp-mv-enotsup-xattr			\
>     cp/capability					\
>     cp/sparse-fiemap				\
> +  cp/sparse-lseek                               \
>     dd/skip-seek-past-dev				\
>     install/install-C-root			\
>     ls/capability					\
> diff --git a/tests/cp/sparse-lseek b/tests/cp/sparse-lseek
> new file mode 100755
> index 0000000..5b8f2c1
> --- /dev/null
> +++ b/tests/cp/sparse-lseek
> @@ -0,0 +1,56 @@
> +#!/bin/sh
> +# Test cp --sparse=always through lseek(SEEK_DATA/SEEK_HOLE) copy
> +
> +# Copyright (C) 2010-2011 Free Software Foundation, Inc.
> +
> +# This program is free software: you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License as published by
> +# the Free Software Foundation, either version 3 of the License, or
> +# (at your option) any later version.
> +
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +
> +# You should have received a copy of the GNU General Public License
> +# along with this program.  If not, see<http://www.gnu.org/licenses/>.
> +
> +. "${srcdir=.}/init.sh"; path_prepend_ ../src
> +print_ver_ cp
> +$PERL -e 1 || skip_test_ 'you lack perl'
> +
> +zfsdisk=diskX
> +zfspool=seektest
> +
> +require_root_
> +
> +cwd=$PWD
> +cleanup_() { zpool destroy $zfspool; }
> +
> +skip=0
> +mkfile 128m "$cwd/$zfsdisk" || skip=1
> +
> +# Check if the seektest pool is already exists
> +zpool list $zfspool 2>/dev/null&&
> +  skip_test_ "$zfspool already exists"
> +
> +# Create pool and verify if it is mounted automatically
> +zpool create $zfspool "$cwd/$zfsdisk" || skip=1
> +zpool list $zfspool>/dev/null || skip=1
> +
> +test $skip = 1&&  skip_test_ "insufficient ZFS support"
> +
> +for i in $(seq 1 2 21); do
> +  for j in 1 2 31 100; do
> +    $PERL -e 'BEGIN { $n = '$i' * 1024; *F = *STDOUT }' \
> +          -e 'for (1..'$j') { sysseek (*F, $n, 1)' \
> +          -e '&&  syswrite (*F, chr($_)x$n) or die "$!"}'>  /$zfspool/j1 || fail=1
> +
> +    cp --sparse=always /$zfspool/j1 /$zfspool/j2 || fail=1
> +    cmp /$zfspool/j1 /$zfspool/j2 || fail=1
> +    test $fail = 1&&  break 2
> +  done
> +done
> +
> +Exit $fail
