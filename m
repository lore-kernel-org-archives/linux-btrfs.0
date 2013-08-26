Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55455 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3HZTBt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 15:01:49 -0400
Date: Mon, 26 Aug 2013 20:01:46 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: failed to read log tree, open_ctree failed
Message-ID: <20130826190146.GN3115@carfax.org.uk>
References: <20130827022509.57de1ab2@virtall.com>
 <20130826183419.GM3115@carfax.org.uk>
 <20130827024748.0da8cb46@virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="muT+E17Lr9urPYYJ"
In-Reply-To: <20130827024748.0da8cb46@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--muT+E17Lr9urPYYJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 27, 2013 at 02:47:48AM +0800, Tomasz Chmielewski wrote:
> On Mon, 26 Aug 2013 19:34:19 +0100
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > > corrupt 0, gen 0 [   56.209412] parent transid verify failed on
> > > 3321036099584 wanted 97967 found 97966 [   56.225990] parent
> > > transid verify failed on 3321036099584 wanted 97967 found 97966
> > > [   56.226128] btrfs: failed to read log tree [   56.344483] btrfs:
> > > open_ctree failed
> > > 
> > > 
> > > I've tried with 3.11-rc7, but it gives the same result.
> > > 
> > > Any hints how to recover from that?
> > > I have backups, but it would be nice if the filesystem just mounted.
> > 
> >    Try mounting with both -orecovery and -oro,recovery.
> 
> Neither worked, same error.
> 
> Anything else I can try?

   Oh, hang on... that's the log tree.

   btrfs-zero-log may help. If you can take a btrfs-image of the
filesystem before running that, josef would like to see it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--muT+E17Lr9urPYYJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUhumGlheFHXiqx3kAQIgwQ/+IWRGnum/gaPdMKUk6DJy9HqvDqffa9Gf
weVrYiPGVBy3MPdx8aGzPGSWs+xTDcypYjxkqF7rCgFwPTXrKsBo1eA4u8ZrnMgh
A6E7YinSKNK9rYL+0KDSH8uZmh2Orqqbmwx8Sqx2sygaY3YDtjBuOpEQiIKGvBXQ
5hYqNg3kIl4Xv1xF7cer5/rSQVWKmOt7UqgvxTiAWBDF30KAVoHIrOBwdKDcttKf
p1VodmwuclT+OyCgUI1fPpn9GKdSWuJ0COm+KlwHZcQRZ2Zki+0wFTSv0fzDaAa8
N4n0S0ErXV4VzKalzHV5s95ALZehzYO84Be8iV6A4PKZyOYkbLpc5pcTUMMsMkE+
5gjhFC5meKbgU+h2McfJm9PsNw+QUAgrsYmY/fTkBaxeAKoXsfdl6pF5L11rsmqR
Psg1rznTMsRrtihULeECnVBvSVuYttQY2zl60TI8BgeFNQPd0HpTxl43c9yDpaGh
E45/0QG7dMmruuK1sfmhJ2FirCXpzHdQqk6lvreqEg+UqGty5LZGk7CaBm1MlTyo
6nBN9eOKNNjYRkMY/gNHCyE3OhZBsRImgFj1q3sj7asGlwnuiXzgZL1+3qSGQGpe
uQndGyOvcOQHpJgcpHwz1TfuYibjytUJdvozOjB3CkxT8GVG4rDVGin33WkXwPFY
3OX1/KSnjT8=
=1139
-----END PGP SIGNATURE-----

--muT+E17Lr9urPYYJ--
