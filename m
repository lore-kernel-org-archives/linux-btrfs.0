Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:42006 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934774AbdKQTOM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 14:14:12 -0500
Received: by mail-io0-f177.google.com with SMTP id u42so9784153ioi.9
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 11:14:12 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <74E5DB55-6E0F-4A00-BF94-0D2DEDC87C69@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_78A525E9-FAA6-40ED-BCA3-317A88CA682F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
Date: Thu, 16 Nov 2017 18:26:14 -0700
In-Reply-To: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_78A525E9-FAA6-40ED-BCA3-317A88CA682F
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Nov 15, 2017, at 7:18 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> 
> [Background]
> Recently I'm considering the possibility to use checksum from filesystem
> to enhance device-mapper raid.
> 
> The idea behind it is quite simple, since most modern filesystems have
> checksum for their metadata, and even some (btrfs) have checksum for data.
> 
> And for btrfs RAID1/10 (just ignore the RAID5/6 for now), at read time
> it can use the checksum to determine which copy is correct so it can
> return the correct data even one copy get corrupted.
> 
> [Objective]
> The final objective is to allow device mapper to do the checksum
> verification (and repair if possible).
> 
> If only for verification, it's not much different from current endio
> hook method used by most of the fs.
> However if we can move the repair part from filesystem (well, only btrfs
> supports it yet), it would benefit all fs.

I recall Darrick was looking into a mechanism to do this.  Rather than
changing the whole block layer to take a callback to do a checksum, what
we looked at was to allow the upper-layer read to specify a "retry count"
to the lower-layer block device.  If the lower layer is able to retry the
read then it will read a different device (or combination of devices for
e.g. RAID-6) based on the retry count, until the upper layer gets a good
read (based on checksum, or whatever).  If there are no more devices (or
combinations) to try then a final error is returned.

Darrick can probably point at the original thread/patch.

Cheers, Andreas






--Apple-Mail=_78A525E9-FAA6-40ED-BCA3-317A88CA682F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaDjq3pIg59Q01vtYRAmZhAJ9K06HBQQAnRGfZJJvb1TO4hTFfngCfTyg9
E2mzVop1nAVtDDgFdWDGOy8=
=z0v4
-----END PGP SIGNATURE-----

--Apple-Mail=_78A525E9-FAA6-40ED-BCA3-317A88CA682F--
