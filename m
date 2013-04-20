Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59565 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab3DTXBp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 19:01:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UTgmt-0001Gb-NH
	for linux-btrfs@vger.kernel.org; Sun, 21 Apr 2013 01:01:43 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 01:01:43 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 01:01:43 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: data DUP
Date: Sat, 20 Apr 2013 16:01:32 -0700
Message-ID: <kkv6o8$9f0$1@ger.gmane.org>
References: <kkut3u$lp1$1@ger.gmane.org> <20130420204814.GN7639@carfax.org.uk> <kkv0gv$jpo$1@ger.gmane.org> <20130420212311.GO7639@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130420212311.GO7639@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 20/04/13 14:23, Hugo Mills wrote:
> You should upgrade anyway -- there's been a number of serious bugs in
> btrfs fixed since then.

13.04 is imminent so I'll pick up a newer kernel as part of that anyway.
(Also Tanglu which I hope to move to intends to use the Ubuntu kernel anyway.)

In any event I am not worried.  Bug fixes get backported. The probability
of hitting any serious bug is low (others would likely be victims first)
and worst case I have backups (snapshots, other machines, Google/Dropbox,
DVDs & hard drives at other people's houses etc).

There are two major reasons I switched from ext4.  The first is that
everything is online, including adding and removing devices, checking data
integrity etc.

The second is that data not silently lost.  I had some bad sectors develop
on ext4 spinning disk and the only way to properly recover was to do
offline checks that would have taken ~ 24 hours!  Finding out which
filenames were involved was far too much effort.

My philosophy is that we have machines with billions of processor cycles
per second.  They can figure things out for themselves without requiring
me to baby sit them!

I also run btrfs in a variety of configurations - raid0, raid1, sata, usb,
hdd, ssd, single device, multi-device, bare, dmcrypt, machines on all the
time, laptop, frequent suspend/resume, frequent power on/off.  I've never
experienced any problems with btrfs and use scrub for reassurance.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlFzHkwACgkQmOOfHg372QSBBwCfYYJQm9l9ts9eWOvZIRUlTCWJ
KsMAoLVsd1fRdV+T7KO7nVVGuFCGYN5a
=Y4by
-----END PGP SIGNATURE-----

