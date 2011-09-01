From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 1/3] Btrfs-progs: btrfs-list: split list_subvols
Date: Thu, 1 Sep 2011 06:11:24 +0200
Message-ID: <20110901041124.GC11678@ds.suse.cz>
References: <cover.1311872884.git.list.btrfs@jan-o-sch.net>
 <8838579cff0333e7df836111fc5aa0f64423526c.1311872884.git.list.btrfs@jan-o-sch.net>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8838579cff0333e7df836111fc5aa0f64423526c.1311872884.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Jul 28, 2011 at 07:13:04PM +0200, Jan Schmidt wrote:
> split list_subvols to separate functions and allow printing only in the
> containing function. lets us make use of those functions when resolving
> logical addresses.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
> @@ -250,20 +249,15 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri, int print_
>  		 */
>  		found = tree_search(&rl->root, next);
>  		if (!found) {
> -			top_id = next;
> +			*top_id = next;
>  			break;
>  		}
>  	}
> -	if (print_parent) {
> -		printf("ID %llu parent %llu top level %llu path %s\n",
> -		       (unsigned long long)ri->root_id, (unsigned long long)parent_id, (unsigned long long)top_id,
> -			full_path);
> -	} else {
> -		printf("ID %llu top level %llu path %s\n",
> -		       (unsigned long long)ri->root_id, (unsigned long long)top_id,
> -			full_path);
> -	}
> -	free(full_path);
> +
> +	*root_id = ri->root_id;
> +	*parent_id = ri->root_id;
        ^^^^^^^^^^^^^^^^^^^^^^^^^

this is not correct, parent_id is already set during the loop above.
else it prints same id for both volume and it's parent like

ID 493 parent 493 top level 5 path stress/9/...


david
