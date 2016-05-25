Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:32905 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbcEYWLv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 18:11:51 -0400
Received: by mail-pf0-f180.google.com with SMTP id b124so22996285pfb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 15:11:51 -0700 (PDT)
Date: Wed, 25 May 2016 15:11:48 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Chris Mason <clm@fb.com>, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] Btrfs: fix ->iterate_shared() by upgrading i_rwsem for
 delayed nodes
Message-ID: <20160525221148.GA15743@vader>
References: <1e937bd41beebb68b1bf1201205059cb8f614dad.1463777299.git.osandov@fb.com>
 <20160525201129.GQ29147@twin.jikos.cz>
 <20160525202226.djc7dk4uhzuleets@floor.thefacebook.com>
 <20160525204821.GH14480@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160525204821.GH14480@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 25, 2016 at 09:48:21PM +0100, Al Viro wrote:
> On Wed, May 25, 2016 at 04:22:26PM -0400, Chris Mason wrote:
> > On Wed, May 25, 2016 at 10:11:29PM +0200, David Sterba wrote:
> > > On Fri, May 20, 2016 at 01:50:33PM -0700, Omar Sandoval wrote:
> > > > Commit fe742fd4f90f ("Revert "btrfs: switch to ->iterate_shared()"")
> > > > backed out the conversion to ->iterate_shared() for Btrfs because the
> > > > delayed inode handling in btrfs_real_readdir() is racy. However, we can
> > > > still do readdir in parallel if there are no delayed nodes.
> > > 
> > > So this is for current master (pre 4.7-rc1), I'll add an appropriate
> > > merge point for to my for-next.
> > 
> > I'll get this bashed on in a big stress.sh run, but it looks good to me.
> 
> I really don't like that approach, TBH ;-/  Is there any reason to exclude
> lookups for the duration of that thing?

Nope, no reason at all. We'll fix it properly, hopefully by 4.8, but we
at least want the parallelism for now in the easy case when we don't
have delayed nodes.

> Conversely, are we really OK
> with changes to directory happening during that "unlock and relock exclusive"?

Yeah, so at that point, the only thing we've done is checked if we had
to emit the "." and ".." entries, which is safe because of f_pos_lock,
and allocated a struct btrfs_path. So we'd be alright if something came
in and changed the directory during that window.

-- 
Omar
