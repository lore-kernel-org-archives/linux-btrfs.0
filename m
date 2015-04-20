Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50420 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbbDTOt4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 10:49:56 -0400
Date: Mon, 20 Apr 2015 07:49:28 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?=22N=E9moz_Saint-Dizier=2C_Olivier=22?=
	<olivier@onsd.eu>,
        linux-btrfs@vger.kernel.org
Message-ID: <20150420144928.GT1258@merlins.org>
References: <5534D201.7080803@onsd.eu>
 <20150420102705.GF18187@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150420102705.GF18187@carfax.org.uk>
Subject: Is btrfs on top of bcache stable now?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2015 at 10:27:05AM +0000, Hugo Mills wrote:
>    See the first issue here: https://btrfs.wiki.kernel.org/index.php/Gotchas

Hi Hugo, looking at the page again, I see 
"bcache + btrfs does not seem to be stable yet"
linking to a thread more than 2 years old and btrfs kernels that
wouldn't be stable without bcache anyway.

I've seen others mention they switched to bcache recently and not seen
new "it's broken" reports.

So, is it ok
1) to assume bcache and btrfs play ok together now?
2) remove the warning from that gotchas page?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
