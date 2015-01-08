Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58661 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbbAHIjA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 03:39:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y98bS-0005gT-Os
	for linux-btrfs@vger.kernel.org; Thu, 08 Jan 2015 09:38:02 +0100
Received: from ip4da2a5ae.direct-adsl.nl ([77.162.165.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 09:38:02 +0100
Received: from koen by ip4da2a5ae.direct-adsl.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 09:38:02 +0100
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: price to pay for nocow file bit?
Date: Thu, 08 Jan 2015 09:35:33 +0100
Message-ID: <m8lfgl$c5p$1@ger.gmane.org>
References: <20150107174315.GA21865@gardel-login>	<54AD929E.608@fb.com> <CAJCQCtQGrPSJhxvbivJ4Sx0rqposm72rcC0K-C5SCCRADR_QNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtQGrPSJhxvbivJ4Sx0rqposm72rcC0K-C5SCCRADR_QNg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Murphy schreef op 08-01-15 om 09:24:
> On Wed, Jan 7, 2015 at 1:10 PM, Josef Bacik <jbacik@fb.com> wrote:
>> On 01/07/2015 12:43 PM, Lennart Poettering wrote:
>>> 
>>> Heya!
>>> 
>>> Currently, systemd-journald's disk access patterns (appending to the 
>>> end of files, then updating a few pointers in the front) result in 
>>> awfully fragmented journal files on btrfs, which has a pretty 
>>> negative effect on performance when accessing them.
>>> 
>> 
>> I've been wondering if mount -o autodefrag would deal with this problem
>> but I haven't had the chance to look into it.
> 
> I've been using autodefrag and haven't run into journal corruptions that
> I can attribute to btrfs since the last one was fixed over a year ago.
> Chris Mason has suggested preference to use of autodefrag for this use
> case rather than xattr +C. But I don't know the time frame for autodefrag
> by default, it's come up a couple times but it's not the default yet.

Same here, no issues with using autodefrag and journals.

regards,

Koen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFUrkFVMkyGM64RGpERAgGKAJ9pmXA4STYx6sUJP5HBALcUCkfMqwCeNhzR
8v4u6bvhtFZYxYbGDiHghps=
=4MPU
-----END PGP SIGNATURE-----

