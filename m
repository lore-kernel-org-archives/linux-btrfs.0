Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34608 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933791AbeFVPkk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 11:40:40 -0400
Date: Fri, 22 Jun 2018 15:40:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add more details while checking tree block
Message-ID: <20180622154030.GG28972@carfax.org.uk>
References: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
 <7b34f539-ef57-ecb3-37c8-7b3759874249@suse.com>
 <06086fd3-f28b-5cc7-f3c6-3fca659b2fa0@mendix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
In-Reply-To: <06086fd3-f28b-5cc7-f3c6-3fca659b2fa0@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 22, 2018 at 05:26:02PM +0200, Hans van Kranenburg wrote:
> On 06/22/2018 01:48 PM, Nikolay Borisov wrote:
> > 
> > 
> > On 22.06.2018 04:52, Su Yue wrote:
> >> For easier debug, print eb->start if level is invalid.
> >> Also make print clear if bytenr found is not expected.
> >>
> >> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> >> ---
> >>  fs/btrfs/disk-io.c | 8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index c3504b4d281b..a90dab84f41b 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -615,8 +615,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
> >>  
> >>  	found_start = btrfs_header_bytenr(eb);
> >>  	if (found_start != eb->start) {
> >> -		btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
> >> -			     found_start, eb->start);
> >> +		btrfs_err_rl(fs_info, "bad tree block start want %llu have %llu",
> > 
> > nit: I'd rather have the want/have in brackets (want %llu have% llu)
> 
> From a user support point of view, this text should really be improved.
> There are a few places where 'want' and 'have' are reported in error
> strings, and it's totally unclear what they mean.
> 
> Intuitively I'd say when checking a csum, the "want" would be what's on
> disk now, since you want that to be correct, and the "have" would be
> what you have calculated, but it's actually the other way round, or
> wasn't it? Or was it?
> 
> Every time someone pastes such a message when we help on IRC for
> example, there's confusion, and I have to look up the source again,
> because I always forget.
> 
> What about (%llu stored on disk, %llu calculated now) or something similar?

   Yes, definitely this. I experience the same confusion as Hans, and
I think a lot of other people do, too. I usually read "want" and
"have" the wrong way round, so more clarity would be really helpful.

   Hugo.

> >> +			     eb->start, found_start);
> >>  		ret = -EIO;
> >>  		goto err;
> >>  	}
> >> @@ -628,8 +628,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
> >>  	}
> >>  	found_level = btrfs_header_level(eb);
> >>  	if (found_level >= BTRFS_MAX_LEVEL) {
> >> -		btrfs_err(fs_info, "bad tree block level %d",
> >> -			  (int)btrfs_header_level(eb));
> >> +		btrfs_err(fs_info, "bad tree block level %d on %llu",
> >> +			  (int)btrfs_header_level(eb), eb->start);
> >>  		ret = -EIO;
> >>  		goto err;
> >>  	}
> >>
> 

-- 
Hugo Mills             | "There's a Martian war machine outside -- they want
hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                           Stephen Franklin, Babylon 5

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbLRhuAAoJEFheFHXiqx3kvW4QAJIS/sBQL1pBXvghGEnVcfN7
DqOgAArlWu1hvq0W0xfQdUJ4UTOwm5QV+7vqCE2vCro1xrqzoSFtVG6QV/eIsxQz
tvCo4hehd8fKCAeuyesx2g15QMUO/cVyWcGZCVOyY4R7nbkQrWrV6KkS5T/5rtD+
S3MB3eDPpJHhku+cSGt1sbdP+Z2GF9O9/runZx97OfKxU/Nf7NX8LHXvmFK2Rqac
Pe3t8x1LuNxoMulDV+YgF0C/0BDPCWPV1laDEQXo4q3qEQv6ZZNOB2tU9c6iV++r
ld7ZSXrBpt/Ceb1yoPuf/lNpzzzZMj7z24b86UCaS7ltfo8IjHSxOqPY/nusKcMI
f5Kt1rbOTJ1LVqZHlzvZiEXUsg7olgEHuzxwwo/7N5Sj10lArWLlziWx3HZPrzLO
3Pi06WT0VhXnMYVqYP3+gs7e7eUzhf5pRXEhpHu8brcGULLHpzQ0gSrxS9FAD5XU
hppnYRfzoyUxJCny7p7hoDXSgMbPnrmtfSHxJ+sqWMxh3VlZpfuR8X8X7M8oRhJo
XcxCYkTJ+XckaoFmgAdnyrqrIgEKqTeYsDpdMGDishxKrmjtsPCOO/XUeIhX1bso
ZIj89gRsdW1yNZ/WbVJMfdPoYV/LjBHVF703hYZ/6X/g4mb9k7A6xF7yCdwB2JP0
JIBNAdC1jkIR0O6VXCUO
=Iq3d
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
