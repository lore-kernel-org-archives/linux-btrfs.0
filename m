Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50110 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2HBNXE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 09:23:04 -0400
Date: Thu, 2 Aug 2012 15:22:59 +0200
From: David Sterba <dave@jikos.cz>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
Message-ID: <20120802132259.GO17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <501987FF.9080304@daevel.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <501987FF.9080304@daevel.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2012 at 09:48:15PM +0200, Olivier Bonvalet wrote:
> I have some trouble with a btrfs filesystem.
> As you can see in logs, there is lines which are from btrfs (I
> supposed), then some warnings at fs/btrfs/extent-tree.c, and finally a
> "kernel BUG" at fs/btrfs/extent-tree.c:5038.

Did you really see this BUG ? It comes from some unused and disabled code:

5036 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
5037         if (item_size < sizeof(*ei)) {
5038                 BUG_ON(found_extent || extent_slot != path->slots[0]);
^^^^

5039                 ret = convert_extent_item_v0(trans, extent_root, path,
5040                                              owner_objectid, 0);
5041                 if (ret < 0)
5042                         goto abort;
5043
5044                 btrfs_release_path(path);
5045                 path->leave_spinning = 1;
5046
5047                 key.objectid = bytenr;
5048                 key.type = BTRFS_EXTENT_ITEM_KEY;
5049                 key.offset = num_bytes;
5050
5051                 ret = btrfs_search_slot(trans, extent_root, &key, path,
5052                                         -1, 1);
5053                 if (ret) {
5054                         printk(KERN_ERR "umm, got %d back from search"
5055                                ", was looking for %llu\n", ret,
5056                                (unsigned long long)bytenr);
5057                         btrfs_print_leaf(extent_root, path->nodes[0]);
5058                 }
5059                 if (ret < 0)
5060                         goto abort;
5061                 extent_slot = path->slots[0];
5062                 leaf = path->nodes[0];
5063                 item_size = btrfs_item_size_nr(leaf, extent_slot);
5064         }
5065 #endif


david
