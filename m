Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48210 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbbFEDEW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jun 2015 23:04:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z0hvf-0007r7-MX
	for linux-btrfs@vger.kernel.org; Fri, 05 Jun 2015 05:04:19 +0200
Received: from cruzio-216-173-135-181.static.cruzio.com ([216.173.135.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 05:04:19 +0200
Received: from rogerb by cruzio-216-173-135-181.static.cruzio.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 05:04:19 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: btrfs device ready non-success exit code
Date: Thu, 04 Jun 2015 20:04:09 -0700
Message-ID: <mkr3jb$nbt$1@ger.gmane.org>
References: <mkq3i4$r5d$1@ger.gmane.org> <5570DE64.5020104@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5570DE64.5020104@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/04/2015 04:25 PM, Anand Jain wrote:
>> typically ready cli is to check disk pool status in an unmounted
>> state.

On my desktop with btrfs RAID0 on two partitions, the exit code of
ready is always 1.  On my laptop with btrfs RAID0 on two LUKS/dmcrypt
partitions the exit code is 0.  (In both cases there are / and /home
already mounted as subvolumes.)

The documentation says:

  Check device to see if it has all of it’s devices in
  cache for mounting

The semantics implied by that are that a successful return means you
can mount the device(s).  Consequently if already mounted, surely it
should return success?

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlVxEakACgkQmOOfHg372QTIKwCgwKJIqjNWJH/FMfVtm1Ktesxz
E5YAnjxMP8VyfuLPM2fmfxU8UuuyDpGi
=Axi1
-----END PGP SIGNATURE-----

