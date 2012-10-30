Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38439 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2J3WOT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 18:14:19 -0400
Date: Tue, 30 Oct 2012 22:14:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: ching <lsching17@gmail.com>
Cc: cwillu <cwillu@cwillu.com>, Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
Message-ID: <20121030221412.GB11422@carfax.org.uk>
References: <508FB45B.9040101@gmail.com>
 <508FC26A.1010206@pepinghege.net>
 <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
 <50904949.8010603@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
In-Reply-To: <50904949.8010603@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 31, 2012 at 05:40:25AM +0800, ching wrote:
> On 10/30/2012 08:17 PM, cwillu wrote:
> >>> If there is a lot of small files, then the size of metadata will be
> >>> undesirable due to deduplication
> >>
> >> Yes, that is a fact, but if that really matters depends on the use-case
> >> (e.g., the small files to large files ratio, ...). But as btrfs is designed
> >> explicitly as a general purpose file system, you usually want the good
> >> performance instead of the better disk-usage (especially as disk space isn't
> >> expensive anymore).
> > As I understand it, in basically all cases the total storage used by
> > inlining will be _smaller_, as the allocation doesn't need to be
> > aligned to the sector size.
> >
> 
> if i have 10G small files in total, then it will consume 20G by default.

   If those small files are each 128 bytes in size, then you have
approximately 80 million of them, and they'd take up 80 million pages,
or 320 GiB of total disk space.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---             
                         was becoming typecast.                          

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJBRNL9z9OVl50rAAQLOyg//eejgXRPjNnj+GoDKg5PWJc5GgERuOCkJ
qcmlh9KD7gmDOYdLdqs4MN3g5gyrDZjSCDylCNlqape0VIlf0U0SfM7qMmsnGTsB
Al3AzER9p0AZCAIKdCIVzQUPNcMbmzKay8yxgiVzIXyAjumXy5MKT58j17bCPTkR
fr3KbkdB3IZ8f6T1dEYsQNOCWdiVjYJcJW9ApVgvo4YazT8jAAZg+PAd1bsCERho
Y6iKqgRjbHWHMROUinHj+mCh7t6LpxnXlKegnCWVX2KSXwdkeluhJjYqG6hvtaEo
+TWQg3IYuvvC9aW1oXWW/vpGyT72ykNZIv6Ak7vsG7gBNkXbUU0F7QTS5Y1gRoE/
mOudn3nw2k9cH35PPujL6VSzdV/GiEPbVoFqF5j2ygdzc8ONpd5eO+85nlTQlQej
aSVgNqIJtve/1twq1JI6SIhVDwY/6RUpfoKyPZvBhX2WY/inpP9YZTt0jt5JQ1JP
rTfQkK+HuR5Gz94ffmqINF0Dcm0nq2JxuNAsEWym+9KNj6zl+Jv8E81OE3mD54lB
G03bxBJHSat9WEA/UKUABwVKLCO5+7Va7IFHlRuY7tYCT78BUIUMLJhWSZbBZVWx
PvgC/Ye1Jk3QQkRR+qF/+CfihrBj/iryFRf9NJ5yVZIXL7nICcsEhqfIOSVQsyIr
d2CUa2+3R+I=
=jowS
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
