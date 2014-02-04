Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40297 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaBDDUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 22:20:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WAWYM-0001rF-SV
	for linux-btrfs@vger.kernel.org; Tue, 04 Feb 2014 04:20:02 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 04:20:02 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 04:20:02 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH] Btrfs: disable snapshot aware defrag for now
Date: Mon, 03 Feb 2014 19:19:48 -0800
Message-ID: <lcpm87$15e$1@ger.gmane.org>
References: <1391029530-17686-1-git-send-email-jbacik@fb.com> <20140203144802.GK1364@twin.jikos.cz> <52EFD19C.3050404@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <52EFD19C.3050404@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/02/14 09:27, Josef Bacik wrote:
> It is so totally broken that I don't want it being turned on by anybody
> who can't edit this and change it themselves.

The symptoms I saw are huge amounts of kernel memory consumption, possibly
till exhaustion of swap.  Are there other ways in which is it broken (eg
corruption)?

Also is this patch making its way to the various stables?

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlLwXE8ACgkQmOOfHg372QRLngCgpc445lPvM7YhGUxVdlU2O4vN
1CUAoM2NmeGPOeYxOji4yL4VRysBnTxg
=sQ3M
-----END PGP SIGNATURE-----

