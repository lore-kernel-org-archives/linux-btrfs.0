From: Sten Heinze <sten.heinze@gmx.de>
Subject: Re: Patch: Allow options to be passed to btrfsck
Date: Thu, 11 Feb 2010 14:09:39 +0100
Message-ID: <201002111409.39348.sten.heinze@gmx.de>
References: <4B71B538.1040709@debian.org> <201002111359.43978.sten.heinze@gmx.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TGAdLaypiJeFw/q"
Cc: 567681@bugs.debian.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002111359.43978.sten.heinze@gmx.de>
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_TGAdLaypiJeFw/q
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

[This time with the patch attached.]

[Please CC: me, as I am not subscribed to the linux-btrfs mailing list.]

This patch makes btrfsck ignore (for now) options passed to it. This makes 
btrfsck runs on startup not failing. I was asked to post my patch here by the 
Debian Maintainer of btrfs-tools.

Background: On Startup all filesystem (on a Debian system) are fsck'ed. A 
option to allow non-interactive filesystem checks on startup is passed to fsck, 
usually -a or -y.
Currently btrfsck expects the device as the only parameter and fails if run 
with any option e.g. btrfsck -a /dev/hda1 (returns error code 1). My patch 
fixes this by allowing options to be passed, although all options are ignored 
at the moment. (The attached patch is slightly improved from the one I sent to 
the Debian bug report [1] before.)

Please comment if this is acceptable for inclusion in btrfsck. If not, I would 
be happy to improve the patch.
 
Thanks,
Sten

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=567681

--Boundary-00=_TGAdLaypiJeFw/q
Content-Type: text/x-patch;
  charset="UTF-8";
  name="08-allow-fsck-options.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="08-allow-fsck-options.patch"

Index: btrfs-tools/btrfsck.c
===================================================================
--- btrfs-tools.orig/btrfsck.c	2010-02-08 05:44:01.037134357 +0100
+++ btrfs-tools/btrfsck.c	2010-02-11 05:02:15.469358404 +0100
@@ -2807,7 +2807,7 @@
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfsck dev\n");
+	fprintf(stderr, "usage: btrfsck [option] dev\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -2821,9 +2821,24 @@
 	if (ac < 2)
 		print_usage();
 
+	char *file = av[ac - 1];
+	int pos;
+	for( pos = 1; pos < ac; ++pos)
+	{
+		/* ignore all options for now, stop at first device found */
+		if (av[pos][0] != '-')
+		{
+			file = av[pos];
+			break;
+		}
+	}
+
+	/* print device fsck'ed */
+	printf("%s: ", file);
+
 	radix_tree_init();
 	cache_tree_init(&root_cache);
-	root = open_ctree(av[1], 0, 0);
+	root = open_ctree(file, 0, 0);
 
 	if (root == NULL)
 		return 1;

--Boundary-00=_TGAdLaypiJeFw/q--
