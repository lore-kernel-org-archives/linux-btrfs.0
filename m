Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33619 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3L3R5z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 12:57:55 -0500
Date: Mon, 30 Dec 2013 09:57:40 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        hugo@carfax.org.uk
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Message-ID: <20131230175740.GS19863@merlins.org>
References: <20131228171943.GE19863@merlins.org>
 <20131228173730.GA7234@carfax.org.uk>
 <20131228180758.GF19863@merlins.org>
 <20131228182023.GG19863@merlins.org>
 <1388419531.11341.6.camel@ret.masoncoding.com>
 <20131230161729.GQ19863@merlins.org>
 <1388420830.11341.12.camel@ret.masoncoding.com>
 <20131230171039.GC26054@merlins.org>
 <95A29B65-87F9-4B73-9715-2BBC10833A64@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <95A29B65-87F9-4B73-9715-2BBC10833A64@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 30, 2013 at 10:48:10AM -0700, Chris Murphy wrote:
> 
> On Dec 30, 2013, at 10:10 AM, Marc MERLIN <marc@merlins.org> wrote:
> > 
> > If one day, it could at least work on a subvolume level (only sync a
> > subvolume), then it would be more useful to me. Maybe later…
> 
> Maybe I'm missing something, but btrfs send/receive only work on a subvolume level.

Never mind, I seem to be the one being dense. I mis-read that you needed
to create the filesystem with btrfs receive.
Indeed, it's on a subvolume level, so it's actually fine since it does
allow over provisionning afterall.

My bad, sorry :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
