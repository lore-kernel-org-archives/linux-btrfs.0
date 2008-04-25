From: Sage Weil <sage@newdream.net>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 25 Apr 2008 13:28:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804251320390.23551@cobra.newdream.net>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
 <200804250941.35343.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804250941.35343.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Apr 2008, Chris Mason wrote:
> Very cool.  I'd actually loved to see this wrapped into a program that will 
> cow a directory tree.  Basically the same as cp -al, but with cow instead of 
> linking.

Here's a pretty trivial patch against cp in coreutils-6.10.  It'll 
probably take you more time to build than to make the changes yourself, 
but this seems much handier and more robust than a separate tool.

$ cp -ac /mnt/btrfs/from /mnt/btrfs/to
...

sage


diff -ur coreutils-6.10/src/copy.c coreutils-6.10-btrfs/src/copy.c
--- coreutils-6.10/src/copy.c	2008-01-05 14:59:11.000000000 -0800
+++ coreutils-6.10-btrfs/src/copy.c	2008-04-25 13:12:20.000000000 -0700
@@ -537,6 +537,9 @@
     buf_alloc = xmalloc (buf_size + buf_alignment_slop);
     buf = ptr_align (buf_alloc, buf_alignment);
 
+#define BTRFS_IOC_CLONE 0x40049409
+    if (!x->cow ||
+	ioctl(dest_desc, BTRFS_IOC_CLONE, source_desc) != 0)
     for (;;)
       {
 	word *wp = NULL;
diff -ur coreutils-6.10/src/copy.h coreutils-6.10-btrfs/src/copy.h
--- coreutils-6.10/src/copy.h	2008-01-05 14:58:25.000000000 -0800
+++ coreutils-6.10-btrfs/src/copy.h	2008-04-25 12:46:30.000000000 -0700
@@ -135,6 +135,8 @@
      on different file systems from the one we started on.  */
   bool one_file_system;
 
+  bool cow;
+
   /* If true, attempt to give the copies the original files' permissions,
      owner, group, and timestamps. */
   bool preserve_ownership;
diff -ur coreutils-6.10/src/cp.c coreutils-6.10-btrfs/src/cp.c
--- coreutils-6.10/src/cp.c	2008-01-11 03:19:53.000000000 -0800
+++ coreutils-6.10-btrfs/src/cp.c	2008-04-25 13:23:12.000000000 -0700
@@ -125,6 +125,7 @@
   {"archive", no_argument, NULL, 'a'},
   {"backup", optional_argument, NULL, 'b'},
   {"copy-contents", no_argument, NULL, COPY_CONTENTS_OPTION},
+  {"cow", no_argument, NULL, 'c'},
   {"dereference", no_argument, NULL, 'L'},
   {"force", no_argument, NULL, 'f'},
   {"interactive", no_argument, NULL, 'i'},
@@ -178,6 +179,7 @@
       --backup[=CONTROL]       make a backup of each existing destination file\n\
   -b                           like --backup but does not accept an argument\n\
       --copy-contents          copy contents of special files when recursive\n\
+  -c, --cow                    attempt issuing copy-on-write ioctl to fs\n\
   -d                           same as --no-dereference --preserve=links\n\
 "), stdout);
       fputs (_("\
@@ -767,6 +769,7 @@
   x->interactive = I_UNSPECIFIED;
   x->move_mode = false;
   x->one_file_system = false;
+  x->cow = false;
 
   x->preserve_ownership = false;
   x->preserve_links = false;
@@ -909,7 +912,7 @@
      we'll actually use backup_suffix_string.  */
   backup_suffix_string = getenv ("SIMPLE_BACKUP_SUFFIX");
 
-  while ((c = getopt_long (argc, argv, "abdfHilLprst:uvxPRS:T",
+  while ((c = getopt_long (argc, argv, "abcdfHilLprst:uvxPRS:T",
 			   long_opts, NULL))
 	 != -1)
     {
@@ -940,6 +943,10 @@
 	  copy_contents = true;
 	  break;
 
+	case 'c':
+	  x.cow = true;
+	  break;
+
 	case 'd':
 	  x.preserve_links = true;
 	  x.dereference = DEREF_NEVER;
