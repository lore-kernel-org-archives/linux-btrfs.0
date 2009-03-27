From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] unreached code in ctree.c
Date: Fri, 27 Mar 2009 08:47:59 -0400
Message-ID: <1238158079.27455.5.camel@think.oraclecorp.com>
References: <Pine.LNX.4.64.0903270733320.5354@usbsys.site>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903270733320.5354@usbsys.site>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-03-27 at 13:33 +0300, Dan Carpenter wrote:
> Smatch (http://repo.or.cz/w/smatch.git/) complains about this unreachable 
> code so I moved the break; up a line.  Compile tested.
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> --- orig/fs/btrfs/ctree.c	2009-03-27 07:31:42.000000000 +0300
> +++ devel/fs/btrfs/ctree.c	2009-03-27 07:32:26.000000000 +0300
> @@ -3318,8 +3318,8 @@
>  	for (i = 0; i < nr; i++) {
>  		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
>  		    BTRFS_LEAF_DATA_SIZE(root)) {
> -			break;
>  			nr = i;
> +			break;
>  		}

Whoops, that's not good.  This whole function is actually unused after
the changes in the experimental tree.

-chris


