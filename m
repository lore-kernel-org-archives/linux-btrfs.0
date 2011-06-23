From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v2] btrfs: fix oops on failure path
Date: Thu, 23 Jun 2011 18:36:40 +0200
Message-ID: <20110623163640.GO12709@twin.jikos.cz>
References: <BANLkTimrzmLdgg6NN_vU-Q6Euh1sE8SNNg@mail.gmail.com>
 <20110623103109.GN12709@twin.jikos.cz>
 <BANLkTindeWYaCu3ppdHK9sgOMRcFoAU+sw@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTindeWYaCu3ppdHK9sgOMRcFoAU+sw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2011 at 11:01:01PM +0800, Daniel J Blueman wrote:
> On 23 June 2011 18:31, David Sterba <dave@jikos.cz> wrote:
> (how does one follow up an email in git send-email with the message id?)

git-send-email --in-reply-to=<identifier>

(if it does not ask for it) and paste identifier from mail header
In-Reply-To:

> If lookup_extent_backref fails, path->nodes[0] reasonably could be
> null along with other callers of btrfs_print_leaf, so ensure we have a
> valid extent buffer before dereferencing.

ack.


thanks,
david

> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
> index fb2605d..f38e452 100644
> --- a/fs/btrfs/print-tree.c
> +++ b/fs/btrfs/print-tree.c
> @@ -158,8 +158,7 @@ static void print_extent_ref_v0(struct
> extent_buffer *eb, int slot)
>  void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
>  {
>  	int i;
> -	u32 type;
> -	u32 nr = btrfs_header_nritems(l);
> +	u32 type, nr;
>  	struct btrfs_item *item;
>  	struct btrfs_root_item *ri;
>  	struct btrfs_dir_item *di;
> @@ -172,6 +171,11 @@ void btrfs_print_leaf(struct btrfs_root *root,
> struct extent_buffer *l)
>  	struct btrfs_key key;
>  	struct btrfs_key found_key;
> 
> +	if (!l)
> +		return;
> +
> +	nr = btrfs_header_nritems(l);
> +
>  	printk(KERN_INFO "leaf %llu total ptrs %d free space %d\n",
>  		(unsigned long long)btrfs_header_bytenr(l), nr,
>  		btrfs_leaf_free_space(root, l));
> -- 
> Daniel J Blueman
