Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbbC3May (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 08:30:54 -0400
Date: Mon, 30 Mar 2015 14:30:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Timo Kokkonen <timo.kokkonen@offcode.fi>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: prevent deletion of mounted subvolumes
Message-ID: <20150330123034.GB32051@suse.cz>
Reply-To: dsterba@suse.cz
References: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 30, 2015 at 02:02:17AM -0700, Omar Sandoval wrote:
> Before commit bafc9b754f75 ("vfs: More precise tests in d_invalidate"),
> d_invalidate() could return -EBUSY when a dentry for a directory had
> more than one reference to it. This is what prevented a mounted
> subvolume from being deleted, as struct vfsmount holds a reference to
> the subvolume dentry. However, that commit removed that case, and later
> commits in that patch series removed the return code from d_invalidate()
> completely, so we don't get that check for free anymore. So, reintroduce
> it in btrfs_ioctl_snap_destroy().

> This applies to 4.0-rc6. To be honest, I'm not sure that this is the most
> correct fix for this bug, but it's equivalent to the pre-3.18 behavior and it's
> the best that I could come up with. Thoughts?

> +	spin_lock(&dentry->d_lock);
> +	err = dentry->d_lockref.count > 1 ? -EBUSY : 0;
> +	spin_unlock(&dentry->d_lock);

The fix restores the original behaviour, but I don't think opencoding and
using internals is fine. Either there should be a vfs api for that or
there's an existing one that can be used instead.

The bug here seems defined up to the point that we're trying to delete a
subvolume that's a mountpoint. My next guess is that a check

	if (d_mountpoint(&dentry)) { ... }

could work.
