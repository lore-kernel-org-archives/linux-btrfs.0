Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433Ab3EGMNq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 08:13:46 -0400
Date: Tue, 7 May 2013 14:13:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Josef Bacik <jbacik@fusionio.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: use only memmove_extent_buffer and simplify the
 helpers
Message-ID: <20130507121344.GF16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367242681-8835-1-git-send-email-dsterba@suse.cz>
 <20130503203344.GE12414@localhost.localdomain>
 <20130503203741.5844.76366@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130503203741.5844.76366@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 03, 2013 at 04:37:41PM -0400, Chris Mason wrote:
> Quoting Josef Bacik (2013-05-03 16:33:44)
> > On Mon, Apr 29, 2013 at 07:38:01AM -0600, David Sterba wrote:
> > > After commit a65917156e34594 ("Btrfs: stop using highmem for
> > > extent_buffers") we don't need to call kmap_atomic anymore and can
> > > reduce the move_pages helper to a simple memmove.
> > > 
> > > There's only one caller of memcpy_extent_buffer, we can use the
> > > memmove_ variant here.
> > > 
> > 
> > This makes -l 64k blow the hell up, just try generic/001.  I'm kicking this
> > patch out.  Thanks,
> 
> Sorry Dave, I only now remember having this same problem the last time I
> tried to get rid of memcpy.

The patch evolved from a minor cleanup inside copy_page into a
functional change that looked ok to me after checking that memmove
behaves like memcpy if it's safe (both generic and arch-specific
implementations). Well, apparently not, but I still see some space for
micro-optimizations around copy_pages/move_pages.

david
