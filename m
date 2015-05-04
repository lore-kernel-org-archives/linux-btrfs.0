Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbbEDQdp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 May 2015 12:33:45 -0400
Date: Mon, 4 May 2015 18:33:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: progs bug(ish?) report
Message-ID: <20150504163343.GB5099@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150429222438.GG18480@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150429222438.GG18480@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 29, 2015 at 10:24:38PM +0000, Hugo Mills wrote:
>    Not sure if it really counts as a bug, mostly just an
> inconvenience, but ./configure completes happily, and then make fails
> with:
> 
> btrfs-convert.c:27:21: fatal error: sys/acl.h: No such file or directory

Thanks, it's a bug.

> so I guess it needs an additional check for libacl1. I can't see a
> pkg-config entry for it on my system. OTOH, I don't see where there's
> any linkage with libacl in the makefile, and it's clearly finding the
> include files successfully.

Right, btrfs-convert does not link against libacl. I can see it use
some of the ACL_ macros (simple values only) and none of the functions
provided by libacl. For that reason I'd rather avoid dependency on the
library and copy the values.

The acl values are directly read from the extN data, so it's more part
of the on-disk format than an interface to libacl. For that reason I'm
not worried about having the local copy. I'll fix that.
