Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49860 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3HSTQl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 15:16:41 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 27C979A06A1
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 13:16:41 -0600 (MDT)
Date: Mon, 19 Aug 2013 15:16:38 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix some basic sparse errors
Message-ID: <20130819191638.GD3990@localhost.localdomain>
References: <1376936461-8285-1-git-send-email-jbacik@fusionio.com>
 <52126839.5060502@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <52126839.5060502@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 19, 2013 at 08:47:21PM +0200, Stefan Behrens wrote:
> On 08/19/2013 20:21, Josef Bacik wrote:
> >Running sparse I found a few small things where we should have static functions
> >that aren't used externally and we should be using unsigned values for bit
> >fields.  Thanks,
> >
> >Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> >---
> >  fs/btrfs/disk-io.c |    8 ++++----
> >  fs/btrfs/send.c    |    4 ++--
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> >
> >diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >index 3b12c26..f51cd95 100644
> >--- a/fs/btrfs/disk-io.c
> >+++ b/fs/btrfs/disk-io.c
> >@@ -1432,8 +1432,8 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
> >  	return 0;
> >  }
> >
> >-struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
> >-					struct btrfs_key *key)
> >+static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
> >+					       struct btrfs_key *key)
> >  {
> >  	struct btrfs_root *root;
> >  	struct btrfs_fs_info *fs_info = tree_root->fs_info;
> >@@ -1533,8 +1533,8 @@ fail:
> >  	return ret;
> >  }
> 
> Already posted in "[PATCH] Btrfs: get rid of sparse warnings" on
> 14.Aug.2013.
> 
> >-struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
> >-					u64 root_id)
> >+static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
> >+					       u64 root_id)
> >  {
> >  	struct btrfs_root *root;
> >
> 
> Already posted in "[PATCH 1/7] btrfs: cleanup: mark 'btrfs_lookup_fs_root'
> as static" on 7.Aug.2013.
> 
> 
> >diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> >index fc03a57..db7da68 100644
> >--- a/fs/btrfs/send.c
> >+++ b/fs/btrfs/send.c
> >@@ -54,8 +54,8 @@ struct fs_path {
> >
> >  			char *buf;
> >  			int buf_len;
> >-			int reversed:1;
> >-			int virtual_mem:1;
> >+			unsigned int reversed:1;
> >+			unsigned int virtual_mem:1;
> >  			char inline_buf[];
> >  		};
> >  		char pad[PAGE_SIZE];
> 
> Already posted in "[PATCH] Btrfs: get rid of sparse warnings" on
> 14.Aug.2013.
> 

/me shakes his fist at patchwork.

Josef
