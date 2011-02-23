From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2] btrfs: make inode ref log recovery faster
Date: Wed, 23 Feb 2011 15:20:22 +0800
Message-ID: <4D64B536.1080805@cn.fujitsu.com>
References: <4D63A121.3090605@cn.fujitsu.com> <20110222143203.GB18570@twin.jikos.cz> <4D645F04.4060608@cn.fujitsu.com> <20110223013004.GE26100@dhcp231-156.rdu.redhat.com> <4D64661F.1050801@cn.fujitsu.com> <4D64B2B2.3020703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>, David Sterba <dave@jikos.cz>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D64B2B2.3020703@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

> -conflict_again:
> +
> +	if (search_done)
> +		goto insert;
> +
>  	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
>  	if (ret == 0) {
>  		char *victim_name;
> @@ -887,36 +890,22 @@ conflict_again:
>  							 inode, victim_name,
>  							 victim_name_len);
>  				kfree(victim_name);
> -				btrfs_release_path(root, path);
> -				goto conflict_again;
>  			}
> -			kfree(victim_name);
> +			if (victim_name)
> +				kfree(victim_name);

This is still wrong..

Just remove the first kfree() and remain the second one.

>  			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
>  		}
>  		BUG_ON(ret);
> -	}
> -	btrfs_release_path(root, path);
>  
> -	/* look for a conflicting sequence number */
> -	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
> -					 btrfs_inode_ref_index(eb, ref),
> -					 name, namelen, 0);
> -	if (di && !IS_ERR(di)) {
> -		ret = drop_one_dir_item(trans, root, path, dir, di);
> -		BUG_ON(ret);
> -	}
> -	btrfs_release_path(root, path);
> -
> -
> -	/* look for a conflicting name */
> -	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
> -				   name, namelen, 0);
> -	if (di && !IS_ERR(di)) {
> -		ret = drop_one_dir_item(trans, root, path, dir, di);
> -		BUG_ON(ret);
> +		/*
> +		 * NOTE: we have searched root tree and checked the
> +		 * coresponding ref, it does not need to check again.
> +		 */
> +		search_done = 1;
>  	}
>  	btrfs_release_path(root, path);
>  
> +insert:
>  	/* insert our name */
>  	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,
>  			     btrfs_inode_ref_index(eb, ref));
