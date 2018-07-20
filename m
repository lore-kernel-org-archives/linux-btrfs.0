Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43219 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388134AbeGTTTs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 15:19:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id v13-v6so7546670pgr.10
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 11:30:19 -0700 (PDT)
Date: Fri, 20 Jul 2018 11:30:17 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: kill btrfs_write_inode
Message-ID: <20180720183017.GE29351@vader>
References: <20180522174723.13620-1-josef@toxicpanda.com>
 <20180528165759.GH6649@twin.jikos.cz>
 <20180529191742.GC23487@vader>
 <20180531094928.GN3539@twin.jikos.cz>
 <20180720114801.GA26141@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180720114801.GA26141@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 01:48:01PM +0200, David Sterba wrote:
> On Thu, May 31, 2018 at 11:49:28AM +0200, David Sterba wrote:
> > On Tue, May 29, 2018 at 12:17:42PM -0700, Omar Sandoval wrote:
> > > On Mon, May 28, 2018 at 06:57:59PM +0200, David Sterba wrote:
> > > > On Tue, May 22, 2018 at 01:47:22PM -0400, Josef Bacik wrote:
> > > > > From: Josef Bacik <jbacik@fb.com>
> > > > > 
> > > > > We don't actually need this.  It used to be in place for O_SYNC writes,
> > > > > but we've used the normal fsync() path for that for years now.  The
> > > > > other case we hit this is through sync(), which will commit the
> > > > > transaction anyway.  All this does is make us commit the transaction a
> > > > > bunch for no reason, and it could deadlock with delayed iput's.
> > > > 
> > > > In what way does it deadlock with delayed iput?
> > > 
> > > Here's an example stack trace:
> > 
> > Aha, so that's an actual bugfix. The changelog should have been stated
> > the other way around: there's a deadlock scenario and can be fixed by
> > removing the whole function because there's another mechanism to achieve
> > the same O_SYNC behaviour. Please update and resend.
> 
> Ping, update and resend if you want this patch to go to 4.19. Thanks.

Josef just left for vacation, but I can resend this with a better
description.
