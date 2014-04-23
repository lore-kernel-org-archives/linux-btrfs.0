Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59963 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaDWWx6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:53:58 -0400
Date: Wed, 23 Apr 2014 23:53:48 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
Message-ID: <20140423225348.GD2391@carfax.org.uk>
References: <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
 <20140423191546.GG26949@merlins.org>
 <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info>
 <20140423205819.GH26949@merlins.org>
 <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info>
 <20140423220312.GK26949@merlins.org>
 <000a01cf5f42$2b180b30$81482190$@petrovi.no-ip.info>
 <ECBC57F1-E3A0-4423-9248-6D7C72DDF09A@colorremedies.com>
 <20140423224303.GB2391@carfax.org.uk>
 <20140423225018.GL26949@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
In-Reply-To: <20140423225018.GL26949@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 03:50:18PM -0700, Marc MERLIN wrote:
> On Wed, Apr 23, 2014 at 11:43:03PM +0100, Hugo Mills wrote:
> > On Wed, Apr 23, 2014 at 04:40:33PM -0600, Chris Murphy wrote:
> > > The screen shot provided makes it clear that one of the following kernel parameters is incorrect:
> > > 
> > > > root=/dev/mapper/cryptroot
> > > 
> > > > rootflags=subvol=root
> > > 
> > > So either the dmcrypt volume hasn't been opened, thus isn't available; or rootfs isn't on a subvolume named root found at the top level of the file system. So I'd say this isn't a btrfs problem, rather it's due to some earlier misconfiguration that's preventing rootfs from being mounted.
> > 
> >    You'll need an initrd to run cryptsetup (or whatever) to collect a
> > passphrase and decrypt the volume before you try to mount it. This
> > sounds like a case for an initrd again.
> 
> I think you are confused, that's my config I pasted as an example.
> He does not use dmcrypt in his example.

   Ah, OK. Never mind, then.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---     
                     astronomy is about telescopes.                      

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1hEfFheFHXiqx3kAQKSRg//TfYZJVpSRDVXlpvR8jUB+g0WXpOVJGS+
tCEwvDKdGk4MuDc/Z+XyP0Yo9AaJqTsHuMe2irRFs2nnITIAnUCY9N33JP5LjdEX
WB2RHRadHlqKMF/tSYXucUUSfCldWdfrVCloCQIHAf+KqNyofwYzjHO4mctvS7DQ
IV/kKjo/gG7xc6hw6zKLcHIfEM1A+JY9piOKp6fcLinzQbqwkpX77Y671MZn45rP
nYiQoP15ahkLSBeLCTGZJ/MsYXIbSTwrTTUr0IW8zdG2sUsJjN2mWy3OdbH+4CZy
VAZ55EP1dlB52XMuKxs3OKkVRKv40kBCN3P02XkuwXDXbY2QNFQ3TtcliCPB0yiK
fJhC/TwVvqVGXh5Hxqa4o8OssEBmUdOLfqXXKUHRSZv6wVFPBqpVSNQVHGTRgsx9
3/BILj7or7EHiYRbiyAsL6BGklvNYF4lpt5LipjKubdSOBdvIls0K+LnnjZn3thb
Xoj/avuNAtjY07z3XPGrtEjfi09YXXi9j9MO9vKK8O7M5MwghflA6FNk5YP8Rfey
cT4SD5Wk21mzgRXPBcxt3BhR+D9eTxFnOtH+ZlyQXfsvzRwLa3J8vbfhjEnJdnIW
5NAqwXyN/tdTL26QpolQ0iwjr4TTchCANCQWuhD4bfdfCEJ/0UVaCH6fQVjfLvEJ
JtjrsXy4hgA=
=2tjV
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--
