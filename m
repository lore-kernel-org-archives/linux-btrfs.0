From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Mon, 18 Aug 2008 15:47:39 -0400
Message-ID: <1219088859.14063.35.camel@think.oraclecorp.com>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218980439.3184.304.camel@pmac.infradead.org>
	 <1219087412.14063.22.camel@think.oraclecorp.com>
	 <1219088029.3184.413.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219088029.3184.413.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 20:33 +0100, David Woodhouse wrote:
> On Mon, 2008-08-18 at 15:23 -0400, Chris Mason wrote:
> > The search key in Yan's patch changes to (u64)-1.  We know that if
> > we're in slot 0, there's nothing after us in the tree.
> 
> But because we searched for a reference to (u64)-1, the item we want is
> actually _earlier_ in the tree, not later.
> 

Lets pretend I had put in commments something like the code below.  The
important part is that directories have only one link, so they have only
one backref.

	/* 
         * we're a directory and we have at most 1 back reference
         * to our one and only parent directory
         */
	if (namelen == 2 && strcmp(name, "..") == 0) {
                struct btrfs_key key;
                struct extent_buffer *leaf;
                int slot;

                key.objectid = dir->i_ino;

                /* after the search, we'll be
                 * one slot after the last back reference for this
                 * inode.
                 */
                key.offset = (u64)-1;
                btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
		
		/* normally, I would check the return values after the
                 * search.  But this time I merged the patch wrong and
                 * made a bug.  If path->slots[0] == 0 after the
                 * search, there won't be any keys smaller to ours
                 * in the tree.
                 */
                if (ret < 0 || path->slots[0] == 0)
                        goto out_err;
                ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
                BUG_ON(ret == 0);
                ret = 0;
                leaf = path->nodes[0];

                /* go back one slot and find our only backref */
                slot = path->slots[0] - 1;

                btrfs_item_key_to_cpu(leaf, &key, slot);
                if (key.objectid != dir->i_ino ||
                    key.type != BTRFS_INODE_REF_KEY) {
                        goto out_err;
                }
                location->objectid = key.offset;
                location->type = BTRFS_INODE_ITEM_KEY;
                location->offset = 0;
                goto out;


