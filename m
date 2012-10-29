Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:34602 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab2J2FFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 01:05:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at fs/btrfs/volumes.c:3707
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121025201223.GB24111@merlins.org>
Date: Sun, 28 Oct 2012 23:05:42 -0600
Message-Id: <B19885DE-6AED-4B8B-B1CA-891878B43C8C@colorremedies.com>
References: <20121025195805.GA24111@merlins.org> <CAE5mzvi=y6Auyr9cGMOm=tUSSj7sSQ78W0Bnzk+dJOqkW6z6jA@mail.gmail.com> <20121025201223.GB24111@merlins.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 25, 2012, at 2:12 PM, Marc MERLIN <marc@merlins.org> wrote:

> I also have hourly, daily, weekly
> btrfs subvolume snapshots, but I can't use those currently since I can't
> mount the base filesystem.

It might be worth unmounting it. Then only remounting a snapshot well before the problem started, yet still current enough to be useful: use '-o subvol=' instead of trying to mount from the top. Each subvolume is a root directory, so it might be possible to find one that will mount directly.

> I'm a bit surprised that no one seems to be replying on btrfs crashes,
> that's a bit worrisome. I'm willing to risk my data somewhat, but if finding
> a problem doesn't help fixing the code, I'm not sure if I'm helping anymore
> :-/

Lurking, I've learned this means you either didn't provide enough information for anyone to go on, or the problem is known. I suspect the former. Kernel 3.5.0 or 3.6.2 doesn't say where it came from, what distribution, or what version of btrfs is included in that distros kernel. And I'm not seeing that you're using a debug kernel, which will actually produce useful error messages.

And it's over a weekend for another thing.


Chris Murphy

