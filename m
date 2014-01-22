Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41948 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbaAVUzx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 15:55:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W64q0-0004MG-2s
	for linux-btrfs@vger.kernel.org; Wed, 22 Jan 2014 21:55:52 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 21:55:52 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 21:55:52 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Working on Btrfs as topic for master thesis
Date: Wed, 22 Jan 2014 12:55:39 -0800
Message-ID: <lbpb7v$7m2$1@ger.gmane.org>
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local> <lbid3r$1ui$1@ger.gmane.org> <20140122121220.GF6498@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20140122121220.GF6498@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 22/01/14 04:12, David Sterba wrote:
> I have done some work here, so far it's stalled due to more important 
> work.
> 
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Compression_enhancements
>
>  Do you have other suggestions beyond what's proposed there?

There was the theoretical side - ie coming up with a way of defining
perfection which then allows measuring against.  For example you have
going up to a 128K block size but without knowing the theoretical best we
don't know if that is a stopgap or very good.

That also feeds into things like if it would be a good idea to go back
afterwards (perhaps as part of defrag) and spend more effort on
(re)compression.

Another consideration is perhaps having the compression dictionary kept
separate from the compressed blocks thereby allowing it to be used across
blocks and potentially files.  Compressors like smaz (very good on short
pieces of text) work by having a precomputed dictionary - perhaps those
can be used too.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlLgMEQACgkQmOOfHg372QRGDACeI604tw4OZsITHZEY60O6aiQX
GD4AoIj9s2rbVWiRp2W4FR6rkAf+iSsH
=cD4/
-----END PGP SIGNATURE-----

