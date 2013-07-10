Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3GJWy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 18:54:59 -0400
Date: Thu, 11 Jul 2013 00:54:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Roger Pack <rogerpack2005@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: lz4 status?
Message-ID: <20130710225454.GJ25386@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CADCGFBVa42xr+4ie20GupFfZJzteihPNDnr4b_8_8UmfK_0M5w@mail.gmail.com>
 <CAKcLGm-JPT9XY7pS2Fv_G1RWXyovcYVQeO1WMR3a+DHm_PNoHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm-JPT9XY7pS2Fv_G1RWXyovcYVQeO1WMR3a+DHm_PNoHg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 30, 2013 at 12:35:09PM -0500, Mitch Harder wrote:
> There's been a parallel effort to incorporate a general set of lz4
> patches in the kernel.
> 
> I see these patches are currently queued up in the linux-next tree, so
> we may see them in the 3.11 kernel.

The patches are now merged into 3.11.

> It looks like lz4 and lz4hc will be provided.

Regarding HC mode, there are some core compression code changes needed
in order to fully utilize the its potential, namely larger chunk size
that's compressed at a time. There was some tiny yet measurable gain of
HC against ordinary mode compared on current 4k-at-a-time
implementation, but the space savings did not justify the speed drop of
HC mode.

I can't say if the patchset will be ready for 3.12 though.

david
