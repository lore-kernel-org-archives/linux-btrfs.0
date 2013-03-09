Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36592 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3CIWZj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Mar 2013 17:25:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UESDG-0002P9-IQ
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 23:25:58 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 23:25:58 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 23:25:58 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sat, 09 Mar 2013 14:25:25 -0800
Message-ID: <khgcsi$1k4$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/03/13 12:31, Hugo Mills wrote:
> Some time ago, and occasionally since, we've discussed altering the 
> "RAID-n" terminology to change it to an "nCmSpP" format, where n is
> the number of copies, m is the number of (data) devices in a stripe per
> copy, and p is the number of parity devices in a stripe.

I despise both terminologies because they mix up administrator goals with
how those goals are provided by the filesystem.

Using RAID0 as an example, what is actually desired is maximum performance
and there is no need to survive the failure of even a single disk. I don't
actually care if it uses striping, parity, hot data tracking, moving
things to faster outside edges of spinning disks, hieroglyphics, rot13
encoding, all of the above or anything else.

Maximum performance is always desired and "RAID" settings really track to
"data must survive the failure of N disks" and/or "data must be accessible
if at least N disks are present".  As an administrator that is what I
would like to set and let the filesystem do whatever is necessary to meet
those goals  (I'd love to be able to set this on a per directory/file
basis too.)

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlE7ttUACgkQmOOfHg372QT9LwCgg8lxpxC/w8E5dTsQ3Qx4ujWh
esQAnR2pKmwrJndsvynDia88KsrzJ9m9
=vv3v
-----END PGP SIGNATURE-----

