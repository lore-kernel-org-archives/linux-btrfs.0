Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdCMPGi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 11:06:38 -0400
Date: Mon, 13 Mar 2017 16:05:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question re. <linux/sizes.h> required since btrfs-progs-4.10
Message-ID: <20170313150559.GL14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <58C42024.6000401@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <58C42024.6000401@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 11, 2017 at 05:04:52PM +0100, Holger Hoffstätte wrote:
> I'm on Gentoo and wanted to update Docker to 17.03.0, which failed when it
> couldn't build the btrfs driver due to a missing <linux/sizes.h>.
> This worked fine on another machine the other day, so I dug in and found that
> the only difference was an intermediate update to btrfs-progs 4.10.
> Sure enough: since 4.10 ctree.h includes <linux/sizes.h>, which is nowhere
> to be found in my package of linux-headers-4.10 (also not in 4.9).
> 
> Simply copying sizes.h from the 4.9 kernel sources made everything work,
> but I'm curious whether this is actually correct - hence my question whether
> <linux/sizes.h> _should_ actually be installed? Is this a bug with
> Gentoo's kernel header package or a new problem with btrfs-progs?

That's a bug in btrfs-progs, the build tests do not cover that. There's
a local copy of sizes.h that's supposed to be used. The patch was ported
from kernel where linus/sizes.h is present but is probably not (yet)
part of the public linux-headers.

> I don't see any good reason why sizes.h should not be installed, but wanted
> to verify since there are probably users of other distributions here as
> well. :)

The build would fail on any distro. I'll commit a fix and update the
tests so this gets caught early. Thanks for the report.
