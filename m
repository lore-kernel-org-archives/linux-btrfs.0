Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:59726 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab3A2Oyd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 09:54:33 -0500
Date: Tue, 29 Jan 2013 09:54:29 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Sage Weil <sage@inktank.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "j.michael.lowe@gmail.com" <j.michael.lowe@gmail.com>,
        "billk@iinet.net.au" <billk@iinet.net.au>
Subject: Re: corrupted file size on inline extent conversion?
Message-ID: <20130129145429.GD3660@localhost.localdomain>
References: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 05:12:12PM -0700, Sage Weil wrote:
> A ceph user observed a incorrect i_size on btrfs.  The pattern looks like 
> this:
> 
> - some writes at low file offsets
> - a write to 4185600 len 8704 (i_size should be 4MB)
> - more writes to low offsets
> - a write to 4181504 len 4096 (abutts the write above)
> - a bit of time goes by...
> - stat returns 4186112 (4MB - 8192)
>  - that's a fwe bytes to the right of the top write above.
> 
> There are some logs showing the full read/write activity to the file at
> 
> 	http://tracker.newdream.net/attachments/658/object_log.txt
> 
> on issue
> 
> 	http://tracker.newdream.net/issues/3810
> 
> The kernel was 3.7.0-030700-generic (and probably also observed on 3.7.1).
> 
> Is this a known bug?

Not known but I took a long hard look at our ordered i size updating and I think
I spotted the bug.  Could you run this patch and see if you get the printk?  If
you do then that was the problem and you should be good to go.  It definitely
needs to be fixed, hopefully it's also your bug.  Thanks,

Josef


diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index cbd4838..dbd4905 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -895,8 +895,14 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	 * if the disk i_size is already at the inode->i_size, or
 	 * this ordered extent is inside the disk i_size, we're done
 	 */
-	if (disk_i_size == i_size || offset <= disk_i_size) {
+	if (disk_i_size == i_size)
 		goto out;
+
+	if (offset <= disk_i_size) {
+		if (ordered && ordered->outstanding_isize > disk_i_size)
+			printk(KERN_ERR "this would have bitten us in the ass\n");
+		else
+			goto out;
 	}
 
 	/*
