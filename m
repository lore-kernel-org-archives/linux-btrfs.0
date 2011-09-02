From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs-progs: added btrfs filesystem label [label] [path]
 support V2
Date: Fri, 2 Sep 2011 17:48:10 +0200
Message-ID: <20110902154810.GH11678@ds.suse.cz>
References: <4E5F47C7.3030803@oracle.com>
 <4E5F7216.7040909@oracle.com>
 <20110902125208.GF11678@ds.suse.cz>
 <4E60D67E.2070903@oracle.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
	Hugo Mills <hugo@carfax.org.uk>, chris.mason@oracle.com
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E60D67E.2070903@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2011 at 09:13:34PM +0800, Jeff Liu wrote:
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -140,6 +140,8 @@ struct btrfs_ioctl_space_args {
>                     struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>                     struct btrfs_ioctl_vol_args)
> +#define BTRFS_IOC_FS_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 5, \
> +                   struct btrfs_ioctl_fs_label_args)
>  /* trans start and trans end are dangerous, and only for
>   * use by applications that know how to avoid the
>   * resulting deadlocks

well, it is an unassigned number, but a newly added features should IMHO
allocate greater than current max value, ie over 31 in coordination with

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Development_notes.2C_please_read

table.


david
