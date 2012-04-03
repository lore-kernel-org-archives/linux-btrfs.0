From: Dave Jones <davej@redhat.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Tue, 3 Apr 2012 13:07:50 -0400
Message-ID: <20120403170750.GB10975@redhat.com>
References: <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
 <20120403142607.GA14083@ds.suse.cz>
 <20120403162023.GA7227@redhat.com>
 <20120403163343.GD14083@ds.suse.cz>
 <20120403165055.GA10975@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: David Sterba <dsterba@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120403165055.GA10975@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2012 at 12:50:55PM -0400, Dave Jones wrote:
 > On Tue, Apr 03, 2012 at 06:33:43PM +0200, David Sterba wrote:
 >  > On Tue, Apr 03, 2012 at 12:20:23PM -0400, Dave Jones wrote:
 >  > > I see a lot of these ..
 >  > > 
 >  > > btrfs: __btrfs_end_transaction -EIO abored=1802201963 (no super error)
 >  > 
 >  > 1802201963 == 0x6b6b6b6b
 >  > 
 >  > #define POISON_FREE     0x6b    /* for use-after-free poisoning */
 >  > 
 >  > hmm
 > 
 > wait, what...
 > 
 >  535         memset(trans, 0, sizeof(*trans));
 >  536         kmem_cache_free(btrfs_trans_handle_cachep, trans);
 >  537 
 >  538         if (throttle)
 >  539                 btrfs_run_delayed_iputs(root);
 >  540 
 >  541         if (trans->aborted ||
 >  542             root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 >  543                 return -EIO;
 >  544         }
 > 
 > that looks like a pretty clear use-after-free.

Ok, trying this..


diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8da29e8..11b77a5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -480,6 +480,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *info = root->fs_info;
 	int count = 0;
+	int err = 0;
 
 	if (--trans->use_count) {
 		trans->block_rsv = trans->orig_rsv;
@@ -532,18 +533,18 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
-	memset(trans, 0, sizeof(*trans));
-	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 
 	if (throttle)
 		btrfs_run_delayed_iputs(root);
 
 	if (trans->aborted ||
 	    root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
-		return -EIO;
+		err = -EIO;
 	}
 
-	return 0;
+	memset(trans, 0, sizeof(*trans));
+	kmem_cache_free(btrfs_trans_handle_cachep, trans);
+	return err;
 }
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
