Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3ARRW3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 12:22:29 -0500
Date: Fri, 18 Jan 2013 18:22:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
Message-ID: <20130118172226.GC19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130117174721.GD22785@twin.jikos.cz>
 <50F96B3E.6000507@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F96B3E.6000507@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 18, 2013 at 10:33:18AM -0500, Gene Czarcinski wrote:
> I would like to recommend some additional patches for inclusion since they
> are currently part of the Fedora 18 btrfs-tools package.

Thanks. For now I'd like to gather all the small bugfixes and updates
that are likely not to create any significant conflicts with whatever
Chris has in his tree and skip new features, UI changes or non-obvious
fixes.

> Josef Bacik:  detect if the disk we are formatting is a ssd V2
> http://article.gmane.org/gmane.comp.file-systems.btrfs/18749

This is IMO a safe feature, the comments were addressed in the final
patch so we can try to push it.

> This one may be a little more of a problem since the suggested man update is
> missing and there is a second part for the kernel (status unknown).
> Josef Bacik:  add btrfs device ready command
> http://article.gmane.org/gmane.comp.file-systems.btrfs/18129
> Since Fedora uses a "stock" a kernel as possible, I suspect the
> corresponding patch is applied.

The kernel part of 'device ready' was merged to 3.6.

> There are two or three other patches that appear to make sense but I have no
> idea if they have been submitted.

Please send them to the list.

david
