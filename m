Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57894 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3CJRUL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 13:20:11 -0400
Date: Sun, 10 Mar 2013 17:20:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] Add man page description for nCmSpP replication
 levels
Message-ID: <20130310172009.GC30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <1362861071-12589-6-git-send-email-hugo@carfax.org.uk>
 <513C9228.6020703@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
In-Reply-To: <513C9228.6020703@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 10, 2013 at 03:01:12PM +0100, Goffredo Baroncelli wrote:
> Hi Hugo,
> 
> could you please add also to the btrfs man page a section where are
> described the nCmSpP levels ?
> 
> Thanks.
> GB
> 
> 
> 
> On 03/09/2013 09:31 PM, Hugo Mills wrote:
> > Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> > ---
[snip]
> > diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
> > index 41163e0..2e71e65 100644
> > --- a/man/mkfs.btrfs.8.in
> > +++ b/man/mkfs.btrfs.8.in
> > @@ -37,7 +37,29 @@ mkfs.btrfs uses all the available storage for the filesystem.
> >  .TP
> >  \fB\-d\fR, \fB\-\-data \fItype\fR
> >  Specify how the data must be spanned across the devices specified. Valid
> > -values are raid0, raid1, raid10 or single.

   Like here?

> > +values are of the form <n>C[D][<m>S[<p>P]], where <n> is the number of copies
> > +of data, <m> is the number of stripes per copy, and <p> is the number of parity
> > +stripes. The <m> parameter must (currently) be a literal "m", indicating that
> > +as many stripes as possible will be used. The letter D may be added to the
> > +number of copies, to indicate non-redundant copies (e.g. on the same device).
> > +
> > +The following deprecated values may also be used:
> > +.RS 16
> > +.P
> > +single	1C
> > +.P
> > +raid0	1CmS
> > +.P
> > +raid1	2C
> > +.P
> > +dup		2CD
> > +.P
> > +raid10	2CmS
> > +.P
> > +raid5	1CmS1P
> > +.P
> > +raid6	1CmS2P
> > +.RS -16
> >  .TP
> >  \fB\-f\fR
> >  Force overwrite when an existing filesystem is detected on the device.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- I can resist everything except temptation ---            

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUTzAyL9z9OVl50rAAQI8rhAAk7qCtufyzvvynFqJli5NwDHAc05UdyXu
rDofy/hpCtqCk192ZYz5aESu/9xHkw1H7UOXWebxOXRBjqShICRrdVD8+u7p5ESl
goswruA9+XdvGMyWXmUOhumuCa8UKckVI3q9P8G2RSEQ3VbXWj32LynhGV2QgI7I
QG0PIyqJtlb+IwB3MaX5gD4jJT+fC2ixPHK+L8aJB+EcRjl9SFWUPuG4XikG8fvT
c6fuCTTCRzKLPCobsjTuFDr6jYtLFpztzTMF21/u44b+RtJmlT9dNai9IU559irX
CS7eUV6Gmt9rI9tJ5buYvQw8t4VMmAszohKgi8cb8PoKJMXN0rPG412lPSxiYXA0
xwrBNorLerU6QY50zh9p0hb9fNqS5/mtW44KlzkmTfSwIuOySvg6ukxIDU8Ac/S/
elv5aKDu7MWiYeKi63Iex+1uMWtDni6GfmCO310LWXnlDP6wm/H7rH4sCRN0ocBW
+9hzQiLBRpii9fS2QSUiebOhKhkg+3Xll4zG5DCYkNk7Wp4OOB0+rnmk++nkLqrv
5eHQwAEV88HGImfGMA7wc1hhPLaqe06AGp5tIYuaA+DMgtC8VTH4EWg2/P1IMwQ8
+okUx4UXL4dlzztUKbe4oFrXNH9j+l7QQQzwxxgI6QUzce+NZC9E1SH15nRtlKaP
enWxt0VLekE=
=hneP
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--
