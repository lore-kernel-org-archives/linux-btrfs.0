Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52601 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab2JERnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 13:43:19 -0400
Date: Fri, 5 Oct 2012 13:43:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Out of memory condition
Message-ID: <20121005174316.GQ2370@localhost.localdomain>
References: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
 <CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
 <20121003205247.GO2370@localhost.localdomain>
 <CALJXSJrbe62q6XCOf5xB6ra1kwSOnVyL6DvYqS7ncyUQndfkgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CALJXSJrbe62q6XCOf5xB6ra1kwSOnVyL6DvYqS7ncyUQndfkgw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 05, 2012 at 11:20:37AM -0600, Jérôme Poulin wrote:
> I was able to reproduce the problem with the patch, now it fails in
> extens_io.c instead of the compression module.
> 

Yeah so I fixed the compression side, and now it's erroring out further down.
So leave the patch I gave you applied as it is correct, and apply this patch and
see if it helps.  Thanks,

Josef

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b82d244..8c37cb6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2751,12 +2751,15 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
 					 this_bio_flag);
-			BUG_ON(ret == -ENOMEM);
-			nr++;
-			*bio_flags = this_bio_flag;
+			if (!ret) {
+				nr++;
+				*bio_flags = this_bio_flag;
+			}
 		}
-		if (ret)
+		if (ret) {
 			SetPageError(page);
+			unlock_extent(tree, cur, cur + iosize - 1);
+		}
 		cur = cur + iosize;
 		pg_offset += iosize;
 	}
