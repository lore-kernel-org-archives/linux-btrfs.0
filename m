Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53137 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3KLUHd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 15:07:33 -0500
Date: Tue, 12 Nov 2013 20:07:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: kreijack@inwind.it,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add support for inode properties
Message-ID: <20131112200727.GG4315@carfax.org.uk>
References: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
 <52828071.8090305@libero.it>
 <CAL3q7H7mF2sPT7+xR6ArbkdTnN1bWd4v6=woD9rDAZCtxf5aig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHGcFxmlz1yfXmOs"
In-Reply-To: <CAL3q7H7mF2sPT7+xR6ArbkdTnN1bWd4v6=woD9rDAZCtxf5aig@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lHGcFxmlz1yfXmOs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2013 at 08:04:47PM +0000, Filipe David Manana wrote:
> On Tue, Nov 12, 2013 at 7:24 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> > Hi Filipe,
> 
> Hi
> 
> >
> > On 2013-11-12 14:42, Filipe David Borba Manana wrote:
> >> This change adds infrastructure to allow for generic properties for
> >> inodes via a new ioctl.
> >
> > I am sure that there is a valid reason, but I was not able to find it:
> > why implement a new ioctl instead of using the *{set,get)xattr(2) syscall ?
> 
> Those require one of the following name prefixes: "user.",
> "security.", "trusted." or "system.". Only "user." can be set from
> user space and requires no special privileges/capabilities (if you
> have the necessary permissions on the target inode).

   Why only that limited set? Is that limited by POSIX, or executive
fiat? Is there any likelihood of us getting an additional namespace?
(fs.* maybe?)

   Hugo.

> It could be implemented via the "user." prefix, like
> "user.btrfs.something" for example - but it can break user
> applications if they use such prefix already, and we want to validate
> the values set for such properties too.
> 
> >
> > I noticed that you implemented the Compression properties set/get: is
> > this from "chattr -c" ?
> 
> With chattr -c you can't specify the compression algorithm - it will
> use the default (zlib) or the one you specified via mount options.
> 
> thanks
> 
> >
> > [... cut other lines ... ]
> >
> > G.Baroncelli
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I write in C because using pointer arithmetic lets people ---    
               know that you're virile. -- Matthew Garrett               

--lHGcFxmlz1yfXmOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUoKKf1heFHXiqx3kAQJiPhAAjZBX29QAKibwrhP2UDB9BpgWOk0zMRJF
X4s3vjiyd1Hlz5qivmkdycjwVwjL6fZv2VGGXbkk7TRXwOlTuaP42ooWRFYSTEYn
tpynOIlFdZEdqt0TDdP5t/AkuRlePsRpzB5G/jRehhnS0HXJvJjkMXd3Aj85h/rc
pp7mKTlqo8dhaTntnbe3oqO5LDWbRRElqsJB62f6u6yhO/p8954KvjRf0XCO5QOn
Fv5mfi47rs9ZZaE9aiwixZF1d5QL6XrIquG6xc31zRKQtx/W1iiwQMWPIV/Xa6iw
nH2HAhMXMUvbjkBOJAPUY1LByDiUNxFAk/ZBZysX1j5E/yXtNkIURmE4D/Ghs2iB
znE0X4L3m6uS39UV9mQFOhWafARnxrjpAxe52C4qS1py8FjF5WCFI9KQt4HkfUsH
/o+bWqtwDtGyz7sfF0HWvpXBe6e38Tx3PRDbWup11hsfCyqVUM2/aNHYlfmUduIp
/F8tNdVhMxViFNRQrK5EVBDE1FwWoHixXVKMPfs7TQmKAt8SZ2T6W+kxXcLwgx1I
Qo0icfddvSNB/9lT4DNdgXoR1daSCm/FyRErktQxHS8QEawvtTMT0K8IGk9QjjaW
o/8MYfUH4oJnF5GqjOmdhvjvrz5M7KFCxJFV94nI/9kyCGbRY+8Em7dlTc2t8kuA
4VWSzNAXeMk=
=r0Kp
-----END PGP SIGNATURE-----

--lHGcFxmlz1yfXmOs--
