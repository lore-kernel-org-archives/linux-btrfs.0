Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56432 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbaBKBCp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 20:02:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WD1kJ-0005Zm-N9
	for linux-btrfs@vger.kernel.org; Tue, 11 Feb 2014 02:02:43 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 02:02:43 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 02:02:43 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: What to do about df and btrfs fi df
Date: Mon, 10 Feb 2014 17:02:31 -0800
Message-ID: <ldbsqr$dlg$1@ger.gmane.org>
References: <52F9014F.6070901@fb.com>	<20140210170606.GK6490@carfax.org.uk> <CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/02/14 10:24, cwillu wrote:
> The regular df data used number should be the amount of space required 
> to hold a backup of that content (assuming that the backup maintains 
> reflinks and compression and so forth).
> 
> There's no good answer for available space;

I think the flipside of the above works well.  How large a group of files
can you expect to create before you will get ENOSPC?

That for example is the check code does that looks at df - "I need to put
in XGB of files - will it fit?"  It is also what users do.

This is also what NTFS under Windows does with compression.  If it says
you have 5GB of space left then you will be able to put in 5GB of
uncompressible files.  Of course if they are compressible then you don't
end up consuming all the free space.

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlL5dqcACgkQmOOfHg372QQBzgCgyrvj+WnZevjEDdgbAFd2nHaD
H98AoK0ZSDwZJpSMIdXpGYZGjWuPpGTh
=xJ+X
-----END PGP SIGNATURE-----

