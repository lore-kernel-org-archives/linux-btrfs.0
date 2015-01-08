Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:33835 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbbAHKwf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 05:52:35 -0500
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: Lennart Poettering <lennart@poettering.net>
Subject: Re: btrfs_inode_item's otime?
Date: Thu, 08 Jan 2015 21:52:30 +1100
Message-ID: <2188846.ArnMyWRJKN@quad>
In-Reply-To: <20150106184100.GF24104@twin.jikos.cz>
References: <20150105172152.GB19126@gardel-login> <3797928.30urVis5AR@quad> <20150106184100.GF24104@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

Sorry for the delay, took a while to poke around the code to figure
out possible ways it would get done (and what the right structure was).

On Tue, 6 Jan 2015 07:41:00 PM David Sterba wrote:

> Set the otime in btrfs_new_inode after the call to fill_inode_item.

Hmm, so something like this then?

Unfortunately I won't have a test system to try this on for a little while.


diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0..60bcc72 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5835,6 +5835,11 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
                             sizeof(*inode_item));
        fill_inode_item(trans, path->nodes[0], inode_item, inode);
 
+       /*
+        * Set the creation time on the inode.
+        */
+       btrfs_set_stack_timespec_sec( &inode.otime, cur_time.tv_sec );
+
        if (name) {
                ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
                                     struct btrfs_inode_ref);


-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


