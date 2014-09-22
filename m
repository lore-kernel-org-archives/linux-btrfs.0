Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63370 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaIVITT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 04:19:19 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fs corruption report
Date: Mon, 22 Sep 2014 10:19:14 +0200
Message-ID: <14406058.nMoj3Kabx5@fb07-iapwap2>
In-Reply-To: <1411090230.28980.6.camel@localhost.localdomain>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <CAM_a8JzKth0_zG6cGoQeWHB3Dpro42wfEtS5QJXtFZT1xNoZYQ@mail.gmail.com> <1411090230.28980.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2392394.REiNlrzhpx"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2392394.REiNlrzhpx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Hi,

Am Freitag, 19. September 2014, 09:30:30 schrieb Gui Hecheng:
> On Thu, 2014-09-18 at 12:47 +0000, Zooko Wilcox-OHearn wrote:
> > Thank you! I will try to restore using this patch.
> > 
> > What branch of what btrfs tools git repo should I apply the patch to?
> > 
> > Regards,
> > 
> > Zooko
> 
> At least I think the following repo/v3.17.x branch has all
> restore-related patches included.
> 
> git://github.com/kdave/btrfs-progs.git
> 
> This is a mirror of the latest devel repo that I am on.

restore of my corrupted partition finished. No "bad compress" nor valgrind
errors anymore. I'll close the bug.

Many thanks!

Marc

--nextPart2392394.REiNlrzhpx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUH9uDAAoJEKyeR39HFBtoIfMH/RBDknaj4JpHv5wQmcIEAvF0
/hNYMPXlG2W6gId0JwYIoZhorofBV35QpaLddEqRij2NWXYgTnn7iXYqqKoDHukJ
fwgAoz1zZUMOXJn7TMs1JFGYn+EfwJY7FtIUMOfHcxnSBWqzxFvWGVYLoxJEMudV
YxZxTZT4HFWyamWEifNZddo1CTbi8WkFnaxkCHt29fJ+SlwkEeoECm2lrjIH0FA3
ui5EqeJO8ZrC6rWAAejoFuagIM58WXmEmVYitVq2y+yxiwjCqepBC89UimvaAidV
NW8Oh/VcVeOsMjZ+SdATxI+1dadyrpKNiM/cobafd9z2tKKMdH4Q46fFOIxpCcQ=
=WdE3
-----END PGP SIGNATURE-----

--nextPart2392394.REiNlrzhpx--

