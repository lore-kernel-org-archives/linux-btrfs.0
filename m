Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45936 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaGaTMp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 15:12:45 -0400
Date: Thu, 31 Jul 2014 20:12:40 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Subject: Re: Implement new FALLOC_FL_* modes
Message-ID: <20140731191240.GQ31950@carfax.org.uk>
References: <CAPDOMVi7fS9zwpZcENiSxhWWn02VfV5H9qnHrK-4kfjLW1zaXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aNvCJ41Feu8IgPyB"
In-Reply-To: <CAPDOMVi7fS9zwpZcENiSxhWWn02VfV5H9qnHrK-4kfjLW1zaXg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aNvCJ41Feu8IgPyB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 31, 2014 at 02:08:15PM -0400, Nick Krause wrote:
> I am doing this project from the btrfs wiki, since I am new after
> reading the code using lxr I am wondering if
> we can base the code off that already in ext4 for these modes as they
> seem to work rather well. I am wondering
> through as a newbie some of the data structures are ext4 based and the
> same goes for some of the functions.
> I am wondering what the equivalent structures and functions are in
> btrfs as I can't seem to find them after reading
> the code as a newbie for the last few hours in lxr. Maybe I just
> missing something?

   The fundamental on-disk structures for btrfs and ext4 are totally
different. You will get very confused if you expect the ext4 code to
work in the btrfs module, or even if you expect structures to be
similar.

   But first -- answer my questions in the reply I made to your patch
just now. Do nothing else until you can answer all three of those
questions sensibly.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Great films about cricket:  200/1: A Pace Odyssey ---        

--aNvCJ41Feu8IgPyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9qVKFheFHXiqx3kAQIKZg/8C/hraoZV6GxCiNAxkxmSXSnVuIACAgpV
uE+msf1L+B2itMvvLh745UYqvrDewrCBtZIYGOhO4G668g5FlShl3UbtnAalhle5
1oJhUmWTp1OmwHoevVPDIi+8iqxi85kbkaI1WtgwO1gotupk+LE4F26qPMBDeYKo
LvaEz2Gsn20HSuCvCB5TlvrIQgslQjRcm4qiETzBGo3yybvzVPDBUoLcGHdmYXLj
NHmWatj/gVVoMNAy4KpYPhX8bwXEoR6x+n9rZ4slZRCAE4//2EGLLJze2vGTZorv
PPeJTQIbpQZo6ZV6lTXfbqDIzwhs1TtiE4DWDYdOdpgk6D2Z7q2qe9hswcPeLAzI
LZ2kKTxD/F7hukCQrFFkKPsuEnHJxDbAMDT6vPP1rGEn/VeR9qEwxVg0+3zfm6rD
53saJ4BpoqzjL1XrBYRDlHYTzJYf2+1r3SAaT4mMOUbmgEYvGt63+WN+TMBZnnoP
Gp4oTiYRto4M81/vvJ+ueXVHCeJt0MBg3dy7Q8YrP+AMdtM57gvJXY3Csem/NcsL
T+Lhgux4qivrXKzwPH0zYdWH5P7ZAtscSZxkRw+mzg9NFF4Ofgz2BtAJGUuG62qi
CiSxAlMeJAchOOJ2CyIgDKqKRTYQmkfBchgE3Kxs148CHm4HUsPga2S/L4dQMWRC
6o0bR1+eQso=
=CrpC
-----END PGP SIGNATURE-----

--aNvCJ41Feu8IgPyB--
