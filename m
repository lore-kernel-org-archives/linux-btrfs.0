Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbbAHUoH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 15:44:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y9JvL-0008Qj-0L
	for linux-btrfs@vger.kernel.org; Thu, 08 Jan 2015 21:43:19 +0100
Received: from cruzio-216-173-135-181.static.cruzio.com ([216.173.135.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 21:43:18 +0100
Received: from rogerb by cruzio-216-173-135-181.static.cruzio.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 21:43:18 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: price to pay for nocow file bit?
Date: Thu, 08 Jan 2015 12:42:48 -0800
Message-ID: <m8mq49$qo4$1@ger.gmane.org>
References: <20150107174315.GA21865@gardel-login> <20150108155610.GA12859@hungrycats.org> <20150108165321.GA23339@gardel-login>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <20150108165321.GA23339@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/08/2015 08:53 AM, Lennart Poettering wrote:
> this will help little if we change things in the beginning of the
> file,

Have you considered changing the format so that those pointers are
stored at the end of the file, letting data always be append only?

While it is traditional to have things at the beginning as headers,
there are formats like zip where metadata is stored at the end instead
providing other benefits.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSu68gACgkQmOOfHg372QSn5wCfaRAfI/xN3SHiDEPNMjjAuFQB
NbcAn2GCjzZyfHocF7yTKEBFdt3znD6n
=KL2f
-----END PGP SIGNATURE-----

