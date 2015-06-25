Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbbFYQGQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 12:06:16 -0400
Date: Thu, 25 Jun 2015 18:06:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: dsterba@suse.cz, Robert Marklund <robbelibobban@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] check: check so offset is not bigger then the leaf
Message-ID: <20150625160613.GK726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com>
 <20150618164443.GH6761@twin.jikos.cz>
 <5582FD06.2010004@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5582FD06.2010004@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 10:16:54AM -0700, Josef Bacik wrote:
> On 06/18/2015 09:44 AM, David Sterba wrote:
> > On Thu, Jun 18, 2015 at 01:59:13AM +0200, Robert Marklund wrote:
> >> This could crash before because of dangerous dangling
> >> offset of pointer.
> >
> > That's right, this can happen. There are more btrfs_item_ptr that would
> > be good to validate that way, namely in the checker as it's most likely
> > to see corrupted data.
> >
> 
> The check_block stuff should be doing this, if it isn't that's where we 
> need to fix it.  Thanks,

Something like that?

--- a/ctree.c
+++ b/ctree.c
@@ -521,6 +521,19 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
                        goto fail;
                }
        }
+
+       for (i = 0; i < nritems; i++) {
+               void *tmp;
+
+               tmp = btrfs_item_ptr(buf, i, void);
+               if ((long)tmp >= BTRFS_LEAF_DATA_SIZE(root)) {
+                       ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
+                       fprintf(stderr, "bad item pointer %lu\n",
+                               (long)tmp);
+                       goto fail;
+               }
+       }
+
        return BTRFS_TREE_BLOCK_CLEAN;
 fail:
        if (btrfs_header_owner(buf) == BTRFS_EXTENT_TREE_OBJECTID) {
---

Compile-tested only.
