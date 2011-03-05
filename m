From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Sat, 5 Mar 2011 10:50:14 -0600
Message-ID: <AANLkTi=gqurEsoMZv+10Np4duOKq4kZf77mTgu6BfkSC@mail.gmail.com>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>
	<AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>
	<1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
	<1299203447-sup-9359@think>
	<1299241124-sup-3502@think>
	<BAY156-w4980F081E2593ACCC07B2AD2C20@phx.gbl>
	<AANLkTikFVd3kG4J99BQvVUwb05DRQXLyabsHieeTZCBW@mail.gmail.com>
	<AANLkTinjtx37eJ+v6WS=Y8z_Brkb9YGq5cZdFP1bVWGB@mail.gmail.com>
	<BAY156-w342CF81501D00C36A69EABD2C50@phx.gbl>
	<AANLkTimDvTraBapv18iOf8wmUh8nSnUay2etXvjEv77P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, xin.zhong@intel.com,
	linux-btrfs@vger.kernel.org
To: Xin Zhong <thierryzhong@hotmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimDvTraBapv18iOf8wmUh8nSnUay2etXvjEv77P@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I've constructed a test patch that is currently addressing all the
issues on my system.

The portion of Openmotif that was having issues with page faults works
correctly with this patch, and gcc-4.4.5 builds without issue.

I extracted only the portion of the first patch that corrects the
handling of dirty_pages when copied==0, and incorporated the second
patch that falls back to one-page-at-a-time if there are troubles with
page faults.

--- fs/btrfs/file.c	2011-03-05 07:34:43.025131607 -0600
+++ /usr/src/linux/fs/btrfs/file.c	2011-03-05 07:41:45.001260294 -0600
@@ -1023,8 +1023,20 @@

 		copied = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, &i);
-		dirty_pages = (copied + offset + PAGE_CACHE_SIZE - 1) >>
-				PAGE_CACHE_SHIFT;
+
+		/*
+		 * if we have trouble faulting in the pages, fall
+		 * back to one page at a time
+		 */
+		if (copied < write_bytes)
+			nrptrs = 1;
+
+		if (copied == 0)
+			dirty_pages = 0;
+		else
+			dirty_pages = (copied + offset +
+				       PAGE_CACHE_SIZE - 1) >>
+				       PAGE_CACHE_SHIFT;

 		if (num_pages > dirty_pages) {
 			if (copied > 0)
