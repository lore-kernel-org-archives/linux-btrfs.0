Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45235 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752613Ab1K3X3D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Nov 2011 18:29:03 -0500
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
To: chb@muc.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/20] Btrfs: initialize new bitmaps' list
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
	<f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
	<CAO47_--r5NVPLpLRW0ftUs4T3xtEuJqMpAz1t7SYnHGdM0e=Fg@mail.gmail.com>
Date: Wed, 30 Nov 2011 21:28:46 -0200
In-Reply-To: <CAO47_--r5NVPLpLRW0ftUs4T3xtEuJqMpAz1t7SYnHGdM0e=Fg@mail.gmail.com>
	(Christian Brunner's message of "Tue, 29 Nov 2011 22:00:40 +0100")
Message-ID: <or62i1rxzl.fsf@livre.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Nov 29, 2011, Christian Brunner <chb@muc.de> wrote:

> When I'm doing havy reading in our ceph cluster. The load and wait-io
> on the patched servers is higher than on the unpatched ones.

That's unexpected.

> This seems to be coming from "btrfs-endio-1". A kernel thread that has
> not caught my attention on unpatched systems, yet.

I suppose I could wave my hands while explaining that you're getting
higher data throughput, so it's natural that it would take up more
resources, but that explanation doesn't satisfy me.  I suppose
allocation might have got slightly more CPU intensive in some cases, as
we now use bitmaps where before we'd only use the cheaper-to-allocate
extents.  But that's unsafisfying as well.

> Do you have any idea what's going on here?

Sorry, not really.

> (Please note that the filesystem is still unmodified - metadata
> overhead is large).

Speaking of metadata overhead, I found out that the bitmap-enabling
patch is not enough for a metadata balance to get rid of excess metadata
block groups.  I had to apply patch #16 to get it again.  It sort of
makes sense: without patch 16, too often will we get to the end of the
list of metadata block groups and advance from LOOP_FIND_IDEAL to
LOOP_CACHING_WAIT (skipping NOWAIT after we've cached free space for all
block groups), and if we get to the end of that loop as well (how?  I
couldn't quite figure out, but it only seems to happen under high
contention) we'll advance to LOOP_ALLOC_CHUNK and end up unnecessarily
allocating a new chunk.

Patch 16 makes sure we don't jump ahead during LOOP_CACHING_WAIT, so we
won't get new chunks unless they can really help us keep the system
going.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
