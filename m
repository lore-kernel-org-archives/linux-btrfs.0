Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35119 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3A3US6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 15:18:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U0e7i-0007gj-O9
	for linux-btrfs@vger.kernel.org; Wed, 30 Jan 2013 21:19:10 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 21:19:10 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 21:19:10 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: RAID 0 across SSD and HDD
Date: Wed, 30 Jan 2013 12:18:41 -0800
Message-ID: <kebv6v$q6t$1@ger.gmane.org>
References: <keap27$oqb$1@ger.gmane.org> <20130130100201.GN16285@carfax.org.uk> <keatr3$65q$1@ger.gmane.org> <CADU+-uCCGhCgUQ3yc+XCpdiU-8gTJeqs2LDxOu5g8HyiFC-7DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <CADU+-uCCGhCgUQ3yc+XCpdiU-8gTJeqs2LDxOu5g8HyiFC-7DA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 30/01/13 11:10, Filipe Brandenburger wrote:
> You could try something like "-l=linear" on md-raid or something 
> similar on LVM to build a 750GB volume

That would also require wiping the filesystems and starting again(*).  One
of the joys of btrfs has been not dealing with LVM.  On my workstation I
have two 2GB disks, but on one there is a sizeable Windows partition.
Getting LVM to stripe across the common sized space and then just use the
rest took quite a while to work out, requires running several different
commands and was something I had to write down.  There was nothing
intuitive.  It was a happy day when I could wipe and replace with btrfs.

Contrast with btrfs where 'btrfs --help' is almost always sufficient and
adding/removing/resizing is trivial (and online).

(*) I realise I could do things like add an external disk, btrfs add that
and then btrfs delete the internals, redo the internal storage, btrfs add
those back and then btrfs delete the external.  It would take a long time,
and is a reminder as to why I would prefer to be all btrfs everywhere
rather than also dealing with LVM and similar.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlEJgCEACgkQmOOfHg372QSwEwCdG5GDUC2Ab/eVZo36t3Zs691R
otAAn3p4Gq8lV2NgPp79799BflBwt/cW
=yl2B
-----END PGP SIGNATURE-----

