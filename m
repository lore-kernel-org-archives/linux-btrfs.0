Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60801 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbcHISX7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 14:23:59 -0400
Date: Tue, 9 Aug 2016 18:23:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs dev del hangs on 4.7
Message-ID: <20160809182356.GC9644@carfax.org.uk>
References: <20160809172758.GB9644@carfax.org.uk>
 <23be7ecd-500b-76ed-ea91-88885872031e@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
In-Reply-To: <23be7ecd-500b-76ed-ea91-88885872031e@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Chris,

On Tue, Aug 09, 2016 at 02:02:20PM -0400, Chris Mason wrote:
> On 08/09/2016 01:27 PM, Hugo Mills wrote:
> >   Over the weekend, I started doing some maintenance on my server: I
> >upgraded to 4.7.0, and I started deleting a device from my array,
> >preparatory to putting in a larger one. About halfway through the
> >operation, several kernel threads hung up for a while (resulting in
> >"blocked for 120s" messages), and then the delete process seems to
> >have stopped entirely, although several kernel threads are at maximum
> >usage.
> >
> >   After a few hours, I rebooted the machine, and left it for a day or
> >so. I tried the delete again this afternoon, and it's done the same
> >thing again. The full log is included below. I have a kworker and a
> >btrfs-transaction pegged at close to 100% of a core each, and a
> >btrfs-cleaner (and the btrfs dev del process) in D state.
> >
> >   The FS was not under load at the time of the failure, and it passes
> >scrub. I haven't tried a btrfs check yet.
> 
> Thanks Hugo, can you nail down which line of code belongs to:
> 
> btrfs_async_run_delayed_refs+0xc6

   I'm having a spot of trouble with this. The btrfs on this kernel is
built-in, and I've lost the contents of the build directory (it's done
by an overnight build script, and it's already built a 4.8-rc1 for one
of my other machines).

(gdb) file /boot/vmlinuz-4.7.0-dirty
BFD: /boot/vmlinuz-4.7.0-dirty: Warning: Ignoring section flag IMAGE_SCN_MEM_NOT_PAGED in section .bss
Reading symbols from /boot/vmlinuz-4.7.0-dirty...(no debugging symbols found)...done.
(gdb) list *btrfs_async_run_delayed_refs+0xc6
No symbol table is loaded.  Use the "file" command.

   There must be a way of getting this info from here, but I'm not
sure I know what it is. Build a new kernel from 4.7 with this
machine's config and run gdb on the btrfs.o file? Not a problem to do,
but it might take a little while.

   Hugo.

-- 
Hugo Mills             | Jazz is the sort of music where no-one plays
hugo@... carfax.org.uk | anything the same way once.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXqh+8AAoJEFheFHXiqx3kF8kP/0WdGHfM18q7ZYxq84BqRfcI
CPpLFGS00kVNijxX2Se+b2cwnW0Po3XLdzEzWjp5QybGIvL7OZxz7kNOgl3zpUx4
KMkKT3fNFmhVkoPTTHU77Ib37Z183Ru62L+6YOmKsHG5KRBjGE0tAMJeTku8XYi2
esceWgVigxp/q6Bpe/s5+xgJY2gq3PDuAxyN24k/buiDtdoGLA6V4czdV3+6uHdm
ok06VWUfLFq8ENYl0SRfZE6pa+xrfc4f6EvqukkfoR14kIBHbxXh9uIYRiyREY6x
sS/XtYqkmjPcUZ8S1FkDaBgotEWECpl+iEW906tlGZafWz1Jw5nZsAI+kWafergA
3VukSTHpmieN2tRwekxqH4Bw8JGrHG0S7OyiO1m9eT5enxtZEIfcJQ2KCAD/hYeX
GALfHZeBwHgLycbouhyULYVIRTxmTXsccR2FD0v37YZIsi8JycYM6y5dZjeHkJpr
duIsFopW70HSIoJB2gxEBABv/ALzoBCowV+BuKO7yYPRJv5gb6haI5ZQjh8VWJEO
tScpOjhVGrnnJsibBstByWBHBtQHNpzgsPy6zRH1IQtK31v6oTxc2Yz/J5AXL4Sk
Nmfy7n8S5uiiWsMQQiwSjrXatnV06IXDoaaolAq0J25zfJzq/lF2StlYz2W0oGsY
BlSuR7FIhQJLC5RH5ecd
=+/SM
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
