Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51857 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab3CJLsg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 07:48:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UEekJ-00053h-8u
	for linux-btrfs@vger.kernel.org; Sun, 10 Mar 2013 12:48:55 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 12:48:55 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 12:48:55 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sun, 10 Mar 2013 04:48:18 -0700
Message-ID: <khhru0$jug$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <khgcsi$1k4$1@ger.gmane.org> <20130310014434.GB30771@carfax.org.uk> <khh6er$nmk$1@ger.gmane.org> <CAFWF=anqt8ssajAQtVR2CBCLVXJJSneLjuvRZERm7m-oPkK=Ug@mail.gmail.com> <CAFWF=amO=G+BtqJxBNj8h_5Y7d8T=38xK4qnu=LZbUQyn3Zvew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CAFWF=amO=G+BtqJxBNj8h_5Y7d8T=38xK4qnu=LZbUQyn3Zvew@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/03/13 22:37, Harald Glatt wrote:
> I have to add something to my own message: Even the notion of thinking 
> in 'how many devices do I want to give away for redundancy' is 
> outdated...

Devices are the only real tangible thing that you can actually point at.
They are the final physical unit and what gets added or replaced, and can
be put in another machine for recovery.

> What it really comes down to is how much space am I willing to
> sacrifice so that my reliablilty is increasing.

The answer as a whole is simple - you want all unused space for
reliability and performance.  If you put 5GB of data on 10GB of space then
50% is the value.

> Rather than addressing that at a per-drive level with a futuristic fs
> like btrfs I think setting a percent value of total space would be
> best.

The problem is that drives are what fail, can be added or removed.  A
percent value makes that considerably harder to deal with especially
changes after the initial setup.

It would be nice to be able to indicate that same data/files/directories
are more important than others (eg cache/spool/trash directories are
unimportant, my documents and photos are very important).

> This is pretty much what it would be like in a perfect world, in my
> opinion :)

Conceptually I want to point at the drives and say "do the right thing"
without any further configuration, monitoring or micro-managing.  In the
short/medium term I'd even be happy to run a btrfs cron job that digs
around, rearranges things and gives me a final report with a colour coding
homeland security style.  When it hits yellow, it is time to delete files
or add more storage.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlE8cwIACgkQmOOfHg372QSjUACfcDn1lB/wHXZH9E5a5elUlAT3
Y+QAoL9cNtjMpdZtqYH+t6QXTcOYwYBy
=UMKJ
-----END PGP SIGNATURE-----

