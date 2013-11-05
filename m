Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46419 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3KEOey (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 09:34:54 -0500
Date: Tue, 5 Nov 2013 14:34:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: russell@coker.com.au, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: csum failure messages
Message-ID: <20131105143438.GM14405@carfax.org.uk>
References: <201311051224.44255.russell@coker.com.au>
 <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
 <201311052316.34979.russell@coker.com.au>
 <49B5E6AD-795D-4839-A360-7F3782ED7F2F@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uus2/pBTyv0r7Av1"
In-Reply-To: <49B5E6AD-795D-4839-A360-7F3782ED7F2F@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Uus2/pBTyv0r7Av1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 05, 2013 at 07:26:54AM -0700, Chris Murphy wrote:
> 
> On Nov 5, 2013, at 5:16 AM, Russell Coker <russell@coker.com.au> wrote:
> > 
> > I presume that my filesystem is still corrupt.
> 
> I'm the original reporter of the bug. The file system itself isn't corrupt, but the affected files probably are. In my case, systemd journal files were reported as corrupt by systemd following a balance, as well as btrfs scrub. Upon scrub, dmesg contains a path for each affected file. Upon deleting those files, subsequent scrubs come up clean.
> 
> Fedora merged the fix for this bug with: 3.11.5-302.fc20, 3.11.6-200.fc19, 3.11.6-101.fc18. I thought for sure it was marked for stable to go into mainline 3.11.6, so somehow it's been missed.

   Someone else tripped over it on IRC last night, and I was surprised
to discover it hadn't made it upstream yet. :(

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Two things came out of Berkeley in the 1960s: LSD and Unix. ---   
                       This is not a coincidence.                        

--Uus2/pBTyv0r7Av1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUnkB/lheFHXiqx3kAQI5/xAApNJfeU8KdlMrMdsi5Xbh1hnpcNM+uxCh
ApQsUIL0B6nRjkIOhCxpQwqZ7fbpmnpK/FpChA8NiRr+NxBSs05m6f4U5y4vpw3/
SvfFkzQ/20pznBOXN/tyJC0GZY5CYm+Z7qf9aIa8+nINCA6ZGbYW5IhQ4NqUZS1A
lL/u2QhK6PZl4dXYh/jZ3Aj1O5n9zFYIqgeEXoedPbtyABvlKsYfyR7PinDgpVrH
BeDk4c5rZWLdJZPTo3EHGun3VGB80afep0bMid/kHhQLPypvm8gZxA0uM+cB8234
df4gOJOxCkbXigHL+MBQ9xsLJlDtMFyU2JEL02Mrf+IKmNO+zwkCBzp9eDk0aIxL
/nMiqIhJKnmOT4ua469jQghEgRVf8KOryPYXdnO4RiLDoEzuN/ayAaFtXCH5HpwD
9DUDVgLlgJRmSe06DaEgFSaGL02WRE0pifckpdEEIGZJ0/ceWWf+AAzRFzEM/HtM
ooxtT2F7rNfVGyiZEETK/mLpy5yQSzfTfSV3u/8e/Rhu5JZ16u/oNyo9HBw2qeUK
EXqJXQpdblstmV0bhpdfvGsKITPJV4dxucAby3MSgSiewk+gtppbJf77G3WO3XTq
7QEnZbouYRJuagMAI5rBNbHeDYjltTGpibG2Z5L3KMR6A95JCPT6BZW1vVa68NJb
lZy2MkUKByY=
=h2VU
-----END PGP SIGNATURE-----

--Uus2/pBTyv0r7Av1--
