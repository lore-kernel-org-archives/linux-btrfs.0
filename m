Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60825 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab3EIG4b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 May 2013 02:56:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UaKmE-0005Mb-3W
	for linux-btrfs@vger.kernel.org; Thu, 09 May 2013 08:56:30 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 08:56:30 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 08:56:30 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Date: Wed, 08 May 2013 23:56:18 -0700
Message-ID: <kmfhae$ie1$1@ger.gmane.org>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com> <CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/05/13 16:13, Zhi Yong Wu wrote:
> i want to know if btrfs hot relocation support is still meanful

It is to me.  The problem with bcache is that it is a cache.  ie if you
have a 256GB SSD and a 500GB HDD then you'll have total storage of 500GB.
 Hot relocation was described as having 750GB available in the same scenario.

I'd also expect btrfs level support to be more friendly such as being able
to mount -o degraded if one of the devices is missing.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGLSIkACgkQmOOfHg372QSHQACeLwbhnVsH7+/6ZSIaGAcMUyBe
gPwAoNAKBAFB65XZQbLyxyCJPHODR+9z
=6OXt
-----END PGP SIGNATURE-----

