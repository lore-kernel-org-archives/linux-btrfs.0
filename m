Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45027 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbcEMQhD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 12:37:03 -0400
Date: Fri, 13 May 2016 12:37:01 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.de>, dsterba@suse.cz,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160513163701.GG15597@hungrycats.org>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
 <20160511025211.GF7633@wotan.suse.de>
 <20160511173659.GI29353@suse.cz>
 <20160512205426.GL7633@wotan.suse.de>
 <eb0c315c-cea0-276c-d9bb-d83883cd01a4@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
In-Reply-To: <eb0c315c-cea0-276c-d9bb-d83883cd01a4@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 13, 2016 at 08:14:10AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-05-12 16:54, Mark Fasheh wrote:
> >Now ask yourself the question - would you accept a write cache which is
> >expensive to fill and would only have a hit rate of less than 5%?
> In-band deduplication is a feature that is not used by typical desktop users
> or even many developers because it's computationally expensive, but it's
> used _all the time_ by big data-centers and similar places where processor
> time is cheap and storage efficiency is paramount. Deduplication is more
> useful in general the more data you have.  5% of 1 TB is 20 GB, which is not
> much.  5% of 1 PB is 20 TB, which is at least 3-5 disks, which can then be
> used for storing more data, or providing better resiliency against failures.

There's also a big cost difference between a 5-drive and 6-drive array
when all your servers are built with 5-drive cages.  Delay that expansion
for six months, and you can buy 5 larger drives for the same price.

I have laptops with filesystems that are _just_ over 512GB before dedup.
SSDs seem to come in 512GB and 1TB sizes with nothing in between, so
saving even a few dozen MB can translate into hundreds of dollars per
user (not to mention the bureaucratic hardware provisioning side-effects
which easily triple that cost).

Working on big software integration projects can generate 60% duplication
rates.  Think checkout of entire OS + disk images + embedded media,
build + install trees with copied data, long build times so there are
multiple working directories, multiple active branches of the same
project, and oh yeah it's all in SVN, which stores a complete second
copy of everything on disk just because wasting space is cool.

> To look at it another way, deduplicating an individual's home directory will
> almost never get you decent space savings, the majority of shared data is
> usually file headers and nothing more, which can't be deduplicated
> efficiently because of block size requirements. Deduplicating all the home
> directories on a terminal server with 500 users usually will get you decent
> space savings, as there very likely are a number of files that multiple
> people have exact copies of, but most of them are probably not big files.
> Deduplicating the entirety of a multi-petabyte file server used for storing
> VM disk images will probably save you a very significant amount of space,
> because the probability of having data that can be deduplicated goes up as
> you store more data, and there is likely to be a lot of data shared between
> the disk images.

Mail stores benefit from this too.  For some reason, Microsoft Office
users seem to enjoy emailing multi-megabyte runs of MIME-encoded zeros
to each other.  ;)


--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlc2Aq0ACgkQgfmLGlazG5ygdwCfR7hE0d6j5fIGuu3efoHA5+lR
HogAn2Ob90q7G1kJ1IffvLc5Kzm0w2AT
=3gPK
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
