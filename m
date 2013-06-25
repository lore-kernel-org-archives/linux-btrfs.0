Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48332 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3FYPwy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Jun 2013 11:52:54 -0400
Date: Tue, 25 Jun 2013 23:52:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Jon Nelson <jnelson+btrfs@jamponi.net>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: hang on 3.9, 3.10-rc5
Message-ID: <20130625155234.GA11866@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain>
 <loom.20130618T190955-784@post.gmane.org>
 <20130621011137.4477.1347@localhost.localdomain>
 <CAKuK5J3TBDNgHJ_YUWupB4rO_ixG0LnZFE=K5Uo5Wbo=76rT+A@mail.gmail.com>
 <CAFvQSYSq9M5bTLeO-EfrEy_LKKFq7rWsc8T25_Nj2kOSRmoCFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFvQSYSq9M5bTLeO-EfrEy_LKKFq7rWsc8T25_Nj2kOSRmoCFg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 21, 2013 at 08:42:55AM +0200, Clemens Eisserer wrote:
> Hi Jon,
> 
> > Is this what you are looking for?
> > After this, the CPU gets "stuck" and I have to reboot.
> 
> This issue has already been reported:
> https://bugzilla.kernel.org/show_bug.cgi?id=59451

Hi,

Could you please try this patch?

(at least it addresses my ulist_add_merge crash :))

thanks,
liubo

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 7b417e2..69a9c32 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -73,7 +73,6 @@ void ulist_fini(struct ulist *ulist)
 	if (ulist->nodes_alloced > ULIST_SIZE)
 		kfree(ulist->nodes);
 	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
-	ulist->root = RB_ROOT;
 }
 EXPORT_SYMBOL(ulist_fini);
 
@@ -205,6 +204,7 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		u64 new_alloced = ulist->nodes_alloced + 128;
 		struct ulist_node *new_nodes;
 		void *old = NULL;
+		int i;
 
 		/*
 		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
@@ -222,6 +222,17 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 			memcpy(new_nodes, ulist->int_nodes,
 			       sizeof(ulist->int_nodes));
 
+		/*
+		 * krealloc actually uses memcpy, which does not copy rb_node
+		 * pointers, so we have to do it ourselves.  Otherwise we may
+		 * be bitten by crashes.
+		 */
+		for (i = 0; i < ulist->nnodes; i++) {
+			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
+			ret = ulist_rbtree_insert(ulist, &new_nodes[i]);
+			BUG_ON(ret);
+		}
+
 		ulist->nodes = new_nodes;
 		ulist->nodes_alloced = new_alloced;
 	}

