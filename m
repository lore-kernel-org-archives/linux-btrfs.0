Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50483 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbaEEWGZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 18:06:25 -0400
Date: Mon, 5 May 2014 15:06:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: john terragon <jterragon@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on software RAID0
Message-ID: <20140505220613.GW10159@merlins.org>
References: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
 <20140505212513.GS10159@merlins.org>
 <CAN05THTVtGp=R_xJg5_1OgmbDEonFSUgza-r0UGWyuuORmYSZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN05THTVtGp=R_xJg5_1OgmbDEonFSUgza-r0UGWyuuORmYSZg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 02:42:53PM -0700, ronnie sahlberg wrote:
> start-btrfs-dmcrypt :
> ...
> echo "$pwd" |
> ...
> 
> Hmmm. This makes the plaintext password visible in ps output.
> It is probably better to pass this in by redirecting a file to stdin.

echo is built in, it will not show up in ps.

Either way, the password management is a placeholder, the script I
actually use is different and custom to my own use.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
