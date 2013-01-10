Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab3AJLna (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:43:30 -0500
Date: Thu, 10 Jan 2013 12:43:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Randy Barlow <randy@electronsweatshop.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs fs not mounting or being identified after power loss.
Message-ID: <20130110114329.GC20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com>
 <50ECAC5C.9080902@electronsweatshop.com>
 <CACCfv7roxHpeBd5PCUEwn9ACFpq4396wHSMg2itEsf6k3CDkrA@mail.gmail.com>
 <50EE38DC.6000802@electronsweatshop.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EE38DC.6000802@electronsweatshop.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 09, 2013 at 10:43:24PM -0500, Randy Barlow wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> > kernel is at 3.6.11-1-ARCH
> 
> Sorry I don't know much to help you, but I would suggest perhaps using
> a newer kernel in the future. It sounds like your FS might be in
> trouble as is, but I would recommend using the most recent RC kernel
> (3.8-rc3) and restoring your data to a new btrfs from backups. In
> general, it's a good idea to stick to pretty recent kernels with btrfs.

There are some problems with the 3.8-rc kernels, please do not use them
yet, and I don't think that kernel upgrade would help in Jordan's case.

david
