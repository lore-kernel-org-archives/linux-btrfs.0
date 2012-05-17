Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34546 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2EQKoN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 06:44:13 -0400
Date: Thu, 17 May 2012 11:44:09 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Maloney <peter.maloney@brockmann-consult.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How can I create useful bug reports? Here are 50 lines of
 messages including Call Trace from a system crash.
Message-ID: <20120517104409.GY8938@carfax.org.uk>
References: <4FB4D262.8020407@brockmann-consult.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qie/H+CJBZigrS0F"
In-Reply-To: <4FB4D262.8020407@brockmann-consult.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qie/H+CJBZigrS0F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 12:26:42PM +0200, Peter Maloney wrote:
> I am using btrfs at home on my root system because I want to be able to
> send useful bug reports when things go wrong.
> 
> And I have 3 questions:
> 
> What kernel should I be using?

   One of:

 - josef's "btrfs-next"[1],
 - Chris's main repo[2], or
 - kernel.org mainline -rc kernels[3].

   The latter two will generally be carrying identical btrfs code. The
first one is rather more experimental.

> And how do I create good bug reports? Is a "Call Trace" that I find in
> /var/log/messages enough, or do I need to install some debug packages
> and run some tools?

   If you have a backtrace in /var/log/messages, yes, that's a good
start. Generally, state what you did to get the error, whether it's
repeatable, what kernel version you're using, and any error messages
you got. If there's extra info needed, whoever picks it up will ask.

> Can someone also tell me how to find device error counts? (like what
> ZFS's zpool status shows under the "read" and "write" columns, not
> scrub/checksums on data, but the device errors)

   We don't have those right now -- Stefan Behrens posted a patch here
yesterday to keep track of them. :)

> I am using version 3.4.0-rc7-1-default which I got using openSUSE KOTD.
> Is that a good choice? It would be convenient to use these openSUSE
> repositories.

   Yes, that's reasonable.

> Someone in the #btrfs IRC channel told me to use this:
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> 
> I managed to crash my system today with a USB stick that is defective.
> (dd to the direct device hangs and causes it to change device names, eg.
> from sdb to sdc.) I would like to properly report this so it can be
> fixed. A bad disk should not take down the system.

   Proper error handling is an ongoing work. It's a lot better than it
used to be (back in 2.6.32 days, if you ran out of space, the whole
system could come down :) ), but there's still quite a few things left
to deal with. USB is distinctly unreliable, and seems to cause more
problems than most other block stacks right now.

   Hugo.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
[2] git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
[3] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "There's more than one way to do it" is not a commandment. It ---  
                           is a dire warning.                            

--qie/H+CJBZigrS0F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPtNZ5IKyzvlFcI40RAjnQAJ0ZreBcOehX9rrrh/w1iXohAWGn+QCfdzKd
Z6BGD5V8LHOq9/JhopuS09U=
=PpEu
-----END PGP SIGNATURE-----

--qie/H+CJBZigrS0F--
