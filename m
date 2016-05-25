Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36492 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbcEYLUS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 07:20:18 -0400
Date: Wed, 25 May 2016 11:20:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random generator
Message-ID: <20160525112013.GK16712@carfax.org.uk>
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160523120112.GK29147@twin.jikos.cz>
 <f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
 <20160524095155.GN29147@twin.jikos.cz>
 <913572bb-72f3-1428-f50c-4dc338d5c528@cn.fujitsu.com>
 <20160525111138.GP29147@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dxRQSzdsN/lOP445"
In-Reply-To: <20160525111138.GP29147@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dxRQSzdsN/lOP445
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 25, 2016 at 01:11:38PM +0200, David Sterba wrote:
> On Wed, May 25, 2016 at 08:33:45AM +0800, Qu Wenruo wrote:
> > 
> > 
> > David Sterba wrote on 2016/05/24 11:51 +0200:
> > > On Tue, May 24, 2016 at 08:31:01AM +0800, Qu Wenruo wrote:
> > >>> This could be made static (with thread local storage) so the state does
> > >>> not get regenerated all the time. Possibly it could be initialize from
> > >>> some true random source, not time or pid.
> > >>
> > >> I also considered true random source like /dev/random, but since it's
> > >> possible to wait for entropy pool, it would be quite slow and confusing
> > >> for users.
> > >
> > > How would it be confusing? We'll once seed the random generator from
> > > /dev/random, reading 3 * 16bit for the nrand generator context.
> > 
> > Reading from /dev/random may sleep, until the entropy pool is filled.
> 
> I know, but does this apply in our case? We're going to get just a few
> bytes to seed.  I want to avoid inventing own random number generation
> schemes, so we'll use a standard random number source or API.
> 
> /dev/random gives about 1-2MB/s of random data on several machines I've
> tried.

   Just use /dev/urandom?

   See, e.g. http://www.2uo.de/myths-about-urandom/

   Hugo.

-- 
Hugo Mills             | Putting U back in Honor, Valor, and Trth.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--dxRQSzdsN/lOP445
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXRYptAAoJEFheFHXiqx3k9XEP/1F7dGaQI/65FuMIMAxm2NUC
51De4ez3E9hhNnSzGGT45vzR7l1TF1XcjGY2PGf+lHjFhkDlZwEF2EKMTjytWBpa
FijvJxwUjkpaNnT6+isQ2KXbI2QkrC+xQflGGMDRjDEiEV+Xe4mKS3//KGoCDwQj
vieUl/haqGcMrIWl+JwByUBblBu92zfkQBP9cw0t6QkekWGmXFnXma+kN6155WID
qNNELY0ktwbDEWofjFcY9onoRN7X5H1s+eyFTyhbEnWWpj0BOEmqRPn5odUd9V+C
BU4QEr+USnK1s5427buaZy/YlIxXA2B26iAV35HzkqTmRpefT1FMI/shNDUMqB30
G55wVA7/yBlYe99eU0Ia591w9nyapleG4Z9rT/TTDwyA+GK3igmU/7MldO9k0XjN
Ub8Uiz8lHTacNJxdyMq9BRUlhAoMP/l/1X0g8drWV50lF8Z9UWNSldZ850Zf3j7V
4VywsbypvDTnIW/3Y4jAearFKpdAv2I5jFlExKwDZGmLY6iOERWjNrHQrYOpegQT
ET1QxLlhji6seWSmpE6OMJ/xsCvG20rRANhD/djHwCudHIDJUvIiJm3jspeDllmL
r5E5NnX6UgL2T14ovZgE37CXmkLVC1/UYcSc7LmhH2bjdqVlFTR7RN8L3lAPUOHF
dwQR/04+YXBmJuvPvn1R
=c4dc
-----END PGP SIGNATURE-----

--dxRQSzdsN/lOP445--
