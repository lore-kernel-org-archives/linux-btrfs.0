Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41959 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab3GRWAM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 18:00:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UzwF7-00005R-9l
	for linux-btrfs@vger.kernel.org; Fri, 19 Jul 2013 00:00:09 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jul 2013 00:00:09 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jul 2013 00:00:09 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Questions about multi-device behavior
Date: Thu, 18 Jul 2013 14:59:58 -0700
Message-ID: <ks9ogo$8rg$1@ger.gmane.org>
References: <1860433.azE0Vf7tMy@horus> <20130718173337.GN24343@twin.jikos.cz> <CCB92795-C346-467B-B85F-D5CB5C401B77@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CCB92795-C346-467B-B85F-D5CB5C401B77@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 18/07/13 13:05, Chris Murphy wrote:
> Sounds like if I have a degraded 'single' volume, I can simply cp or
> rsync everything from that volume to another, and I'll end up with a
> successful copy of the surviving data. True?

Not quite.  I did it with cp -a.  Because all the metadata survived, cp
would create the target file, but then get an i/o error on opening/reading
the source file.  It would print an error message, but not delete the
empty target file. Consequently I ended up with loads of zero length files
I had to go in and delete afterwards.

I briefly looked for an rsync option to keep going on source i/o errors
but didn't find one.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHoZV4ACgkQmOOfHg372QRPFwCgob01TavS2qffBkxkuv0g9bl3
pC8An25Mgx+cRXb0Kds+GRnzaj2P0Acy
=UA5J
-----END PGP SIGNATURE-----

