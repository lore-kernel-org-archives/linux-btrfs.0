Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23915 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbcAZUXg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 15:23:36 -0500
Date: Tue, 26 Jan 2016 15:23:29 -0500
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] btrfs: synchronize incompat feature bits with sysfs
 files
Message-ID: <20160126202329.v7exs4qaqowr7zq4@floor.thefacebook.com>
References: <cover.1453400624.git.dsterba@suse.com>
 <14e46e04958df740c6c6a94849f176159a333f13.1453400624.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <14e46e04958df740c6c6a94849f176159a333f13.1453400624.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 07:32:11PM +0100, David Sterba wrote:
> The files under /sys/fs/UUID/features get out of sync with the actual
> incompat bits set for the filesystem if they change after mount (eg. the
> LZO compression).
> 
> Synchronize the feature bits with the sysfs files representing them
> right after we set/clear them.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/free-space-tree.c | 7 +++++++
>  fs/btrfs/ioctl.c           | 4 ++++
>  fs/btrfs/super.c           | 4 ++++
>  fs/btrfs/volumes.c         | 2 ++
>  4 files changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 86f7fdc05633..5a1bab11984d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -58,6 +58,7 @@
>  #include "dev-replace.h"
>  #include "free-space-cache.h"
>  #include "backref.h"
> +#include "sysfs.h"
>  #include "tests/btrfs-tests.h"
>  
>  #include "qgroup.h"
> @@ -477,6 +478,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  				btrfs_clear_opt(info->mount_opt, NODATACOW);
>  				btrfs_clear_opt(info->mount_opt, NODATASUM);
>  				btrfs_set_fs_incompat(info, COMPRESS_LZO);
> +				btrfs_sysfs_feature_update(root->fs_info,
> +					BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO,
> +					FEAT_INCOMPAT);
>  			} else if (strncmp(args[0].from, "no", 2) == 0) {
>  				compress_type = "no";
>  				btrfs_clear_opt(info->mount_opt, COMPRESS);

Thanks for tackling this Dave.  I'm having trouble with this one change,
crashing in btrfs/004.  The problem is that our sysfs files aren't fully
setup for the mount until later in open_ctree()

I think btrfs_sysfs_add_fsid() needs to be called before we can call
btrfs_sysfs_feature_update().

-chris

