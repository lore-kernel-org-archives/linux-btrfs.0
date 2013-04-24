Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab3DXNDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 09:03:53 -0400
Date: Wed, 24 Apr 2013 15:03:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        miaox@cn.fujitsu.com
Subject: Re: [PATCH] btrfs: make static code static & remove dead code
Message-ID: <20130424130350.GB16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51719932.6010406@redhat.com>
 <20130422150511.GP16427@twin.jikos.cz>
 <5175561C.90709@redhat.com>
 <20130422155545.GS16427@twin.jikos.cz>
 <51755EC5.7080706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51755EC5.7080706@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 11:01:09AM -0500, Eric Sandeen wrote:
> >> Maybe one for Arne to answer?  Yeah, I don't see it in the manpage
> >> or in userspace, so *shrug* where is the design?
> > 
> > Scrub can be started on one device, cancel is just part of the command set.
> > 
> > $ ./btrfs scrub cancel --help
> > usage: btrfs scrub cancel <path>|<device>
> >     Cancel a running scrub
> 
> Right, but device is different from devid, no?
>
> i.e. btrfs replace start can take a devid or a device, and checks for
> if (is_numerical(srcdev)); this doesn't look implemented for
> scrub cancel.   I guess it could be.

Yeah, after further research, the 'scrub cancel' ioctl uses the device
just to find the filesystem as if a path were given, and does not cancel
scrub on that device. The ioctl does not take any user data so we'd have
to do IOC_SCRUB_CANCEL_V2 in order to implement cancel-by-id (or delete
the function if this is not a valid usecase, I don't know).

david
