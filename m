Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37627 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab3CXBLm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 21:11:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UJZTf-0001QR-E1
	for linux-btrfs@vger.kernel.org; Sun, 24 Mar 2013 02:12:03 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2013 02:12:03 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2013 02:12:03 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH] btrfs: document mount options in Documentation/fs/btrfs.txt
Date: Sat, 23 Mar 2013 18:11:26 -0700
Message-ID: <kiljrq$efp$1@ger.gmane.org>
References: <514DEB06.7000606@redhat.com> <kil9uq$210$1@ger.gmane.org> <514E2F69.1030204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <514E2F69.1030204@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 23/03/13 15:40, Eric Sandeen wrote:
> I imagine it depends on the details of the workload & storage as well.

If the people who write btrfs can't come up with some measures to deem
appropriateness, then how can the administrators who have even less
information :-)

I suspect file size has nothing to do with it, and it is entirely about
the volume of random writes.  (But as a correlator smaller files are
unlikely to get many random writes because they contain less useful
information than larger files.)

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlFOUr0ACgkQmOOfHg372QSIsgCg3D1k0dL/2bMQpzHRDdlMkUo2
TT8AoI11eLAdAv6iQPweHaeVUiJNSRf6
=OVVq
-----END PGP SIGNATURE-----

