Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50629 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2FRNMt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 09:12:49 -0400
Date: Mon, 18 Jun 2012 16:12:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: josef@redhat.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: fix locking in btrfs_destroy_delayed_refs
Message-ID: <20120618131239.GA24400@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef Bacik,

The patch b939d1ab76b4: "Btrfs: fix locking in
btrfs_destroy_delayed_refs" from May 31, 2012, leads to the following
warning: Btrfs: fix locking in btrfs_destroy_delayed_refs

fs/btrfs/disk-io.c
  3412          while ((node = rb_first(&delayed_refs->root)) != NULL) {
  3413                  ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
  3414  
  3415                  atomic_set(&ref->refs, 1);
  3416                  if (btrfs_delayed_ref_is_head(ref)) {
  3417                          struct btrfs_delayed_ref_head *head;
  3418  
  3419                          head = btrfs_delayed_node_to_head(ref);
  3420                          if (!mutex_trylock(&head->mutex)) {
  3421                                  atomic_inc(&ref->refs);
  3422                                  spin_unlock(&delayed_refs->lock);
  3423  
  3424                                  /* Need to wait for the delayed ref to run */
  3425                                  mutex_lock(&head->mutex);
  3426                                  mutex_unlock(&head->mutex);
  3427                                  btrfs_put_delayed_ref(ref);
  3428  
  3429                                  continue;
                                        ^^^^^^^^^
We're not holding the &delayed_refs->lock here.

  3430                          }
  3431  
  3432                          kfree(head->extent_op);
  3433                          delayed_refs->num_heads--;
  3434                          if (list_empty(&head->cluster))
  3435                                  delayed_refs->num_heads_ready--;
  3436                          list_del_init(&head->cluster);
  3437                  }
  3438                  ref->in_tree = 0;
  3439                  rb_erase(&ref->rb_node, &delayed_refs->root);
  3440                  delayed_refs->num_entries--;
  3441  
  3442                  spin_unlock(&delayed_refs->lock);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

So this is a double unlock.

  3443                  btrfs_put_delayed_ref(ref);
  3444  
  3445                  cond_resched();
  3446                  spin_lock(&delayed_refs->lock);
  3447          }
  3448  
  3449          spin_unlock(&delayed_refs->lock);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Or if we exit, then this is a double unlock.

There is some complicated locking going on in that function so I don't
pretend to understand it.  Sorry, if I've misread something.

regards,
dan carpenter

