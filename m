Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbbDIQ2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 12:28:50 -0400
Date: Thu, 9 Apr 2015 18:28:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
Message-ID: <20150409162848.GH25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428471096.git.osandov@osandov.com>
 <0d43234f1b2c1d35a06e8259ca94c7d976e0a604.1428471096.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0d43234f1b2c1d35a06e8259ca94c7d976e0a604.1428471096.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 07, 2015 at 10:34:01PM -0700, Omar Sandoval wrote:
> Currently, mounting a subvolume with subvolid= takes a different code
> path than mounting with subvol=. This isn't really a big deal except for
> the fact that mounts done with subvolid= or the default subvolume don't
> have a dentry that's connected to the dentry tree like in the subvol=
> case. To unify the code paths, when given subvolid= or using the default
> subvolume ID, translate it into a subvolume name by walking
> ROOT_BACKREFs in the root tree and INODE_REFs in the filesystem trees.

Can you please split this patches? It's doing several things, but the
core change will probably be a big one. The mount path is not trivial,
all the recursions and argument replacements.

Otherwise, I'm ok with this approach, ie. to set up the dentry at mount
time.

A few comments below.

>  /*
> - * This will strip out the subvol=%s argument for an argument string and add
> - * subvolid=0 to make sure we get the actual tree root for path walking to the
> - * subvol we want.
> + * This will add subvolid=0 to the argument string while removing any subvol=
> + * and subvolid= arguments to make sure we get the top-level root for path
> + * walking to the subvol we want.
>   */
>  static char *setup_root_args(char *args)
>  {
> -	unsigned len = strlen(args) + 2 + 1;
> -	char *src, *dst, *buf;
> -
> -	/*
> -	 * We need the same args as before, but with this substitution:
> -	 * s!subvol=[^,]+!subvolid=0!
> -	 *
> -	 * Since the replacement string is up to 2 bytes longer than the
> -	 * original, allocate strlen(args) + 2 + 1 bytes.
> -	 */
> +	char *p, *dst, *buf;

Fix the coding style.

>  	root = mount_subtree(mnt, subvol_name);
> +	mnt = NULL; /* mount_subtree drops our reference on the vfsmount. */

Put the comment on a separate line.

> +	if (!IS_ERR(root) && subvol_objectid &&
> +	    BTRFS_I(root->d_inode)->root->root_key.objectid != subvol_objectid) {
> +		pr_warn("BTRFS: subvol '%s' does not match subvolid %llu\n",
> +			subvol_name, subvol_objectid);

We should define the precedence of subvolid and subvol if both are set.
A warning might not be enough.
