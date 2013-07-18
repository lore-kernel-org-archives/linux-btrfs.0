Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56338 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab3GRCAp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 22:00:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UzdWK-00070M-FN
	for linux-btrfs@vger.kernel.org; Thu, 18 Jul 2013 04:00:40 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 04:00:40 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 04:00:40 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Questions about multi-device behavior
Date: Wed, 17 Jul 2013 19:00:24 -0700
Message-ID: <ks7i7i$9ev$1@ger.gmane.org>
References: <1860433.azE0Vf7tMy@horus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <1860433.azE0Vf7tMy@horus>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 17/07/13 14:24, Florian Lindner wrote:
> metadata ist mirrored on each device, data chunks are scattered more or
> less randomly on one disk.
> 
> a) If one disk fails, is there any chance of data recovery? b) If not,
> is there any advantage over a raid0 configuration.

I was using that exact configuration when one disk failed (2 x 2TB Seagate
drives).  The data was backed up in multiple ways, a lot of it was in
source control systems and the remainder was generated information.
Essentially the risk was worth taking since nothing would be lost.

One drive gave up mechanically - the controller still worked and it was
fun running SMART tests and having huge amounts of red text show up in
response.  The initial symptoms were that various programs crashed or
didn't launch with no diagnostics.  That is typical behaviour for Linux
apps when they get I/O errors on reads and writes.

Eventually I figured out the problem, and bought a new 4TB drive to
replace both originals and started recovery.  Out of ~750GB of original
data I could recover just over 2GB which represented files whose entire
contents were on the unfailed drive.

Having the metadata duplicated was however immensely helpful and I could
easily get a list of all directories and filenames, and used that to guide
what data I recovered/regenerated/reinstalled/checked out.

Meanwhile the performance improvement by having the data scattered across
both drives was noticeable.  I would often see it in iostat roughly evenly
balanced.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHnTDgACgkQmOOfHg372QSTJwCeI17B4QhstkM4nnO0qOMDB1ae
WfwAoOBu6lBwZ+GyFwnZVGXC5ki7Oge/
=i+YN
-----END PGP SIGNATURE-----

