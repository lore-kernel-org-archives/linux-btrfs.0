From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up
Date: Wed, 26 Oct 2011 17:10:24 +0200
Message-ID: <20111026151024.GB5914@twin.jikos.cz>
References: <20111025010236.322699279@suse.com> <20111025010851.368992601@suse.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111025010851.368992601@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've tested it and still crashes in xfstets/113, but this time I know
what to look for :)

On Mon, Oct 24, 2011 at 09:02:43PM -0400, Jeff Mahoney wrote:
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -200,10 +200,10 @@ void free_extent_state(struct extent_sta
>  int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  		   int bits, int filled, struct extent_state *cached_state);
>  int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
> -		      int bits, gfp_t mask);
> +		      int bits, gfp_t mask) __must_check;
                                            ^^^^^^^^^^^^
this

>  int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> -		     int bits, int wake, int delete, struct extent_state **cached,
> -		     gfp_t mask);
> +		     int bits, int wake, int delete,
> +		     struct extent_state **cached, gfp_t mask) __must_check;
                                                               ^^^^^^^^^^^^
this

>  int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
>  		    int bits, gfp_t mask) __must_check;
>  int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> @@ -218,7 +218,7 @@ int set_extent_new(struct extent_io_tree
>  int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
>  		     gfp_t mask) __must_check;
>  int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
> -		       gfp_t mask);
> +		       gfp_t mask) __must_check;
                                   ^^^^^^^^^^^^
shouldn't this be placed at the beginning of the prototype?

> @@ -6250,19 +6265,23 @@ static ssize_t btrfs_direct_IO(int rw, s
>  		   btrfs_submit_direct, 0);
>  
>  	if (ret < 0 && ret != -EIOCBQUEUED) {
> -		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
> -			      offset + iov_length(iov, nr_segs) - 1,
> -			      EXTENT_LOCKED | write_bits, 1, 0,
> -			      &cached_state, GFP_NOFS);
> +		ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
> +				       offset + iov_length(iov, nr_segs) - 1,
> +				       EXTENT_LOCKED | write_bits, 1, 0,
> +				       &cached_state, GFP_NOFS);
> +		BUG_ON(ret < 0);
> +		ret = 0;
                ^^^^^^^^
this

>  	} else if (ret >= 0 && ret < iov_length(iov, nr_segs)) {
>  		/*
>  		 * We're falling back to buffered, unlock the section we didn't
>  		 * do IO on.
>  		 */
> -		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
> -			      offset + iov_length(iov, nr_segs) - 1,
> -			      EXTENT_LOCKED | write_bits, 1, 0,
> -			      &cached_state, GFP_NOFS);
> +		ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
> +				       offset + iov_length(iov, nr_segs) - 1,
> +				       EXTENT_LOCKED | write_bits, 1, 0,
> +				       &cached_state, GFP_NOFS);
> +		BUG_ON(ret < 0);
> +		ret = 0;
                ^^^^^^^^

and this clobber the original ret value which is returned a few lines
below and used in the caller.

>  	}
>  out:
>  	free_extent_state(cached_state);

        return ret;
}


david
