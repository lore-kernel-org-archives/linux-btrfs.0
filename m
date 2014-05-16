Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53225 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaEPOnk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 10:43:40 -0400
Date: Fri, 16 May 2014 15:43:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs check: Attempt to fix misordered keys with
 bitflips in them
Message-ID: <20140516144336.GA2537@carfax.org.uk>
References: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
 <1399309671-9240-4-git-send-email-hugo@carfax.org.uk>
 <20140516142236.GW6917@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
In-Reply-To: <20140516142236.GW6917@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 16, 2014 at 04:22:36PM +0200, David Sterba wrote:
> On Mon, May 05, 2014 at 06:07:51PM +0100, Hugo Mills wrote:
> > If precisely one of those bitflips puts the broken key back into order
> > relative to its two neighbours, we probably have a fix for the bitflip,
> > and so we write it back to the FS.
> 
> This sounds safe enough to me.  I'll add the patch to integration but
> before I push it further upstream I'd really like to see the bitflip fix
> in action, so if you already have testing images, please let me know.

   Here's the one I mostly used to test with -- it's a 32 GiB sparse
full filesystem image, with a file full of zeroes in it. It has a
single bitflip in the csum tree created by hand with a hex editor, and
then the csum fixed up afterwards, again by hand.

   Hugo.

[1] http://carfax.org.uk/files/temp/testfs.img.tar.gz

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- I don't care about "it works on my machine". We are not ---     
                         shipping your machine.                          

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3YkGFheFHXiqx3kAQJo6Q/+KMb/DL8ULr2O1LJitM4E6FRUXGOLsOB5
ba4/3TFZqaE4J+T9dOk0IIUUILdUxx83TIZ9UGlqgtMgtZkt3yVgiUzqPy8XpOKV
PCtv4OyXGcpF1hWGFJe6XNIWOhqYJmIt2n2BW2VXBIGPZ/vDnr0PLKts9NplEUih
Kr5fFT4FNwX73rxuQ1petlvm8d2ye7eAz0uitFTQovaBmUwIflaLhNssi/2rOeDi
07BU8btzoGSMax/5KLfg1N+6YW9GcvTpHrOWqLIwoCOFF6gNNWWQkA5SpPBOInBJ
c8ThYSzMXL0fll2Exlrv0utCqDL7lR/HvviW2TLAwDJmOS+z8bokTuHwvc3U6pEs
cvJsGkGwcGCLRTmNm6U6tPFTmq22dOG3GSH/myx5AHZwcJzWsnUiMXYCLB/HQGAt
i+yp0qSmItEnlYEV5M8kcokQJQC1h9tf7YABreAdat57fi5j5YvCamKzhm86IAR2
mdFNOzc1q3UknXLe64Ge47nF710HPmEbYRIjpFQ4w0IT5cZDoVcE443kK9xtkFA9
CyrDViXmtX7B8SLllwbZouUfcKAA73S9x/mKfP0s4ujz/YgNcnUPl4spH2JtKxzh
fP7RHqktpe4+4A8K2IFmp7JAbFgbUrlIW9drPCv2E5Bx8BMAFARLNN28uSgV2L6y
3OMFjRljXKE=
=vlcy
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
