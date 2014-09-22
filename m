Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52864 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaIVIta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 04:49:30 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fs corruption report
Date: Mon, 22 Sep 2014 10:49:19 +0200
Message-ID: <3613939.scyF6llZAT@fb07-iapwap2>
In-Reply-To: <1411374836.8147.3.camel@localhost.localdomain>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <14406058.nMoj3Kabx5@fb07-iapwap2> <1411374836.8147.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4499110.OAtAsiuY0J"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart4499110.OAtAsiuY0J
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Am Montag, 22. September 2014, 16:33:56 schrieb Gui Hecheng:
> On Mon, 2014-09-22 at 10:19 +0200, Marc Dietrich wrote:
> > Hi,
> > 
> > Am Freitag, 19. September 2014, 09:30:30 schrieb Gui Hecheng:
> > > On Thu, 2014-09-18 at 12:47 +0000, Zooko Wilcox-OHearn wrote:
> > > > Thank you! I will try to restore using this patch.
> > > > 
> > > > What branch of what btrfs tools git repo should I apply the patch to?
> > > > 
> > > > Regards,
> > > > 
> > > > Zooko
> > > 
> > > At least I think the following repo/v3.17.x branch has all
> > > restore-related patches included.
> > > 
> > > git://github.com/kdave/btrfs-progs.git
> > > 
> > > This is a mirror of the latest devel repo that I am on.
> > 
> > restore of my corrupted partition finished. No "bad compress" nor valgrind
> > errors anymore. I'll close the bug.
> > 
> > Many thanks!
> > 
> > Marc
> 
> Hi Marc,
> I'm very glad to hear the result.
> I've sent a v2 patch which adopts your idea. I also add your
> sign-off-by, please help me to check whether it matches your thoughts,
> or more could be done to improve.

well, I didn't wrote any code. So it's enough to just add my reviewed-by.

Thanks!

Marc

--nextPart4499110.OAtAsiuY0J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUH+KPAAoJEKyeR39HFBtoAmEIAJpnXWVmcrMSGp8SN7Y5D64A
OmC4tMU+/MUzT11/qvmSqyZpUNTmuXGXSdUnq3CKXEqV4P7mGj7TeB6EK8oSMKD5
wNPVFb46Qga18WRHKSMdmyBAl0sBettWOTcmYlkB4VfAaqxIvllacUwF5P+mzJYm
KXt6SYH2UrVkXPCB9/TPby26C8f8ymXJC964nFC27Onpygqvp0z7kWoiKsTIWM87
WXQNgadiJMUSmUcZlG0DWg0w39BdOC4ezXzckl1BRGus/OMpgr2AmbBHF+MNV2+N
al43lw024xDaG2egamAeyrlFzA4+FLg8qPKVk/R2Di9R2+rgjQHQymaVbwemnZM=
=ibPl
-----END PGP SIGNATURE-----

--nextPart4499110.OAtAsiuY0J--

