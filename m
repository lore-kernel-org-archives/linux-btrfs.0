From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [MeeGo-dev] Btrfs as default file system
Date: Fri, 14 May 2010 06:47:24 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1005140634170.12512@bogon.housecafe.de>
References: <1273575646.2336.9.camel@sanganak> <4BE95584.7000204@linux.intel.com> <1273583736.2336.105.camel@sanganak> <20100511131844.GB27606@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ameya Palande <ameya.palande@nokia.com>,
	ext Arjan van de Ven <arjan@linux.intel.com>,
	"meego-dev@meego.com" <meego-dev@meego.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100511131844.GB27606@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 11 May 2010 at 09:18, Chris Mason wrote:
> It is too late for such a change in 2.6.34, Linus announced the final RC
> this week.  But I'll have this queued in my .35 releases.

Hm, I'd consider such a Kconfig file change to be cosmetic only and could 
be included during the RC series. Anyway, .35 is probably fine too.

> If meego would like to include a patch for this in their kernel, I'd be
> happy to send it along.

If no-one sends a patch, how about:

  -----------------
  Remove EXPERIMENTAL flag from btrfs and also state that the disk format 
  has indeed been finalized.

  Signed-off-by: Christian Kujau <lists@nerdbynature.de>

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 64087c3..da67070 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -12,9 +12,9 @@ number of challenges with scaling to the large storage subsystems that
 are becoming common in today's data centers. Filesystems need to scale
 in their ability to address and manage large storage, and also in
 their ability to detect, repair and tolerate errors in the data stored
-on disk.  Btrfs is under heavy development, and is not suitable for
-any uses other than benchmarking and review. The Btrfs disk format is
-not yet finalized.
+on disk.  Btrfs is under heavy development, but with Linux 2.6.31 the
+Btrfs disk format has been finalized and is not considered experimental
+any more.
 
 The main Btrfs features include:
 
@@ -33,6 +33,7 @@ The main Btrfs features include:
     * Efficient incremental backup and FS mirroring (not yet implemented)
     * Online filesystem defragmentation
 
+Please see https://btrfs.wiki.kernel.org for details on these features.
 
 
 	MAILING LIST
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 7bb3c02..cebb197 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -1,16 +1,12 @@
 config BTRFS_FS
-	tristate "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
-	depends on EXPERIMENTAL
+	tristate "Btrfs filesystem"
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	help
 	  Btrfs is a new filesystem with extents, writable snapshotting,
-	  support for multiple devices and many more features.
-
-	  Btrfs is highly experimental, and THE DISK FORMAT IS NOT YET
-	  FINALIZED.  You should say N here unless you are interested in
-	  testing Btrfs with non-critical data.
+	  support for multiple devices and many more features. For more
+	  information, please see https://btrfs.wiki.kernel.org.
 
 	  To compile this file system support as a module, choose M here. The
 	  module will be called btrfs.
-- 
BOFH excuse #186:

permission denied
