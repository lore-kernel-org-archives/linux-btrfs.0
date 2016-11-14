Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45101 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752357AbcKNMew (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 07:34:52 -0500
Date: Mon, 14 Nov 2016 13:34:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] ioctl.h: add missing kernel compatibility header for
 BUILD_ASSERT
Message-ID: <20161114123449.GL12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161024082912.20253-1-slyich@gmail.com>
 <20161024125205.GB11398@twin.jikos.cz>
 <20161112221449.0cd3d16b@sf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161112221449.0cd3d16b@sf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 12, 2016 at 10:14:49PM +0000, Sergei Trofimovich wrote:
> > > Basically gcc tries to say us BUILD_ASSERT is not visible.
> > > 
> > > BUILD_ASSERT lives in kerncompat.h which this change adds.  
> > 
> > I think including the kerncompat.h is too intrusive here, I've fixed by
> > providing an empty macro if it's not defined. I'll release 4.8.2 soon.
> 
> Apologies. I did not test your fix right afterwards. Seems now header is incomplete
> due to missing NULL (gcc-6):
> 
> btrfs-progs-v4.8.3 $ gcc -c ioctl.h -o /tmp/a.o
> ioctl.h: In function 'btrfs_err_str':
> ioctl.h:711:11: error: 'NULL' undeclared (first use in this function)
>     return NULL;
>            ^~~~
> ioctl.h:711:11: note: each undeclared identifier is reported only once for each function it appears in

The ioctl.h file can be included in both C and C++ code, I'd rahter
avoid to ifdef the right definition of NULL, so s/NULL/0/ seems as a
best fix to me.

Compiling with g++ shows other type errors like

ioctl.h:709:5: warning: ISO C++ forbids converting a string constant to ‘char*’ [-Wwrite-strings]
     "in progress";

so we'd have to change the type to 'const char*'. I'm not sure how much
breakage this could cause in programs using the header.
