Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46628 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbbADWcd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Jan 2015 17:32:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7tip-0000RJ-6c
	for linux-btrfs@vger.kernel.org; Sun, 04 Jan 2015 23:32:31 +0100
Received: from cruzio-216-173-135-181.static.cruzio.com ([216.173.135.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 23:32:31 +0100
Received: from rogerb by cruzio-216-173-135-181.static.cruzio.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 23:32:31 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: scrub wedged (both running and not running at the same time)
Date: Sun, 04 Jan 2015 14:32:18 -0800
Message-ID: <m8cf1j$2lh$1@ger.gmane.org>
References: <m87b4g$v19$1@ger.gmane.org> <20150103000844.GD6114@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <20150103000844.GD6114@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/02/2015 04:08 PM, David Sterba wrote:
> On Fri, Jan 02, 2015 at 03:54:55PM -0800, Roger Binns wrote:
>> I can't start a scrub because it is running, and can't cancel it 
>> because it isn't running!  How do I get out of this state?  OS
>> is Ubuntu 14.10.
> 
> This has been fixed in btrfs-progs 3.16.2 by commit 
> d5fd05a773e2b19455be7e1208e9003a607483c6

Thanks.  I cloned and built the latest stable btrfs-progs and scrub
now works on that filesystem as expected.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpv3IACgkQmOOfHg372QQfrACffGNwaoZZOwiQpsOc1eu6LBYW
2CYAn0v1aNq1zyenW2sBfz2JZyPvWBmK
=8Ekg
-----END PGP SIGNATURE-----

