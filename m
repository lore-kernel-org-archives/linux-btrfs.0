Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42008 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934173AbeBUSER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 13:04:17 -0500
Date: Wed, 21 Feb 2018 16:04:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 27/27] btrfs-progs: deprecate libbtrfs helpers
Message-ID: <20180221150428.GE1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
 <1fc27a8f9bf2446eec0785b39cdb85c294eabe45.1518720598.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1fc27a8f9bf2446eec0785b39cdb85c294eabe45.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 11:05:12AM -0800, Omar Sandoval wrote:
> diff --git a/btrfs-list.c b/btrfs-list.c
> index a2fdb3f9..56aa2455 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -34,6 +34,12 @@
>  #include "btrfs-list.h"
>  #include "rbtree-utils.h"
>  
> +/*
> + * The deprecated functions in this file depend on each other, so silence the
> + * warnings.
> + */
> +#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

How does this behave under clang?

> +
>  /* we store all the roots we find in an rbtree so that we can
>   * search for them later.
>   */
> diff --git a/btrfs-list.h b/btrfs-list.h
> index 54e1888f..774bcece 100644
> --- a/btrfs-list.h
> +++ b/btrfs-list.h
> @@ -82,10 +82,15 @@ struct root_info {
>  };
>  
>  int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
> -int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
> -char *btrfs_list_path_for_root(int fd, u64 root);
> -int btrfs_list_get_path_rootid(int fd, u64 *treeid);
> -int btrfs_get_subvol(int fd, struct root_info *the_ri);
> -int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri);
> +int btrfs_list_get_default_subvolume(int fd, u64 *default_id)
> +	__attribute__((deprecated("use btrfs_util_get_default_subvolume_fd()")));

IIRC the parametrized deprecated("...") is not supported on older
compilers, see 1b1fd2c190ddb896a010a4c704ec1c2d46922aaf . We might avoid
using raw __attirbute__ anyway, so a wrapper __deprecated("with string")
could make it ifdef-ed properly. With some configure-time detection.

> +char *btrfs_list_path_for_root(int fd, u64 root)
> +	__attribute__((deprecated("use btrfs_util_subvolume_path_fd()")));
> +int btrfs_list_get_path_rootid(int fd, u64 *treeid)
> +	__attribute__((deprecated("use btrfs_util_subvolume_id_fd()")));
> +int btrfs_get_subvol(int fd, struct root_info *the_ri)
> +	__attribute__((deprecated("use btrfs_util_subvolume_info_fd() and btrfs_util_subvolume_path_fd()")));
> +int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
> +	__attribute__((deprecated("use btrfs_util_subvolume_info_fd() and btrfs_util_subvolume_path_fd()")));
