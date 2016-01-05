Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbcAEJmV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 04:42:21 -0500
Date: Tue, 5 Jan 2016 10:40:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: dsterba@suse.cz, Sree Harsha Totakura <sreeharsha@totakura.in>,
        linux-btrfs@vger.kernel.org
Subject: Re: Confining scrub to a subvolume
Message-ID: <20160105094000.GP4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56831EA2.3090807@totakura.in>
 <20151230173949.GH4227@twin.jikos.cz>
 <1451503560.6350.3.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451503560.6350.3.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 08:26:00PM +0100, Christoph Anton Mitterer wrote:
> On Wed, 2015-12-30 at 18:39 +0100, David Sterba wrote:
> > The closest would be to read the files and look for any reported
> > errors.
> Doesn't that fail for any multi-device setup, in which case btrfs reads
> the blocks only from one device, and if that verifies, doesn't check
> the other?

That's right, it's not equivalent to the scrub.
