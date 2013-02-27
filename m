Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab3B0PT7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 10:19:59 -0500
Date: Wed, 27 Feb 2013 16:19:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, penn43@gmx.com,
        linux-btrfs@vger.kernel.org
Subject: Re: Writing a wtapper for BTRFS
Message-ID: <20130227151957.GG27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <512E01BD.2040302@gmx.com>
 <20130227130846.GM14283@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130227130846.GM14283@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 01:08:46PM +0000, Hugo Mills wrote:
>    You may want to look at the btrfs-progs libify patches (posted to
> this list in the last couple of months), which try to pull out the
> more useful bits of btrfs-progs as a userspace C API.

FYI, libify patch will be in the next integration branch.

>    You may also want to look at the bits I implemented in python[2]
> for a subset of the btrfs ioctls and data structures in btrfs-gui.
> 
>    Other than that, it's down to the data structures documentation on
> the wiki[1], and reading through ioctl.h.

bedup https://github.com/g2p/bedup does python binding, in a different
way than btrfs-gui.

david
