Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51936 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756046AbdEKThm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 15:37:42 -0400
Date: Thu, 11 May 2017 19:37:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>, Marat Khalili <mkh@rqc.ru>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Backing up BTRFS metadata
Message-ID: <20170511193728.GK9701@carfax.org.uk>
References: <2b29db76-9199-0759-3477-58f0a67a3570@rqc.ru>
 <CAJCQCtTbE6M23e8EmB23pp89Y8673BeY+p_tkox3orY-AS2DJQ@mail.gmail.com>
 <20170512002200.73d5207f@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Z9t8O/5YJLB6LEUl"
In-Reply-To: <20170512002200.73d5207f@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Z9t8O/5YJLB6LEUl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 12, 2017 at 12:22:00AM +0500, Roman Mamedov wrote:
> On Thu, 11 May 2017 09:19:28 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
> > On Thu, May 11, 2017 at 8:56 AM, Marat Khalili <mkh@rqc.ru> wrote:
> > > Sorry if question sounds unorthodox, Is there some simple way to read (and
> > > backup) all BTRFS metadata from volume?
> > 
> > btrfs-image
> 
> Hm, I thought that's for debugging only, and that you can't actually restore
> metadata onto a data-containing FS and have anything mountable/readable as a
> result.

   Indeed. This has been tried before, and I don't think it came to
anything.

> Seems not to be the case, and in fact, could this be one of the "missing
> links" in the Fsck story, 
> 
>        -w
>            Walk all the trees manually and copy any blocks that are
>            referenced. Use this option if your extent tree is corrupted to
>            make sure that all of the metadata is captured.
> 
> This certainly does sound like something to try for some of those broken
> filesystems where Btrfsck refuses to do anything. Save image with this manual
> walking/reconstruction of the trees, then restore. Too bad I already nuked
> mine, so can't experiment with that.

   I suspect it's still only capturing metadata, rather than data.

   Hugo.

-- 
Hugo Mills             | Would you like an ocelot with that non-sequitur?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Z9t8O/5YJLB6LEUl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZFL14AAoJEFheFHXiqx3ksI0QAKZV+dwPXA/dUHgxbOq9KOqG
TI2jQM2ZZPV0O4Vnnof2I9L1QXZpalbMobBsWqD9+xWvaeZ91CfvHGU0otb+uOyG
I7wyI4ACMiJRIebDcQND+xDW5yoVxGoZYUdYq/kp9ZNGWtddCKxg0GAQ428l+JDq
VVheTaI1zN6LWjKZl6OmZ8rmTUuJBi/jdhqELb+G60R8VNntXyYDruoyPm2tu6sA
wclMNHo9spvzftXQrY/Zzg0OVXt6Ij+9PXpr65gLI9Lxxm3H5gbATZrfdLHqg8wG
iOM4NunFYqB8agKPdBgEiFcZOGHx3v8kE5T69Knf8rJM9fdr2YWSLl86t28WkAQH
BkDCl36eHe35NO/k3PiYyCUhs9DcQFNlEO5Xdzcn7tCkg1ocHlKLAxO7qDnaRtbY
cu4GFkR2GjxKAcCrTEcW38k4WX9MZnlKJqgsZpoFMJuWTmpCi26wv55hM5QMmQfF
8uFSrulCaz6LgvaPx/tw02dRPUebwr6/rACKDwbGRVdgrUof7EKPW9S1jTfVI8T+
LR+2cejDKE62up1xmIQreYrM8g+woeimTsViD+/rOYznopJfjwK3KOutHB52F0Jn
wideHj6AVHmZWE0o9DT33YcXgq5SKW/2NrnKNtAjf/DB5K7YcjbmuqoWoEfCF6mM
8phmhk1n2fePSvXb7d8L
=QTAa
-----END PGP SIGNATURE-----

--Z9t8O/5YJLB6LEUl--
