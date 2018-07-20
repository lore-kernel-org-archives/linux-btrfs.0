Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50416 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728252AbeGTMgC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 08:36:02 -0400
Date: Fri, 20 Jul 2018 13:48:01 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: kill btrfs_write_inode
Message-ID: <20180720114801.GA26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180522174723.13620-1-josef@toxicpanda.com>
 <20180528165759.GH6649@twin.jikos.cz>
 <20180529191742.GC23487@vader>
 <20180531094928.GN3539@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180531094928.GN3539@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2018 at 11:49:28AM +0200, David Sterba wrote:
> On Tue, May 29, 2018 at 12:17:42PM -0700, Omar Sandoval wrote:
> > On Mon, May 28, 2018 at 06:57:59PM +0200, David Sterba wrote:
> > > On Tue, May 22, 2018 at 01:47:22PM -0400, Josef Bacik wrote:
> > > > From: Josef Bacik <jbacik@fb.com>
> > > > 
> > > > We don't actually need this.  It used to be in place for O_SYNC writes,
> > > > but we've used the normal fsync() path for that for years now.  The
> > > > other case we hit this is through sync(), which will commit the
> > > > transaction anyway.  All this does is make us commit the transaction a
> > > > bunch for no reason, and it could deadlock with delayed iput's.
> > > 
> > > In what way does it deadlock with delayed iput?
> > 
> > Here's an example stack trace:
> 
> Aha, so that's an actual bugfix. The changelog should have been stated
> the other way around: there's a deadlock scenario and can be fixed by
> removing the whole function because there's another mechanism to achieve
> the same O_SYNC behaviour. Please update and resend.

Ping, update and resend if you want this patch to go to 4.19. Thanks.
