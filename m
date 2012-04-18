From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: always store the mirror we read the eb from
Date: Wed, 18 Apr 2012 12:44:07 +0200
Message-ID: <20120418104407.GH20982@twin.jikos.cz>
References: <1334583746-3332-1-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334583746-3332-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2012 at 09:42:26AM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -390,8 +390,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  
>  		if (!failed_mirror) {
>  			failed = 1;
> -			printk(KERN_ERR "failed mirror was %d\n", eb->failed_mirror);
> -			failed_mirror = eb->failed_mirror;
> +			failed_mirror = eb->read_mirror;
>  		}
>  
>  		mirror_num++;

this hunk does not apply for me (on top of master or for-linus), there's
a different context. In your version the

	if (!failed_mirror)

check is moved after

 392                 num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 393                                               eb->start, eb->len);
 394                 if (num_copies == 1)
 395                         break;
 396

which was one of the incremental patches sent for testing, but it's
needed.


david
