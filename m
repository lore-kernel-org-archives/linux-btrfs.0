Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48547 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155AbcCIVpa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 16:45:30 -0500
Date: Wed, 9 Mar 2016 13:45:27 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Tobias Hunger <tobias.hunger@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs and containers
Message-ID: <20160309214527.GH14112@merlins.org>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
 <20160309211004.GK27437@merlins.org>
 <CAJCQCtRDGvxgktjQ8zduHAxh=6TvNsnEa9tz75NUvsj-SwsJ9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRDGvxgktjQ8zduHAxh=6TvNsnEa9tz75NUvsj-SwsJ9A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 02:21:26PM -0700, Chris Murphy wrote:
> > I have a very stripped down docker image that actually mounts portion of
> > of my root filesystem read only.
> > While it's running out of a btrfs filesystem, you can't run btrfs
> > commands against it:
> > 05233e5c91f0:/# btrfs fi show
> > 05233e5c91f0:/# btrfs subvol list /
> > ERROR: can't perform the search - Operation not permitted
> > 05233e5c91f0:/# btrfs subvol list .
> > ERROR: can't perform the search - Operation not permitted
> >
> > I didn't do anything special, it's just working that way.
> 
> Yep, you're not using --privileged in which case you can't list
> things. But I'm not sure what the equivalent is off hand with
> systemd-nspawn containers, I think those may always be privileged?

Ok, cool. I just used docker out of the box, glad to know it errs on
the secure side by default.
(and I don't have systemd, so that may also help me there)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
