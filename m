Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43327 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbcFNJQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 05:16:13 -0400
Date: Tue, 14 Jun 2016 09:16:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: doc: correct the destination of
 btrfs-receive
Message-ID: <20160614091608.GC5437@carfax.org.uk>
References: <491d91eb-0d51-b8ba-a046-61e2e392f06e@jp.fujitsu.com>
 <20160614085133.GE6205@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
In-Reply-To: <20160614085133.GE6205@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 14, 2016 at 10:51:33AM +0200, David Sterba wrote:
> On Tue, Jun 14, 2016 at 02:50:19PM +0900, Satoru Takeuchi wrote:
> > We can set not only btrfs mount point but also any path belong to
> > btrfs mount point as btrfs-receive's destination.
> > 
> > Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> The patches from you have a consistent whitespace damage, I've fixed
> the btrfs-crc but now that I see it again I suspect some error on your
> side.
> 
> > @@ -7,14 +7,14 @@ btrfs-receive - receive subvolumes from send stream
> > 
> >   SYNOPSIS
> >   --------
> > -*btrfs receive* [options] <mount>
> > +*btrfs receive* [options] <path>
> > 
> >   DESCRIPTION
> >   -----------
> > 
> >   Receive a stream of changes and replicate one or more subvolumes that were
> >   previously used with *btrfs send* The received subvolumes are stored to
> > -'mount'.
> > +'path'.
> > 
> >   *btrfs receive* will fail int the following cases:
> > 
> > @@ -37,7 +37,7 @@ by default, btrfs receive uses standard input to receive the stream,
> >   use this option to read from a file instead
> > 
> >   -C|--chroot::
> > -confine the process to 'mount' using `chroot`(1)
> > +confine the process to 'path' using `chroot`(1)
> > 
> >   -e::
> >   terminate after receiving an 'end cmd' marker in the stream.
> 
> ie. all the context lines start with two spaces instead of one. I'll
> apply this patch manually but please have a look.

   Looking at this, I suspect it's a consequence of sending it as
"Content-Type: format=flowed; delsp=yes". I'm not sure which of those
two options is the culprit. When I look at the message in my client
(mutt), it looks absolutely fine. When I pipe it to hexdump, the
double-spacing is apparent.

   Hugo.

-- 
Hugo Mills             | It's against my programming to impersonate a deity!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                              C3PO, Return of the Jedi

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXX8tYAAoJEFheFHXiqx3kwh8P/3p1p9qQ2CpqAjA3vT2cO4NY
Hdypopq52u2aQp1lu1qW50Bj4at/cLWBCqdwXpu1SV7+s1SvX4rewSFbbSdNPiNt
PrFu/0QNvOlmFP4F0ptHN/J6eqs+Uil1VYCTXZQ+CqG6kYkHSPVFFX1Qmq3ciAYQ
WKknNoImoYwxHsm4qWy9P4dFJeTc0NPlhMf7wsqfuD4Z2CyjZkIsN6qIR9nW48OV
g0LsaaPpaHG/dKfpuplc4/1f8fCPS4Z27rikWcSD/C7wwvzn3k5hP+URYCFlrcGF
BCzn77nq6W7+fLXWmSfkASHwyxMFACpfcaXGD8d9O3CjfnY65oa3C5DqHB0/Gex0
BmAfzeMaHyN1dND+P974rpuYv4AL+UxRhN9bDz8+Xrx4iOl27IzfiEnvbmg2qMaT
IrdzF94r5oqXuDN/ctlocsVI9yxsFOF7tWaLU6AlNW8uvln4Nn9swV0n0X/ODgtk
nt67LMdZk//9hPxh0wyDD6DaijDxEfwPr7exc/o8J1Uh9gxH61uH1wAjkUumSbey
WLNuvvmeCHuNhX4nPWRLwsDudBe5xUBal5N9yVGDhdT9rsGYBbx39fa7emyYCuNo
TgAfhzpDyHydPRFAoK0pYmUEmqtG0Br+uQcDGqr7clydptMEidrdKUfmX1YTlFBN
6TUXwZVwwaekdw+pafaz
=TIrN
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
