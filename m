Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60806 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbcHIS1f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 14:27:35 -0400
Date: Tue, 9 Aug 2016 18:27:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs dev del hangs on 4.7
Message-ID: <20160809182733.GD9644@carfax.org.uk>
References: <20160809172758.GB9644@carfax.org.uk>
 <23be7ecd-500b-76ed-ea91-88885872031e@fb.com>
 <20160809182356.GC9644@carfax.org.uk>
 <b325a93d-47ca-be69-04b2-271cd7387506@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
In-Reply-To: <b325a93d-47ca-be69-04b2-271cd7387506@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 09, 2016 at 02:26:14PM -0400, Chris Mason wrote:
> On 08/09/2016 02:23 PM, Hugo Mills wrote:
> >   Hi, Chris,
> >
> >On Tue, Aug 09, 2016 at 02:02:20PM -0400, Chris Mason wrote:
> >>On 08/09/2016 01:27 PM, Hugo Mills wrote:
> >>>  Over the weekend, I started doing some maintenance on my server: I
> >>>upgraded to 4.7.0, and I started deleting a device from my array,
> >>>preparatory to putting in a larger one. About halfway through the
> >>>operation, several kernel threads hung up for a while (resulting in
> >>>"blocked for 120s" messages), and then the delete process seems to
> >>>have stopped entirely, although several kernel threads are at maximum
> >>>usage.
> >>>
> >>>  After a few hours, I rebooted the machine, and left it for a day or
> >>>so. I tried the delete again this afternoon, and it's done the same
> >>>thing again. The full log is included below. I have a kworker and a
> >>>btrfs-transaction pegged at close to 100% of a core each, and a
> >>>btrfs-cleaner (and the btrfs dev del process) in D state.
> >>>
> >>>  The FS was not under load at the time of the failure, and it passes
> >>>scrub. I haven't tried a btrfs check yet.
> >>
> >>Thanks Hugo, can you nail down which line of code belongs to:
> >>
> >>btrfs_async_run_delayed_refs+0xc6
> >
> >   I'm having a spot of trouble with this. The btrfs on this kernel is
> >built-in, and I've lost the contents of the build directory (it's done
> >by an overnight build script, and it's already built a 4.8-rc1 for one
> >of my other machines).
> >
> >(gdb) file /boot/vmlinuz-4.7.0-dirty
> >BFD: /boot/vmlinuz-4.7.0-dirty: Warning: Ignoring section flag IMAGE_SCN_MEM_NOT_PAGED in section .bss
> >Reading symbols from /boot/vmlinuz-4.7.0-dirty...(no debugging symbols found)...done.
> >(gdb) list *btrfs_async_run_delayed_refs+0xc6
> >No symbol table is loaded.  Use the "file" command.
> >
> >   There must be a way of getting this info from here, but I'm not
> >sure I know what it is. Build a new kernel from 4.7 with this
> >machine's config and run gdb on the btrfs.o file? Not a problem to do,
> >but it might take a little while.
> 
> As long as you use the same gcc and config file, it'll almost always
> generate the same offsets/code.  You can recompile with debug
> symbols on and it'll be accurate.

   OK. Back later.

   Hugo.

-- 
Hugo Mills             | Jazz is the sort of music where no-one plays
hugo@... carfax.org.uk | anything the same way once.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXqiCVAAoJEFheFHXiqx3k26IQAJvBlJM+jXQ3LX8stdAH+0+q
SefVmjmZ5zWmXS5c/ByONctuqyoD7h96Qh9+JAVUefm7QCpfxjwVZHGiGkmZCjhp
vMt2YwxQ39Q9yg6xwlIbYsoS1QTZz0EuxI9LWtLIvBLWzGH1osxWzAv5LxAc0NZ0
rkF7HSprsFLJ+OdefnuwTnCW318tVWxOzhYS/fo7QMtVPvsGY0OP7Us94PMKwVMR
s/7z9byU6q/6BzyZ8D1Z2afpUckBfAVnaj+uMe9pB2IehrY1yuWnZftcGPQ+cY5T
kJhI5DBylLWNkH4RfhPfOMFTX4JSNwB95voZt5xTZbAZqdRgxUnNRxGXHa18ZpBi
8nIihn1l8rJzfHUEVoh14lS0H6uGGazFP5ACiJCaHNTQhJuSRq4g6wcsoDjHQgoe
fQ0GF2VUfrzaUvudBPKz9+Eb5ciw2tyyJJz9VrUFC1qYzRNIA33f2fniJK3Wu07Z
b39Sgicj/hPjKQaX2RFk1XHbqXNpZeWhZh0pEtlMWfUMX1t9T1iLxm0A3iXh21WZ
ypBgrLkbtG2/LoDSp/o2g3PoMtyFpP2/Q40siEpwym5vW5bF26WXH9ts4gSJggzP
eoo9c3VJZYGCPXy73rnaDrzzEsncjzWfUJC3RQpiItEwc0w1hg6Ou/tbYr6dUiq7
Kwvpk4VNfCdCYDfEM9Qr
=gkGT
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
