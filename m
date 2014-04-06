Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58271 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaDFASp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 20:18:45 -0400
Date: Sat, 5 Apr 2014 17:18:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140406001838.GA9485@merlins.org>
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 04, 2014 at 04:20:41PM +0100, Filipe David Borba Manana wrote:
> This new send flag makes send calculate first the amount of new file data (in bytes)
> the send root has relatively to the parent root, or for the case of a non-incremental
> send, the total amount of file data we will send through the send stream. In other words,
> it computes the sum of the lengths of all write and clone operations that will be sent
> through the send stream.

Thanks for this patch, much appreciated.

A few questions:
1) I tried to apply to 3.14.0, and it all applied except one line:
--- fs/btrfs/send.c
+++ fs/btrfs/send.c
@@ -3091,6 +3121,8 @@
 	int ret;
 	u64 ancestor = 0;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	name = fs_path_alloc();
 	from_path = fs_path_alloc();
 	if (!name || !from_path) {

I looked around and found nothing that looked similar enough.
Obviously it's an assert, so I can run without it, but my source being
very different from yours just made me want to check that this was most
likely ok to run with 3.14.0.

2) I saw the concerns about protocol incompatibility. Is it an issue if you run without -o
too?

3) Do you have a patch for btrfs-tools so that I can try it, or a git
tree of btrfs-tools with this that I should pull?

4) Can I run btrfs send -o snap1 snap2 >/dev/null to get quick stats
on the changes between the 2 snapshots, or is it still going to walk
through all the data blocks and send them to /dev/null afterwards?
 
Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
