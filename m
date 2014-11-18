Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44401 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaKRQLl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 11:11:41 -0500
Date: Tue, 18 Nov 2014 08:11:15 -0800
From: Marc MERLIN <marc@merlins.org>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141118161115.GW20972@merlins.org>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org> <546B6DF0.5090306@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <546B6DF0.5090306@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 18, 2014 at 11:04:00AM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/18/2014 10:35 AM, Marc MERLIN wrote:
> > Try running hdrecover on your drive, it'll scan all your blocks and
> > try to rewrite the ones that are failing, if any: 
> > http://hdrecover.sourceforge.net/
> 
> He doesn't have blocks that are failing; he has blocks that are being
> silently corrupted.

That seems to be the case, but hdrecover will rule that part out at least.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
