Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752597AbcKNPud (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 10:50:33 -0500
Date: Mon, 14 Nov 2016 16:50:29 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Sergei Trofimovich <slyich@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] ioctl.h: add missing kernel compatibility header for
 BUILD_ASSERT
Message-ID: <20161114155028.GN12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161024082912.20253-1-slyich@gmail.com>
 <20161024125205.GB11398@twin.jikos.cz>
 <20161112221449.0cd3d16b@sf>
 <20161114123449.GL12522@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161114123449.GL12522@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2016 at 01:34:49PM +0100, David Sterba wrote:
> On Sat, Nov 12, 2016 at 10:14:49PM +0000, Sergei Trofimovich wrote:
> > > > Basically gcc tries to say us BUILD_ASSERT is not visible.
> > > > 
> > > > BUILD_ASSERT lives in kerncompat.h which this change adds.  
> > > 
> > > I think including the kerncompat.h is too intrusive here, I've fixed by
> > > providing an empty macro if it's not defined. I'll release 4.8.2 soon.
> > 
> > Apologies. I did not test your fix right afterwards. Seems now header is incomplete
> > due to missing NULL (gcc-6):
> > 
> > btrfs-progs-v4.8.3 $ gcc -c ioctl.h -o /tmp/a.o
> > ioctl.h: In function 'btrfs_err_str':
> > ioctl.h:711:11: error: 'NULL' undeclared (first use in this function)
> >     return NULL;
> >            ^~~~
> > ioctl.h:711:11: note: each undeclared identifier is reported only once for each function it appears in
> 
> The ioctl.h file can be included in both C and C++ code, I'd rahter
> avoid to ifdef the right definition of NULL, so s/NULL/0/ seems as a
> best fix to me.

Or #include <stddef.h>, now committed to devel.
