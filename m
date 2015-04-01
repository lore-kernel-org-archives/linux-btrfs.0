Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbDALWq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Apr 2015 07:22:46 -0400
Date: Wed, 1 Apr 2015 13:22:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Timo Kokkonen <timo.kokkonen@offcode.fi>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: prevent deletion of mounted subvolumes
Message-ID: <20150401112242.GG6821@suse.cz>
Reply-To: dsterba@suse.cz
References: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
 <20150330123034.GB32051@suse.cz>
 <20150330184135.GA27227@mew.dhcp4.washington.edu>
 <87k2xwv6y8.fsf@x220.int.ebiederm.org>
 <20150401070328.GA27048@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150401070328.GA27048@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 01, 2015 at 12:03:28AM -0700, Omar Sandoval wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1024,6 +1024,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>  	struct btrfs_root *root = info->tree_root;
>  	char *compress_type;
>  
> +	if (dentry != dentry->d_sb->s_root) {
> +		seq_puts(seq, ",subvol=");
> +		seq_dentry(seq, dentry, " \t\n\\");

Unfortunatelly this does not work if the default subvolume is not the
toplevel one and the implicit mount (ie. without subvol=) is used. Then
this leads to subvol=/ although it should be subvol=/the/default .

There was a patch to build the path in the show_options callback, but it
looked too heavy (taking locks, doing lookups). This is unrelated to the
problem reported by Timo, though the fix might also fix this one.
