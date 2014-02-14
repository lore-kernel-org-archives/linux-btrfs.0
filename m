Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaBNQFn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 11:05:43 -0500
Date: Fri, 14 Feb 2014 17:05:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Possible to wait for snapshot deletion?
Message-ID: <20140214160541.GT16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
 <4127554.quurJk0k5Q@vfr>
 <al30ta-po2.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <al30ta-po2.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 14, 2014 at 01:12:58AM +0100, Kai Krakow wrote:
> Garry T. Williams <gtwilliams@gmail.com> schrieb:
> 
> > On 2-13-14 20:02:43 Kai Krakow wrote:
> >> Is it technically possible to wait for a snapshot completely purged
> >> from disk? I imagine an option like "--wait" for btrfs delete
> >> subvolume.
> > 
> > This may be what you're looking for:
> > 
> >     http://www.spinics.net/lists/linux-btrfs/msg29833.html
> > 
> 
> Looks fantastic. Can I vote to get it into official sources? ;-)

This has been in the development integration branch for some time and
is present in the integration branch pending for the next release.
