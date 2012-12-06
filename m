Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48378 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946789Ab2LFSyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 13:54:06 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
Date: Thu, 6 Dec 2012 19:54:04 +0100
Cc: Marc MERLIN <marc@merlins.org>, Sylvain Alain <d2racing911@gmail.com>
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com> <20121206063151.GC20550@merlins.org> (sfid-20121206_101851_658481_E78E335D)
In-Reply-To: <20121206063151.GC20550@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212061954.04424.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 6. Dezember 2012 schrieb Marc MERLIN:
> On Wed, Dec 05, 2012 at 11:56:27PM -0500, Sylvain Alain wrote:
> > Hi everyone, I'm running btrfs since octobre 2012 and I would like to
> > understand 2 behavior that I noticed.
> > 
> > 1. When I delete a big directory, sometimes it can hang my box for 1
> > minutes or so, it seems that's the btrfs lock my SSD.
> 
> Doesn't directly answer your question, but if you don't have discard as a
> mount option, you should try that.
> 
> Which SSD do you have? Do normal big file writes succeed or hang too?
> 
> My guess right now is that you don't have discard, and your drive is doing
> very slow garbage collection. I had a Crucial C300 that did just that before
> it ate itself and my data a month later.
> Also check that your drive does not have a firmware update to remove those
> hangs.

Maybe also the drive does slow trims, but I doubt an Intel SSD 520 would
fall into that category.

In case you want to try out Sylvain, mount *without* discard option, and
run fstrim manually or by cron job from time to time.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
