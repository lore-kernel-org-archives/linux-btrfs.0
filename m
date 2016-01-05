Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbcAEN5R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 08:57:17 -0500
Date: Tue, 5 Jan 2016 14:54:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, codebird@birds-are-nice.me
Subject: Re: [PATCH V2] Btrfs: disable online scrub repair on ro cases
Message-ID: <20160105135456.GZ4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449190558-11205-1-git-send-email-bo.li.liu@oracle.com>
 <1449251884-24135-1-git-send-email-bo.li.liu@oracle.com>
 <20151207143743.GD4227@twin.jikos.cz>
 <20151207182551.GA23357@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151207182551.GA23357@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 07, 2015 at 10:26:05AM -0800, Liu Bo wrote:
> On Mon, Dec 07, 2015 at 03:37:43PM +0100, David Sterba wrote:
> > On Fri, Dec 04, 2015 at 09:58:04AM -0800, Liu Bo wrote:
> > > This disables repair process on ro cases as it can cause system
> > > to be unresponsive on the ASSERT() in repair_io_failure().
> > > 
> > > This can happen when scrub is running and a hardware error pops up,
> > > we should fallback to ro mounts gracefully instead of being unresponsive.
> > 
> > So this will also report the error as uncorrectable. This might be a bit
> > misleading, if a device error happens first and then some potentially
> > corectable errors are detected. This could be accounted as 'unverified'
> > error, that has closet maning.
> 
> Make sense, we can do
> if (ret < 0 && ret == -EROFS)
> 	spin_lock();
> 	unverified++;
> 	spin_unlock()
> 
> However, in scrub_fixup_nodatasum() all errors including ENOMEM of path
> allocation and failure of trans are interpreted to 'uncorrectable', So I
> wander it means this 'uncorrectable' is only valid in this scrub process?

I'm not sure we have a proper definition of the various stats. My user
expectation is that 'uncorrectable' refers to permament errors, so we
should try to match the type of error everywhere.
