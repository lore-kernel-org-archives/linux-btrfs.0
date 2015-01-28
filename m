Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbbA1UOJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:09 -0500
Date: Wed, 28 Jan 2015 16:38:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Karel Zak <kzak@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-prog: improve build-system by autoconf
Message-ID: <20150128153815.GG3641@suse.cz>
Reply-To: dsterba@suse.cz
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
 <20141217140726.GY27601@twin.jikos.cz>
 <20150116152613.GC2181@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150116152613.GC2181@x2.net.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 16, 2015 at 04:26:13PM +0100, Karel Zak wrote:
> On Wed, Dec 17, 2014 at 03:07:26PM +0100, David Sterba wrote:
> > On Fri, Dec 12, 2014 at 01:35:14PM +0100, Karel Zak wrote:
> > > This is first step to make btrfs-progs build system more conventional
> > > for userspace users and developers. All is implemented by small incremental
> > > patches to keep things review-able.
> > 
> > Thanks. I went through the patches and haven't found major problems. The
> > changes are affecting build system and this will need a longer period
> > before all distros have a chance to adapt to that, so I'm postponing it
> > to 3.19.
> 
>  Note that I have rebased the autoconf patches and fixed some issues,

Rebased on 3.18.3, fixed some minor conflicts.

* I'm a bit surprised that automake is required for the
  config.{guess,sub} and install-sh files

* my oldish testbox' automake does not support the --print-libdir option
  (automake-1.11), enterprise distros ship automake of similar age

* library build test fails, but this may be because I've mismerged
  something, I'll check again

Otherwise looks ok and I'll merge it, plus a few fixups to make it build
for me.

>     https://github.com/karelzak/btrfs-progs/commits/autoconf
> 
>  you can merge it (now or later) on command line by:
> 
>     git pull --log git@github.com:karelzak/btrfs-progs.git autoconf

git-pulls are not (yet) established workflow, mailinglist is preferred,
but it does not hurt to publish branches along.

I've noticed the 'automake' branch that switches to automake. Looking at
the amount of changes and the result, I'm not quite happy and don't see
the benefit of automake. An extra layer that only obfuscates the build.
We're not using any advanced build features. Just a bunch of independent
binaries built from the same sources. The shared library is an exception
and it works.
