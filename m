Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295AbbIVNE2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:04:28 -0400
Date: Tue, 22 Sep 2015 15:03:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: cleanup btrfs_balance profile validity checks
Message-ID: <20150922130332.GA12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150830214549.GA1409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150830214549.GA1409@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 30, 2015 at 09:45:49PM +0000, Alexandru Moise wrote:
> Improve readability by generalizing the profile validity checks,
> I had to read through those if statements half a dozen times on my
> first try just to get an idea of what's happening there.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> ---
>  fs/btrfs/volumes.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index fbe7c10..d23bc26 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3454,6 +3454,15 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
>  	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
>  }
>  
> +/* Non-zero return value signifies invalidity */
> +static inline int balance_relocate_invalid(struct btrfs_balance_args *bctl_arg,

The function name is not very descriptive, I'd pick something like
validate_convert_profile, otherwise ok.
