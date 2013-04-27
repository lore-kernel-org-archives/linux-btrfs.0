Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59305 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab3D0X3q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Apr 2013 19:29:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UWEYq-0001LJ-Qh
	for linux-btrfs@vger.kernel.org; Sun, 28 Apr 2013 01:29:44 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2013 01:29:44 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2013 01:29:44 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: data DUP
Date: Sat, 27 Apr 2013 16:29:38 -0700
Message-ID: <klhn0u$vcr$1@ger.gmane.org>
References: <kkut3u$lp1$1@ger.gmane.org>  <20130420204814.GN7639@carfax.org.uk> <kkv0gv$jpo$1@ger.gmane.org>  <20130420212311.GO7639@carfax.org.uk> <kkv6o8$9f0$1@ger.gmane.org> <1367098836.14073.5.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <1367098836.14073.5.camel@ayu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 27/04/13 14:40, Calvin Walton wrote:
> Unfortunately, bugfixes in btrfs have tended to be *not* backported; 
> aside from a few special cases, ...

Your efforts to scare me are admirable, but have failed :-)

As btrfs development has progressed, the probability of a random user like
me hitting bugs keeps decreasing.  This is a reflection of the maturity of
the code base, the increasing number of users, improved test suites, more
eyes on the code, more diversity in uses etc. As far as I can see,
backported bugfixes are made when the probability of a bug being
encountered is significantly higher than the current probabilities, and
that is why they are rare.

As for the severity of the rarely hit bugs, the COW nature of the data
means there is unlikely to be corruption, and if there is then of the most
recent activity.  Additionally the checksums mean it is possible to
proactively verify (online) that unexpected corruption hasn't been
creeping in.

And if all that fails, I have multiple layers of backups.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlF8X14ACgkQmOOfHg372QT5EQCfSbzZBRdm1KyljpoNpP5kHy15
iFoAn2eyair54JQdhnL2dfvqAJrVMWe4
=9zYA
-----END PGP SIGNATURE-----

