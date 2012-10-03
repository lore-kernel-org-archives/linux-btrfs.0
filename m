Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53800 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab2JCUxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 16:53:19 -0400
Date: Wed, 3 Oct 2012 16:52:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Out of memory condition
Message-ID: <20121003205247.GO2370@localhost.localdomain>
References: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
 <CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 08:25:11AM -0600, Jérôme Poulin wrote:
> I don't know how to diagnose the problem, but now it is the second
> time. After starting a VM in VirtualBox and filling the memory, Chrome
> stopped loading any pages. After logging out and on, it still wasn't
> working, reboot fixed it.
> 
> This time, I've had the same problem and took the backtrace. Chrome
> starts but doesn't load any pages, I guess it is stuck reading a file
> as many chrome process are in state 'Ds' but are still killable,
> Chrome seems really hard to strace bu anyway strace freezes in D state
> too when attached to a running process.
> 
> The whole filesystem is BTRFS.
> 

Can you give this a try please?  Thanks,

Josef

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 43d1c5a..36eb5f2 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -577,6 +577,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	u64 em_start;
 	struct extent_map *em;
 	int ret = -ENOMEM;
+	int faili = 0;
 	u32 *sums;
 
 	tree = &BTRFS_I(inode)->io_tree;
@@ -626,8 +627,11 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
 		cb->compressed_pages[pg_index] = alloc_page(GFP_NOFS |
 							      __GFP_HIGHMEM);
-		if (!cb->compressed_pages[pg_index])
+		if (!cb->compressed_pages[pg_index]) {
+			faili = pg_index - 1;
+			ret = -ENOMEM;
 			goto fail2;
+		}
 	}
 	cb->nr_pages = nr_pages;
 
@@ -713,8 +717,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	return 0;
 
 fail2:
-	for (pg_index = 0; pg_index < nr_pages; pg_index++)
-		free_page((unsigned long)cb->compressed_pages[pg_index]);
+	while (faili >= 0) {
+		__free_page(cb->compressed_pages[pg_index]);
+		faili--;
+	}
 
 	kfree(cb->compressed_pages);
 fail1:
