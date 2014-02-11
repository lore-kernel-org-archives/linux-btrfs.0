Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36149 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbaBKT6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 14:58:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WDJTT-0008QL-Gq
	for linux-btrfs@vger.kernel.org; Tue, 11 Feb 2014 20:58:31 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 20:58:31 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 20:58:31 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: What to do about df and btrfs fi df
Date: Tue, 11 Feb 2014 11:58:19 -0800
Message-ID: <lddvcf$ds8$1@ger.gmane.org>
References: <52F9014F.6070901@fb.com>	<20140210170606.GK6490@carfax.org.uk>	<CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>	<ldbsqr$dlg$1@ger.gmane.org> <CAE5mzvh+1EY-eF_frWHTBkmjOFgwEWva5UysF6PHjeaOajEytg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAE5mzvh+1EY-eF_frWHTBkmjOFgwEWva5UysF6PHjeaOajEytg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/02/14 19:13, cwillu wrote:
> But the answer changes dramatically depending on whether it's large 
> numbers of small files or a small number of large files, and the 
> conservative worst-case choice means we report a number that is half 
> what is probably expected.

Perfect is the enemy of good.

We aren't talking about a billion zero byte files and expecting them to
take no space.  It is things like a user with a file manager grabbing some
files and eyeballing if they will fit in the destination. Or the file
manager itself giving a warning before the copying starts ("they might not
fit").

In both cases the sum of the source file sizes is compared to the df on
the destination.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlL6gNsACgkQmOOfHg372QR+WACfd91k2MYzbBbb3RFFuLCJUyw0
tw0AoI51yxrXCGFYHJBEK3+rwqR6i/iY
=RIiX
-----END PGP SIGNATURE-----

