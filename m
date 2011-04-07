From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH] Btrfs: fix subvolume fake mount problem when default
 subvolume is set
Date: Thu, 07 Apr 2011 07:55:07 +0200
Message-ID: <4D9D51BB.6070302@libero.it>
References: <1302082493-14589-1-git-send-email-xin.zhong@intel.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302082493-14589-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi
On 04/06/2011 11:34 AM, Zhong, Xin wrote:
> We create two subvolumes (meego_root and meego_home) in
> btrfs root directory. And set meego_root as default mount
> subvolume. After we remount btrfs, meego_root is mounted
> to top directory by default. Then if we create a directory with
> the same name as meego_home, we can mount meego_home subvolume
> sucessfully (subvol=meego_home). But this is incorrect. What we
> do in this mount point will not change anything in meego_home
> subvolume. The problem is when default mount subvolume is set to
> meego_root, we search meego_home in meego_root. But if we find a
> directory with the same name, we will treat it as subvolume. So
> the solution is to check if what we find is really a subvolume.

I think that this a bug, so a warning should be raised. We had a lot of
problem because "btrfsctl -s " did the same thing: if we referred to a
directory, they snapshot the directory's subvolume and the user didn't
understood what happened.

Personally I prefer that in case a wrong option the kernel raises a
warning and stops, not that it makes a choice about which default is
more reasonable.

Reagrds
G.Baroncelli


> 
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
> ---
>  fs/btrfs/super.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b85fe78..66a76b7 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -823,7 +823,9 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  			error = PTR_ERR(new_root);
>  			goto error_free_subvol_name;
>  		}
> -		if (!new_root->d_inode) {
> +		if (!new_root->d_inode ||
> +		    /* new_root is a directory, not subvolume */
> +		    new_root->d_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
>  			dput(root);
>  			dput(new_root);
>  			deactivate_locked_super(s);

