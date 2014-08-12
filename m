Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48603 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaHLEuC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 00:50:02 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:58214 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1XH41z-0003PS-4G by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 21:50:01 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1XH41x-000319-IG
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 21:49:53 -0700
Date: Mon, 11 Aug 2014 21:49:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140812044953.GF8314@merlins.org>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
 <53C7CD0F.7070603@fb.com>
 <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
 <1745216.hDa4tC2HJJ@merkaba>
 <53CE7ACF.7070109@fb.com>
 <20140812025521.GA6730@pyropus.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140812025521.GA6730@pyropus.ca>
Subject: Re: Blocked tasks on 3.15.1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 08:55:21PM -0600, Charles Cazabon wrote:
> The blocked tasks issue that got significantly worse in 3.15 -- did anything
> go into 3.16 related to this?  I didn't see a single "btrfs" in Linus' 3.16
> announcement, so I don't know whether it should be better, the same, or worse
> in this respect...
> 
> I haven't seen a definite statement about this on this list, either.

Yes, 3.15 is unusable for some workloads, mine included.
Go back to 3.14 until there is a patch in 3.16, which there isn't quite
as for right now, but very soon hopefully.

Note 3.16.0 is actually worse than 3.15 for me.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
