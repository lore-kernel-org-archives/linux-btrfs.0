Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbcDYM2R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 08:28:17 -0400
Date: Mon, 25 Apr 2016 14:28:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Switch to generic xattr handlers
Message-ID: <20160425122805.GH23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461357404-28350-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461357404-28350-1-git-send-email-agruenba@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2016 at 10:36:44PM +0200, Andreas Gruenbacher wrote:
> The btrfs_{set,remove}xattr inode operations check for a read-only root
> (btrfs_root_readonly) before calling into generic_{set,remove}xattr.  If
> this check is moved into __btrfs_setxattr, we can get rid of
> btrfs_{set,remove}xattr.
> 
> This patch applies to mainline, I would like to keep it together with
> the other xattr cleanups if possible, though.  Could you please review?
> 
> Thanks,
> Andreas
> 
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Reviewed-by: David Sterba <dsterba@suse.com>
