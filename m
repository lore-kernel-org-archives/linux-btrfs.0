Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54403 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3J0URx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 16:17:53 -0400
Date: Sun, 27 Oct 2013 20:17:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lester B <b.lester011+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Total fs size does not match with the actual size of the setup
Message-ID: <20131027201750.GG31029@carfax.org.uk>
References: <CAOeUAF_msDRoi2CDnAhwqC+=_oqNqH0=94+N9qjXpi4m4ChVLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FwyhczKCDPOVeYh6"
In-Reply-To: <CAOeUAF_msDRoi2CDnAhwqC+=_oqNqH0=94+N9qjXpi4m4ChVLg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FwyhczKCDPOVeYh6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2013 at 04:09:18AM +0800, Lester B wrote:
> The btrfs setup only have one device of size 7 GiB but
> when I run df, the total size shown is 15 GiB. Running
> btrfs --repair

   I'd recommend not running btrfs check --repair unless you really
know what you're doing, or you've checked with someone knowledgable
and they say you should try it. On a non-broken filesystem (as here),
it's probably OK, though.

> displays an error "cache and super
> generation don't match, space cache will be invalidated."

   This is harmless.

> How can I correct the total fs size as shown in df?

   You can't. It's an artefact of the fact that you've got a RAID-1
(or RAID-10, or --mixed and DUP) filesystem, and that the standard
kernel interface for df doesn't allow us to report the correct figures
-- see [1] (and the subsequent entry as well) for a more detailed
description.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--FwyhczKCDPOVeYh6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUm107lheFHXiqx3kAQIyRBAAnMmBm6iQCdEMJ7B20F+lb6IpXil46x1a
9Vh/2zY0iBVRJi/cCSvghXSHB088Tg9++d7lHialFVXebmox8BrEwnkOyOX5OqCK
jHQ9j49wKuLCV/z0lvLjLQJzJaNd25QJM3gl2fKeLUKHjuWJYWMlkEj4pVFTKSo0
46hbiADgI/BPITUAV284S7SwyX8kYidr1ytPIwsSQlfnan+Nez3+n81oZsHFb6aS
5gwaWQqhX9M3iKgmsqCU0nlpLxQtIwnZgEoTHMWdnkz6tcsi3B+FA5WBneBXzmmu
QVGPyz2PLSzHbqLMlGR7hRLnikKFbtJItcRwCP7Y+tvO84FkcBa0usxDIIL20Au7
OVRhn3C3mHuQNMfy4dJUspCE0yZIx7US1TLufzPZiakvq2XEfK7zedX/KAmk8me8
fc0vu1XRsgEvNAsc/c4QBX29y4oYiyA78LFB3QL20FPhD6IgktqQmPc24JqlfVQv
CpkIG5utVWkIcFPh+IJRWcRHAmveX3p7jY9j6v1C/aetNKW9KIW5HO5R5hDxeu7k
Cm5Y54g6i/YYgsvW/Tw5L1lduG5tUT0b0OtV2gHWFVKa7YoQuwXSwQGAXz6a2eMi
LNeNqvk9j3w+gfRuXx/0/k6nsa7e+ANUK7hzqP0VqXAWnFUymbaRhy1axAGPGi1Z
LSsrcpyswW8=
=cQgm
-----END PGP SIGNATURE-----

--FwyhczKCDPOVeYh6--
