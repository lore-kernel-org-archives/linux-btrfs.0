Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbbDIP4c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 11:56:32 -0400
Date: Thu, 9 Apr 2015 17:56:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: show subvol= and subvolid= in /proc/mounts
Message-ID: <20150409155630.GF25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428471096.git.osandov@osandov.com>
 <213f0b6a4cffcc82688894b4edbaeb51f8e71137.1428471096.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <213f0b6a4cffcc82688894b4edbaeb51f8e71137.1428471096.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 07, 2015 at 10:34:02PM -0700, Omar Sandoval wrote:
> Currently, userspace has no way to know which subvolume is mounted.

Oh, there is a way, 'btrfs inspect-internal rootid /path/to/mount', just
we'd like to see it in the mount options as well.

> But,
> now that we're guaranteed to have a meaningful root dentry, we can just
> export and use seq_dentry() in btrfs_show_options(). The subvolume ID is
> easy to get, so put that in there, too.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  fs/btrfs/super.c | 4 ++++
>  fs/seq_file.c    | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 5ab9801..5e14bb6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1193,6 +1193,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>  		seq_puts(seq, ",fatal_errors=panic");
>  	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
>  		seq_printf(seq, ",commit=%d", info->commit_interval);
> +	seq_puts(seq, ",subvol=");

Please make subvol= the last one, as it can contain any string that
could be confused with other options. Although nobody would probably
call their subvolume "name,autodefrag" etc, the way to obtain the full
path is to either resolve the subvolid, or take the whole text after
"subvol=" to the end of the line.

> +	seq_dentry(seq, dentry, " \t\n\\");
> +	seq_printf(seq, ",subvolid=%llu",
> +		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
>  	return 0;
