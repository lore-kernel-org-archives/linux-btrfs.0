Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50337 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbGODOk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 23:14:40 -0400
Date: Tue, 14 Jul 2015 20:14:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: Paul Harvey <csirac2@gmail.com>
Cc: Axel Burri <axel@tty0.ch>, Martin Steigerwald <martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone tried out btrbk yet?
Message-ID: <20150715031412.GZ5274@merlins.org>
References: <11148188.L9vtSMaNHV@merkaba>
 <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org>
 <20150713004249.GP5274@merlins.org>
 <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 10:03:16AM +1000, Paul Harvey wrote:
> The way it works in snazzer (and btrbk and I think also btrfs-sxbackup
> as well), local snapshots continue to happen as normal (Eg. daily or
> hourly) and so when your backup media or backup server is finally
> available again, the size of each individual incremental is still the
> same as usual, it just has to perform more of them.
 
Good point. My system is not as smart. Every night, it'll make a new
backup and only send one incremental and hope it gets there. It doesn't
make a bunch of incrementals and send multiple.

The other options do a better job here.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
