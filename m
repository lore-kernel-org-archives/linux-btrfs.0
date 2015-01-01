Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39395 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbbAAUMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Jan 2015 15:12:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y6m6w-0004cT-CH
	for linux-btrfs@vger.kernel.org; Thu, 01 Jan 2015 21:12:46 +0100
Received: from cruzio-216-173-135-181.static.cruzio.com ([216.173.135.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jan 2015 21:12:46 +0100
Received: from rogerb by cruzio-216-173-135-181.static.cruzio.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jan 2015 21:12:46 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: I need to P. are we almost there yet?
Date: Thu, 01 Jan 2015 12:12:31 -0800
Message-ID: <m849ng$lcg$1@ger.gmane.org>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com> <54A3633C.3040609@ubuntu.com> <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net> <2740386.L6W23cCsJO@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <2740386.L6W23cCsJO@quad>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/31/2014 05:26 PM, Chris Samuel wrote:
> I suspect this is a knock-on effect of the fact that (unless this
> has changed recently & IIRC) RAID-1 with btrfs will only mirrors
> data over two drives, no matter how many you add to an array.

I wish btrfs wouldn't use the old school micro-managing storage
terminology (or only as aliases) and instead let you set the goals.
What people really mean is that they want their data to survive the
failure of N drives - exactly how that is done doesn't matter.  It
would also be nice to be settable as an xattr on files and directories.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSlqi8ACgkQmOOfHg372QTtrACeKT9OfzEtJyucEDNfeisfAw9z
Ao8AoIEevlY7MEyBHFBqyCCE1LJXGDw9
=zUJs
-----END PGP SIGNATURE-----

