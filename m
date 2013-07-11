Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab3GKXTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 19:19:45 -0400
Date: Thu, 11 Jul 2013 16:19:42 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Message-ID: <20130711231942.GI25414@lenny.home.zabbo.net>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130701125435.GE4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130701125435.GE4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 01, 2013 at 08:54:35AM -0400, Josef Bacik wrote:
> On Tue, Jun 04, 2013 at 06:17:54PM -0400, Zach Brown wrote:
> > 
> > I finally sat down to fix that readdir hang that has been in the back
> > of my mind for a while.  I *hope* that the fix is pretty simple: just
> > don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> > indicator that we shouldn't return entries.  Does this look reasonable?
>
> One of these patches is making new entries not show up in readdir.  This was
> discovered while running stress.sh overnight, it complained about files not
> matching but when they were checked the files matched.  Dropping the entire
> series made stress.sh run fine.  So I'm dropping these for the next merge window
> but I'll dig into it and try and figure out what was causing the problem.

OK, how about this.

First, just drop the series.  Most of it was opportunistic cleanups that
I saw as I was reading the code.  But it certainly isn't a comprehensive
cleanup.  We'd still want to go back later and fix how inefficient the
delayed item data structures are for readdir.  So from some perspective
it's just risky churn with little upside.

And I think I found a much simpler way to stop the current readdir from
looping instead of mucking around with f_version.  Just use LLONG_MAX if
entries have already overflowed INT_MAX.

We'd still want real freed offset reuse some day, but that's a bunch of
work that'll have to be done very carefully.  This will at least stop
64bit apps from failing with offsets past 64bits and is very low risk.

So just add this patch and forget about the rest of the series?

It'll still technically conflict with the s/filp->f_pos/ctx->pos/ in the
readdir interface change in -next but that fixup is trivial.

- z

>From e295deb0f56f846738ee3dec63fe0350f3952503 Mon Sep 17 00:00:00 2001
From: Zach Brown <zab@redhat.com>
Date: Wed, 10 Jul 2013 19:48:51 -0400
Subject: [PATCH] btrfs: don't loop on large offsets in readdir

When btrfs readdir() hits the last entry it sets the readdir offset to a
huge value to stop buggy apps from breaking when the same name is
returned by readdir() with concurrent rename()s.

But unconditionally setting the offset to INT_MAX causes readdir() to
loop returning any entries with offsets past INT_MAX.  It only takes a
few hours of constant file creation and removal to create entries past
INT_MAX.

So let's set the huge offset to LLONG_MAX if the last entry has already
overflowed 32bit loff_t.   Without large offsets behaviour is identical.
With large offsets 64bit apps will work and 32bit apps will be no more
broken than they currently are if they see large offsets.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/inode.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c157482..8583e8d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5186,14 +5186,31 @@ next:
 	}
 
 	/* Reached end of directory/root. Bump pos past the last item. */
-	if (key_type == BTRFS_DIR_INDEX_KEY)
-		/*
-		 * 32-bit glibc will use getdents64, but then strtol -
-		 * so the last number we can serve is this.
-		 */
-		filp->f_pos = 0x7fffffff;
-	else
-		filp->f_pos++;
+	filp->f_pos++;
+
+	/* 
+	 * Stop new entries from being returned after we return the last
+	 * entry.
+	 *
+	 * New directory entries are assigned a strictly increasing
+	 * offset.  This means that new entries created during readdir
+	 * are *guaranteed* to be seen in the future by that readdir.
+	 * This has broken buggy programs which operate on names as
+	 * they're returned by readdir.  Until we re-use freed offsets
+	 * we have this hack to stop new entries from being returned
+	 * under the assumption that they'll never reach this huge
+	 * offset.
+	 *
+	 * This is being careful not to overflow 32bit loff_t unless the
+	 * last entry requires it because doing so has broken 32bit apps
+	 * in the past.
+	 */
+	if (key_type == BTRFS_DIR_INDEX_KEY) {
+		if (filp->f_pos >= INT_MAX)
+			filp->f_pos = LLONG_MAX;
+		else
+			filp->f_pos = INT_MAX;
+	}
 nopos:
 	ret = 0;
 err:
-- 
1.7.11.7

