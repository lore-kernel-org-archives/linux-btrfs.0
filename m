From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Mon, 18 Aug 2008 16:32:30 -0400
Message-ID: <1219091550.14063.44.camel@think.oraclecorp.com>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218980439.3184.304.camel@pmac.infradead.org>
	 <1219087412.14063.22.camel@think.oraclecorp.com>
	 <1219088029.3184.413.camel@pmac.infradead.org>
	 <1219088859.14063.35.camel@think.oraclecorp.com>
	 <1219090839.3184.436.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219090839.3184.436.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 21:20 +0100, David Woodhouse wrote:
> On Mon, 2008-08-18 at 15:47 -0400, Chris Mason wrote:
> > Lets pretend I had put in commments something like the code below.
> > The important part is that directories have only one link, so they
> > have only one backref.
> 
> OK. Now can I rip that code out anyway? The VFS will never call
> btrfs_lookup() for ".." -- not since the 2.2 kernel :)
> 
> I'm still a little confused about precisely what btrfs_search_slot()
> returns when it doesn't find a match -- that's probably where the
> documentation would be more useful.
> 

if btrfs_search_slot returns < 0, there was an error
if btrfs_search_slot returns > 1, path->slots[0] is the spot in the tree
where you'd want to insert the item.

In this case, if path->slots[0] == 0, there are no keys in the tree
smaller than your search key.

If path->slots[0] == btrfs_header_nritems(path->nodes[0]), there are no
items in this node that have a key > than your search key.

> What I have in btrfs_get_parent() is correct, I think -- but could
> probably be simplified to your version, searching for (u64)-1 and then
> not needing to call btrfs_next_leaf().

Yes.

> 
> Something like this?
> 
> (And am I fixing a use-after-free bug by moving that btrfs_free_path()
> down by a line, at the end?)
> 

Most definitely ;)  One comment inline below

> diff --git a/export.c b/export.c
> index 797b4cb..830e87a 100644
> --- a/export.c
> +++ b/export.c
> @@ -156,27 +156,27 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
>  
>  	key.objectid = dir->i_ino;
>  	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
> -	key.offset = 0;
> +	key.offset = (u64)-1;
>  	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> -	BUG_ON(ret == 0);
> -	ret = 0;
>  
>  	leaf = path->nodes[0];
>  	slot = path->slots[0];
> -	nritems = btrfs_header_nritems(leaf);
> -	if (slot >= nritems) {
> -		ret = btrfs_next_leaf(root, path);
> -		if (ret) {
> -			btrfs_free_path(path);
> -			goto out;
> -		}
> -		leaf = path->nodes[0];
> -		slot = path->slots[0];
> +	if (ret < 0 && slot == 0) {

              ^^^^^^^^^^^^^ should be ||, and should set ret to
something bad if slot == 0

> +		btrfs_free_path(path);
> +		goto out;
>  	}
> +	/*
> +	  This will be in the slot _before_ the one that btrfs_search_slot()
> +	   returns. And for some reason which dwmw2 doesn't quite understand,
> +	   that'll definitely be in the same leaf that btrfs_search_slot()
> +	   returned -- even if btrfs_search_slot() had to look in the _next_
> +	   leaf to find the first key which is greater than what we asked for 
> +	*/
> +	slot--;
>  
> +	btrfs_item_key_to_cpu(leaf, &key, slot);
>  	btrfs_free_path(path);
>  
> -	btrfs_item_key_to_cpu(leaf, &key, slot);
>  	if (key.objectid != dir->i_ino || key.type != BTRFS_INODE_REF_KEY)
>  		goto out;
>  
> 
> 

-chris


