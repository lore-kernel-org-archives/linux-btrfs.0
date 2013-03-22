Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34097 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516Ab3CVPy4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 11:54:56 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6E1AC9A068A
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 09:54:56 -0600 (MDT)
Date: Fri, 22 Mar 2013 11:54:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130322155453.GD1955@localhost.localdomain>
References: <514ABEB8.3090104@profihost.ag>
 <20130321180020.30044.84729@localhost.localdomain>
 <967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag>
 <20130321190249.30044.79438@localhost.localdomain>
 <514B62A4.1030201@profihost.ag>
 <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag>
 <514C4A8C.90607@profihost.ag>
 <20130322135322.GB1955@localhost.localdomain>
 <514C6319.7030400@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <514C6319.7030400@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 22, 2013 at 07:56:41AM -0600, Stefan Priebe - Profihost AG wrote:
> Hi Josef,
> Am 22.03.2013 14:53, schrieb Josef Bacik:
> > On Fri, Mar 22, 2013 at 06:11:56AM -0600, Stefan Priebe - Profihost AG wrote:
> >> Hi Chris,
> >>
> >>>>>>> Which kernel are you running?
> >>>>>>>
> >>>>>>> -chris
> >>>>>>
> >>>>>> vanilla 3.8.3.
> >>>>>
> >>>>> Ok, with the 3.9 merge window Josef changed how we do the reservations.
> >>>>> Are you able to try a slightly more experimental kernel?
> >>
> >> any ideas what i can check? 3.9-rc3 gives me same results.
> >>
> > 
> > Sorry Stefan I'm almost done with what I'm working on and then I'll work up a
> > patch for you to run so I can narrow down what's going on.  Thanks,
> 
> Great!
> 
> Thanks - just wanted to know that it's not my fault. I'm happy to test
> the patch and provide feedback.
> 

Ok I think we are way over-reserving for rename, can you give this patch a whirl
and see what happens?  If it still fails can you capture dmesg and reply with
that so I can see what's going on.  Thanks,

Josef


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9ac2eca..aabaea6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4161,6 +4161,11 @@ out:
 			ret = 0;
 	}
 	if (flushing) {
+		if (ret == -ENOSPC) {
+			printk(KERN_ERR "returning enospc, dumping space info\n");
+			dump_space_info(space_info, 0, 0);
+		}
+
 		spin_lock(&space_info->lock);
 		space_info->flush = 0;
 		wake_up_all(&space_info->wait);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca1b767..3980ae7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3679,11 +3679,9 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	 * 1 for the dir item
 	 * 1 for the dir index
 	 * 1 for the inode ref
-	 * 1 for the inode ref in the tree log
-	 * 2 for the dir entries in the log
 	 * 1 for the inode
 	 */
-	trans = btrfs_start_transaction(root, 8);
+	trans = btrfs_start_transaction(root, 5);
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
@@ -8127,7 +8125,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
 	 * should cover the worst case number of items we'll modify.
 	 */
-	trans = btrfs_start_transaction(root, 20);
+	trans = btrfs_start_transaction(root, 11);
 	if (IS_ERR(trans)) {
                 ret = PTR_ERR(trans);
                 goto out_notrans;
-- 
1.7.7.6

