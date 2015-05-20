Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbbETSCV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 14:02:21 -0400
Date: Wed, 20 May 2015 20:02:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs and integration with GNU ++
Message-ID: <20150520180219.GN23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
 <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
 <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 18, 2015 at 11:22:08AM +0200, Roy Sigurd Karlsbakk wrote:
> >> For btrfs to be accepted as a primary filesystem in major distros, I'd
> >> think it should integrate with existing tools.
> > 
> > Well, fortunately or unfortunately, btrfs is already being accepted as a
> > primary fs in major distros.
> 
> Interesting - which ones is it that's doing this?

openSUSE 13.2 started with btrfs as default for the root filesystem,
while it has been an installation option in previous versions.

SLES 12 goes for btrfs as default for the root filesystem and xfs for
the data partitions.

[...]
> > Maturity of the filesystem, again...
> 
> hehe

That's the most frequently raised point. The enterprise kernel gets
more attention regarding backporting the fixes to an old codebase, you
can find fixes from very recent upstream versions.

The kernel development is open for current and upcoming products, you
can see the tree broken out to separate patches at http://kernel.suse.com .

The upstream kernel has a different release cycle and adds features
together with bugfixes, sometimes not all the fixes make it to the
major release. Then it's usually fixed via the stable releases.

The enterprise kernel can afford to skip most of the features and
backport only relevant fixes. Stability of such kernel is different from
the upstream one, not only because of btrfs but also because of tons of
new code in other subsystems.
