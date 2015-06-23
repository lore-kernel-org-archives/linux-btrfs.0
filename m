Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485AbbFWMxW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 08:53:22 -0400
Date: Tue, 23 Jun 2015 14:53:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.1
Message-ID: <20150623125320.GD6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150622150023.GX6761@twin.jikos.cz>
 <10252396.qecnRWx3hc@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <10252396.qecnRWx3hc@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 10:45:32PM +0200, Martin Steigerwald wrote:
> Wow, nice collection of changes!

Thanks.

> Am Montag, 22. Juni 2015, 17:00:23 schrieb David Sterba:
> > * new
> >   - rescure zero-log
> >   - btrfsune:
> >     - rewrite uuid on a filesystem image
> >     - new option to turn on NO_HOLES incompat feature
> 
> Did you think about folding btrfstune into btrfs command as well?

I'm a long-time proponent of deprecating standalone btrfstune utility,
but so far there's no satisfactory replacement in terms of user
interface.

We've tried to do the uuid rewrite through the properties but it was
kind of blocking the whole feature just because the interface was not
settled.

I'd like to avoid simply adding 'btrfs filesystem tune' with all the
functionality of btrfstune. The thoughts go towards a more generic
command group that could do active opertaions on the filesystem, eg.
similar the 'inspect-internal' to query various stuff.
