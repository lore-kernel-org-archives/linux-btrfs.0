Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:51233 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaFOWjl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 18:39:41 -0400
Date: Mon, 16 Jun 2014 00:39:39 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: systemd-devel@lists.freedesktop.org, linux-btrfs@vger.kernel.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Message-ID: <20140615223939.GG24386@tango.0pointer.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
 <pan$22693$6b452195$976b783a$e4956372@cox.net>
 <20140612232453.GR9508@dastard>
 <539B78F3.9070607@libero.it>
 <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
 <539BFF47.8060006@libero.it>
 <pan$c82aa$ea13b40$dc4fc67d$63d84512@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$c82aa$ea13b40$dc4fc67d$63d84512@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 15.06.14 05:43, Duncan (1i5t5.duncan@cox.net) wrote:

> The base problem isn't fallocate per se, rather, tho it's the trigger in 
> this case.  The base problem is that for COW-based filesystems, *ANY* 
> rewriting of existing file content results in fragmentation.
> 
> It just so happens that the only reason there's existing file content to 
> be rewritten (as opposed to simply appending) in this case, is because of 
> the fallocate.  The rewrite of existing file content is the problem, but 
> the existing file content is only there in this case because of the 
> fallocate.
> 
> Taking a step back...
> 
> On a non-COW filesystem, allocating 8 MiB ahead and writing into it 
> rewrites into the already allocated location, thus guaranteeing extents 
> of 8 MiB each, since once the space is allocated it's simply rewritten in-
> place.  Thus, on a non-COW filesystem, pre-allocating in something larger 
> than single filesystem blocks when an app knows the data is eventually 
> going to be written in to fill that space anyway is a GOOD thing, which 
> is why systemd is doing it.

Nope, that's not why we do it. We do it to avoid SIGBUS on disk full...

> But on a COW-based filesystem fallocate is the exact opposite, a BAD 
> thing, because an fallocate forces the file to be written out at that 
> size, effectively filled with nulls/blanks.  Then the actual logging 
> comes along and rewrites those nulls/blanks with actual data, but it's 
> now a rewrite, which on a COW, copy-on-write, based filesystem, the 
> rewritten block is copied elsewhere, it does NOT overwrite the existing 
> null/blank block, and "elsewhere" by definition means detached from the 
> previous blocks, thus in an extent all by itself.

Well, quite frankly I am not entirely sure why fallocate() would be any
useful like that on COW file systems, if this is really how it is
implemented... I mean, as I understood fallocate() -- and as the man
page suggests -- it is something for reserving space on disk, not for
writing out anything. This is why journald is invoking it, to reserve
the space, so that later write accesses to it will not require any
reservation anymore, and hence are unlikely to fail.

Lennart

-- 
Lennart Poettering, Red Hat
