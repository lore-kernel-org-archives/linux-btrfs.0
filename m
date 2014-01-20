Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41457 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaATFow (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 00:44:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W57fG-0005Ma-LK
	for linux-btrfs@vger.kernel.org; Mon, 20 Jan 2014 06:44:50 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 06:44:50 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 06:44:50 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Working on Btrfs as topic for master thesis
Date: Sun, 19 Jan 2014 21:44:39 -0800
Message-ID: <lbid3r$1ui$1@ger.gmane.org>
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 16/01/14 11:23, Toggenburger Lukas wrote:
> One of my ideas was to work on Btrfs.

One thing I would like see it automatic backup copies of data.  For
example if you are only using 10% of the total space then make an
additional 9 copies of the data in the free space (low priority in the
background).  As more space is used reclaim that dup/free space.  The
principle especially applies when you have more than one device.

The goal is to ensure that all the space is used, and that there is the
maximum probability of data recovery.

If you are more interested in the theoretical side then looking into
compression would be interesting.  ie how close to the theoretical best
compression are we.  Various filesystems like btrfs and NTFS make all
sorts of compromises in algorithm choices but also especially in the size
of blocks they compress.  How much better could be done?

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlLct8cACgkQmOOfHg372QTiNACgs1WNJF1tCM5boWP8L3obD0jU
4qsAnAjANq6TE6Gh5ATNbEGTmoA6/W+s
=YnrI
-----END PGP SIGNATURE-----

