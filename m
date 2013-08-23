Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50974 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab3HWTfk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 15:35:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VCx91-0008SO-BH
	for linux-btrfs@vger.kernel.org; Fri, 23 Aug 2013 21:35:39 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 21:35:39 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 21:35:39 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Date: Fri, 23 Aug 2013 12:35:25 -0700
Message-ID: <kv8dhn$lko$1@ger.gmane.org>
References: <kv74sk$bg9$1@ger.gmane.org> <CE3CD861.3C3F5%mark@backupsystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CE3CD861.3C3F5%mark@backupsystems.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 23/08/13 01:20, Mark Ridley wrote:
> The main reason I started using strict allocate = yes on samba was out
> of desperation/exasperation with BTRFS.

The most effective performance option is to turn oplocks on.
Opportunistic locks are granted to a client when it is the only one with a
file open.  That lets it do caching and not even tell the server about
record locking.  Once another client opens the same file then the first
client has to flush all outstanding writes, its caches, record locking etc.

I don't know what Samba currently uses as the default value, but it is
traditionally set to off because there are scenarios under which it isn't
sufficiently robust (eg access on the Unix server side, a network break
when there is outstanding data).

http://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/locking.html#id2616903

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIXuX0ACgkQmOOfHg372QSRwgCgwwwoo7QqRql8+CS5xggRBVRt
krAAn1wFiIIliZJ7WbWh/oh8crEWLgfR
=HZG9
-----END PGP SIGNATURE-----

