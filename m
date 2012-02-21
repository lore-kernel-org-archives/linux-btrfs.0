From: David Sterba <dave@jikos.cz>
Subject: Re: subvolume info in /proc/mounts
Date: Tue, 21 Feb 2012 15:31:01 +0100
Message-ID: <20120221143101.GH1046@twin.jikos.cz>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr> <20120204214430.GA15350@twin.jikos.cz> <2ed5fe028fdcfd3d53cf217e13b827d9.squirrel@webmail01.edunet.gr> <20120206115321.GB15350@twin.jikos.cz> <20120206121823.GA24922@infradead.org> <20120206135215.GE23916@ZenIV.linux.org.uk> <20120209134403.GC15350@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Nikos Voutsinas <nvoutsin@noc.edunet.gr>, dave@jikos.cz,
	linux-btrfs@vger.kernel.org, kreijack@gmail.com,
	chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120209134403.GC15350@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 09, 2012 at 02:44:03PM +0100, David Sterba wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -766,6 +766,9 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
>                 seq_puts(seq, ",inode_cache");
>         if (btrfs_test_opt(root, SKIP_BALANCE))
>                 seq_puts(seq, ",skip_balance");
> +       seq_puts(seq, ",subvol=");
> +       seq_dentry(seq, vfs->mnt_root, " \t\n\\");
> +
>         return 0;
>  }

This is still not enough, if there's a (non-toplevel) default subvolume
set at the time of mount, it will not be printed within the path.

The path in mount option "subvol=PATH" is resolved relative to the
toplevel subvolume regardless of the default subvol, and show_options
shold follow the same logic to be fully symmetric.

I don't think path resolving is allowed from inside show_options. So we
could:

 * resolve the path inside btrfs_mount (we're looking up the default
   root item anyway)
 * save the full path inside the fs_tree root (the fs_info structure is
   shared by all moutned subvols from the same filesystem and cannot be
   used for this purpose, and the default subvol could change anytime)
 * print the fs_root->default_root_path before the seq_dentry


david
