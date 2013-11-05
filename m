Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58180 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3KECvT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 21:51:19 -0500
Date: Mon, 4 Nov 2013 18:51:11 -0800
From: Marc MERLIN <marc@merlins.org>
To: "Matthias G. Eckermann" <matthias.g.eckermann@t-online.de>
Cc: David Madden <dhm@mersenne.com>, linux-btrfs@vger.kernel.org
Subject: Re: OK to take hourly snapshots, then cull older ones?
Message-ID: <20131105025111.GG20447@merlins.org>
References: <525CBF0D.1020609@mersenne.com>
 <20131103115024.GA5139@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131103115024.GA5139@t-online.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 03, 2013 at 12:50:24PM +0100, Matthias G. Eckermann wrote:
> Hello David and all,
> 
> On Mon, Oct 14, 2013 at 21:05 David Madden wrote:
> 
> > I'd like to use BTRFS to do something like the old NetApp
> > snapshot system: every hour or so, there'd be a snapshot,
> > then the 23 of the snapshots during a day would be
> > deleted, leaving just a day snapshot, then after a month,
> > 6 of 7 snapshots would be deleted, leaving just a week
> > snapshot, and so on.
> 
> This is implemented in "Snapper", see:
> 	http://snapper.io/
> It's by default delivered with openSUSE and SUSE Linux
> Enterprise, binaries are available for "everything else"
> as well.

Just curious, what does it do more than the 20 line shellscript I
posted?
http://marc.merlins.org/linux/scripts/btrfs_snaps

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
