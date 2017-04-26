Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:38667 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970539AbdDZCOZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 22:14:25 -0400
Date: Wed, 26 Apr 2017 04:14:16 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH ping] btrfs: warn about RAID5/6 being experimental at
 mount time
Message-ID: <20170426021416.us4zj2blho26sjgc@angband.pl>
References: <20170419210745.15263-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170419210745.15263-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 19, 2017 at 11:07:45PM +0200, Adam Borowski wrote:
> Too many people come complaining about losing their data -- and indeed,
> there's no warning outside a wiki and the mailing list tribal knowledge.
> Message severity chosen for consistency with XFS -- "alert" makes dmesg
> produce nice red background which should get the point across.
...
> I intend to ask for inclusion of this one (or an equivalent) in 4.9, either
> in Debian or via GregKH -- while for us kernels "that old" are history,
> regular users expect stable releases to be free of known serious data loss
> bugs.

Hi guys, could you please comment?  While there's only relatively little
urgency for mainline (heck, it'd be best if the warning was not needed at
all!), there's a Debian release close by, and it's be grossly inresponsible
to not let people know that a feature advertised in the documentation is in
an unusable state (especially as of 4.9).  For you, filesystem developers,
a way of thinking that "the user should do research" might be acceptable,
but once it filters down to a stable release, the user expects no known
serious bugs.

And here the severity is "critical -- causes serious data loss".

> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e54844767fe5..e7f91f70e149 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3083,6 +3083,14 @@ int open_ctree(struct super_block *sb,
>  		btrfs_set_opt(fs_info->mount_opt, SSD);
>  	}
>  
> +	if ((fs_info->avail_data_alloc_bits |
> +	     fs_info->avail_metadata_alloc_bits |
> +	     fs_info->avail_system_alloc_bits) &
> +	    BTRFS_BLOCK_GROUP_RAID56_MASK) {
> +		btrfs_alert(fs_info,
> +		"btrfs RAID5/6 is EXPERIMENTAL and has known data-loss bugs");
> +	}
> +
>  	/*
>  	 * Mount does not set all options immediately, we can do it now and do
>  	 * not have to wait for transaction commit
> -- 

Doing this in the kernel should be better than in userspace (like
https://patchwork.kernel.org/patch/9450035/) as it can deal with a future
kernel with working RAID5/6 on old -progs; but if you prefer, I can finish
that patch and request its inclusion in Debian stretch -progs instead or in
addition to the above warning in the kernel.

ᛗᛖᛟᚹ!
-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
