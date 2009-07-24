From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH] Add supported kernel version check to mkfs.btrfs
Date: Fri, 24 Jul 2009 10:33:07 +1000
Message-ID: <200907241033.07852.chris@csamuel.org>
References: <20090723023411.23E8A8C03F@csamuel.org> <D102393B-AFF2-4771-822E-71D3762A1B45@karlsbakk.net> <038wif2sqv.fsf@msgid.viggen.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <038wif2sqv.fsf@msgid.viggen.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 24 Jul 2009 03:50:48 am Oystein Viggen wrote:

> Either way, I guess the RHEL developers could tell people a thing or two
> about the cleverness of assuming a kernel version equals a specific set
> of features and/or bugs.

I'm sure the RHEL developers would be able to change the #define in any tools 
they package to match the kernels they ship.

> WIBNI the btrfs kernel driver could export some kind of "btrfs_version"
> property that btrfs-tools could check instead?

Problem then is that you need to filesystem module inserted before you can 
make the filesystem, and usually that won't happen until you've mounted a 
filesystem of that type. Nice idea though!

> Then again, the need for shenanigans like this should pass quickly as
> the file system matures.

Indeed, but not that's not the case yet and we've had one person report issues 
this week that would have been caught by this. :-)

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP
