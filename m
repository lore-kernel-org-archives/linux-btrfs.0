Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbbJYQHx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 12:07:53 -0400
Subject: Re: [PATCH] btrfs: zero out delayed node upon allocation
To: Alexandru Moise <00moses.alexander00@gmail.com>, clm@fb.com
References: <20151025174820.GA24972@gmail.com>
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <562CFE51.8080700@suse.com>
Date: Sun, 25 Oct 2015 12:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <20151025174820.GA24972@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 10/25/15 1:48 PM, Alexandru Moise wrote:
> This allows us to trim out half of btrfs_init_delayed_node() which
> is now reduntant.

It's redundant if kmem_cache_zalloc is used, but you haven't
documented that doing so is now required.  For all of these changes
you've posted, if they're to be accepted, I'd really prefer to set up
the slab with a constructor instead.  Then we don't need to worry
about such guarantees.  The object returned via kmem_cache_alloc will
always be properly initialized.

> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com> --- 
> fs/btrfs/delayed-inode.c | 8 +------- 1 file changed, 1
> insertion(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c 
> index a2ae427..7aa84be 100644 --- a/fs/btrfs/delayed-inode.c +++
> b/fs/btrfs/delayed-inode.c @@ -53,17 +53,11 @@ static inline void
> btrfs_init_delayed_node( { delayed_node->root = root; 
> delayed_node->inode_id = inode_id; -
> atomic_set(&delayed_node->refs, 0);

This makes assumptions about atomic_t and what atomic_set does that
aren't guaranteed to be true.  When accessors/mutators are part of the
API they should be used.

- -Jeff

> -	delayed_node->count = 0; -	delayed_node->flags = 0; 
> delayed_node->ins_root = RB_ROOT; delayed_node->del_root =
> RB_ROOT; mutex_init(&delayed_node->mutex); -
> delayed_node->index_cnt = 0; 
> INIT_LIST_HEAD(&delayed_node->n_list); 
> INIT_LIST_HEAD(&delayed_node->p_list); -
> delayed_node->bytes_reserved = 0; -
> memset(&delayed_node->inode_item, 0,
> sizeof(delayed_node->inode_item)); }
> 
> static inline int btrfs_is_continuous_delayed_item( @@ -132,7
> +126,7 @@ again: if (node) return node;
> 
> -	node = kmem_cache_alloc(delayed_node_cache, GFP_NOFS); +	node =
> kmem_cache_zalloc(delayed_node_cache, GFP_NOFS); if (!node) return
> ERR_PTR(-ENOMEM); btrfs_init_delayed_node(node, root, ino);
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJWLP5RAAoJEB57S2MheeWyQMoQAMUNGQFl14cwbJWtSsNjwZJy
eRaSckKcRinc4zoFxATSn4R/UQLadFNg+tAtSnNgoJngpg/nn6Fc19vMS5QVpU1c
OhPgYUVkBTjLxhBaY6Iivinbx4+pjFaEP+e6LoqXefelB6Wq17e8DavQcDU5gH2e
3vzXLt8kKa1hlC5SbtjW59cLgHzrclR6h4qeO00R7vWPA4YyIzOKOnYznrgZ69wS
V97YBmcyucrl+EENYFe5BYBJmP5LojHjsxfPtF2zzZnvCpSrWPZ5Num/2yCofFir
7HNs86wLEBjsEUhkSjZ/7u3XATjVOXNHVUsknOOMB/B6zk9ngnK51mp7a2Ib41PM
nMbNOVHhauumY9sf++RWjN53HTGH8aAlp7B0JIRTceGrvKdT2YGjW8iWwIrtlCE0
bSoEXRNcMYFvR+0we/WKVi4sX0ysRfhDbCuQeWPEJ6R4DbzmtqjCmmHQnZyVpwex
1ZxT8yvFVJvQHEl2E+mHOneRgdVuj89j8AZJ99idIHKa9b60tHAlkq+zXoW0odIt
qV09bYoc7J87W5JvTgKVks13ovwKmM7Ij7zHFMBLVO/BGrd+zFFW1qq8r6GJBKG9
PaXt+HUHBCt4TpvAza5JZ0Yn7tYvALHizj+IZStTw2Kz1vQC5KEnjZIMa3LcKrsx
r2oQLSfGkcsf8EcIzDX1
=qINk
-----END PGP SIGNATURE-----
