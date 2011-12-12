From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs-progs: fail gracefully on error from open_ctree()
Date: Mon, 12 Dec 2011 15:40:19 +0100
Message-ID: <20111212144018.GB7322@twin.jikos.cz>
References: <1320184042-5188-1-git-send-email-idryomov@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320184042-5188-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:47:22PM +0200, Ilya Dryomov wrote:
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1328,7 +1328,12 @@ int main(int ac, char **av)
>  		fprintf(stderr, "error during mkfs %d\n", ret);
>  		exit(1);
>  	}
> +
>  	root = open_ctree(file, 0, O_RDWR);
> +	if (!root) {
> +		fprintf(stderr, "ctree init failed\n");
> +		return -1;

I know you just moved the code, but this should be exit(1), same as the
rest of the function does

> +	}
>  	root->fs_info->alloc_start = alloc_start;
>  
>  	ret = make_root_dir(root, mixed);
> @@ -1343,10 +1348,6 @@ int main(int ac, char **av)
>  		goto raid_groups;
>  
>  	btrfs_register_one_device(file);
> -	if (!root) {
> -		fprintf(stderr, "ctree init failed\n");
> -		return -1;
> -	}
>  
>  	zero_end = 1;
>  	while(ac-- > 0) {


david
