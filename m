From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: add discard flag to btrfs_device and make
 btrfs_discard_extent aware of that
Date: Fri, 10 Jun 2011 02:00:17 +0200
Message-ID: <20110610000017.GP12709@twin.jikos.cz>
References: <1307604489-7884-1-git-send-email-lidongyang@novell.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: Li Dongyang <lidongyang@novell.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307604489-7884-1-git-send-email-lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 09, 2011 at 03:28:09PM +0800, Li Dongyang wrote:
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -45,6 +45,7 @@ struct btrfs_device {
>  	int running_pending;
>  	u64 generation;
>  
> +	int discard;

can you pick a better name? this does not describe that it's the
capability of the device, but rather 'do a discard'.

something like has_discard, can_discard, has_trim, etc

>  	int writeable;
>  	int in_fs_metadata;
>  	int missing;

otherwise the patch looks good (and matches my view how to do it). I
will test it eventually.


david
