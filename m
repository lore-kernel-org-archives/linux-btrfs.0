From: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH][BUGFIX] readahead: fix NULL filp dereference
Date: Fri, 2 Apr 2010 15:27:50 +0800
Message-ID: <20100402072750.GA22952@localhost>
References: <cc557aab1003250606g6b4e3e7dgb1adfd46adc89124@mail.gmail.com> <3d0408631003252040r70c54b2fm24d64b819c59c9c@mail.gmail.com> <20100326040114.GA20717@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng " <yanzheng@21cn.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"kirill@shutemov.name" <kirill@shutemov.name>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100326040114.GA20717@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs relocate_file_extent_cluster() calls us with NULL filp:

  [ 4005.426805] BUG: unable to handle kernel NULL pointer dereference at 00000021
  [ 4005.426818] IP: [<c109a130>] page_cache_sync_readahead+0x18/0x3e

CC: Yan Zheng <yanzheng@21cn.com>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

Andrew and Greg:

This is an obvious correct bug fix for .34 and .33-stable,
so I'm resending it directly to you without Kirill's confirmation.


--- sound-2.6.orig/mm/readahead.c	2010-03-26 11:51:57.000000000 +0800
+++ sound-2.6/mm/readahead.c	2010-03-26 11:52:11.000000000 +0800
@@ -502,7 +502,7 @@ void page_cache_sync_readahead(struct ad
 		return;
 
 	/* be dumb */
-	if (filp->f_mode & FMODE_RANDOM) {
+	if (filp && (filp->f_mode & FMODE_RANDOM)) {
 		force_page_cache_readahead(mapping, filp, offset, req_size);
 		return;
 	}
