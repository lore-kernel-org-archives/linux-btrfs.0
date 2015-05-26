Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbbEZNSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 09:18:31 -0400
Date: Tue, 26 May 2015 15:18:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Anthony Plack <anthony@plack.net>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Log the error conditions to determine which
 caused the error in btrfs_init_inode_security
Message-ID: <20150526131829.GI23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <B6FEFB35-F6C4-41B7-9750-EC400392C0B8@plack.net>
 <20150525125740.GG23255@twin.jikos.cz>
 <8C081E15-B762-43C0-A65B-6D7D15983DC9@plack.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8C081E15-B762-43C0-A65B-6D7D15983DC9@plack.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 25, 2015 at 09:41:04AM -0500, Anthony Plack wrote:
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -117,6 +117,10 @@ static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
>         err = btrfs_init_acl(trans, inode, dir);
>         if (!err)
>                 err = btrfs_xattr_security_init(trans, inode, dir, qstr);

In this example, I think that the additional pr_debug does not help.
btrfs_xattr_security_init is a smple wrapper around the generic function
security_inode_init_security so basically all errors are not from btrfs
but the sercurity subsystem.

And this has either its own way to report problems or the error code is
returned back to userspace. In this case its create, mknod or mkdir (ie.
the callers of btrfs_xattr_security_init).

> +               if (err)
> +                       pr_debug("BTRFS: Unable to init xattr security. error=%d,transid=%d,inode=%d,dir=%d,qstr=%s", err, trans->transid, inode->i_uid, dir->i_uid, qstr->name);

- error is returned back to userspace,
- transid is not IMHO interesing as we're probably not going to use it
  to compare to any past or future transid
- uid/gid and name should be put into the security context, that's out
  of btrfs reach

I think it would be better to first start in functions that are part of
the user interface and somehow specific to btrfs (ie. the ioctls).

Another tip is to enhance debugging in some specific subsystem of btrfs.
The existing example is enospc. At the moment I don't have 100% sure
pointers so we might need a few more rounds.
