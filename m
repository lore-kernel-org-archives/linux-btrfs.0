Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48965 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753442AbeE3T1h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 15:27:37 -0400
Date: Wed, 30 May 2018 21:24:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, Jun Wu <quark@fb.com>
Subject: Re: [PATCH] Btrfs: clean up error handling in btrfs_truncate()
Message-ID: <20180530192452.GI3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <63257e551e4ebd40d77dc0758f7bada3d38e71e9.1527008327.git.osandov@fb.com>
 <20180529192431.GD23487@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180529192431.GD23487@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2018 at 12:24:31PM -0700, Omar Sandoval wrote:
> On Tue, May 22, 2018 at 09:59:50AM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > btrfs_truncate() uses two variables for error handling, ret and err (if
> > this sounds familiar, it's because btrfs_truncate_inode_items() did
> > something similar). This is error prone, as was made evident by "Btrfs:
> > fix error handling in btrfs_truncate()". We only have err because we
> > don't want to mask an error if we call btrfs_update_inode() and
> > btrfs_end_transaction(), so let's make that its own scoped return
> > variable and use ret everywhere else.
> > 
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> > This is the same as my v1 "Btrfs: fix error handling in
> > btrfs_truncate()", but rebased on top of kdave/for-next + v2 of "Btrfs:
> > fix error handling in btrfs_truncate()".
> > 
> >  fs/btrfs/inode.c | 33 ++++++++++++++-------------------
> >  1 file changed, 14 insertions(+), 19 deletions(-)
> 
> Dave, what are your thoughts on this one? Are you thinking 4.18 or 4.19?

This one is still ok for 4.18.
