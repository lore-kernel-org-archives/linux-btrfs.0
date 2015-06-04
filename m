Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49068 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbbFDR6D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jun 2015 13:58:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z0ZOo-00015b-0H
	for linux-btrfs@vger.kernel.org; Thu, 04 Jun 2015 19:57:50 +0200
Received: from cruzio-216-173-135-181.static.cruzio.com ([216.173.135.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 19:57:49 +0200
Received: from rogerb by cruzio-216-173-135-181.static.cruzio.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 19:57:49 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: btrfs device ready non-success exit code
Date: Thu, 04 Jun 2015 10:57:23 -0700
Message-ID: <mkq3i4$r5d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This is on current Ubuntu 15.04.  What is device ready unhappy with?
Note that the root filesystem and /home (both subvolumes of this) are
mounted and working perfectly, and even where the commands are run from.

$ sudo btrfs fi show /dev/sda1
Label: 'main'  uuid: 3ff68715-0daa-4e44-8de2-0997f36d8ab6
	Total devices 2 FS bytes used 417.22GiB
	devid    2 size 894.25GiB used 362.03GiB path /dev/sdb1
	devid    3 size 894.25GiB used 362.03GiB path /dev/sda1

Btrfs v3.17
$ sudo btrfs fi show /
Label: 'main'  uuid: 3ff68715-0daa-4e44-8de2-0997f36d8ab6
	Total devices 2 FS bytes used 417.22GiB
	devid    2 size 894.25GiB used 362.03GiB path /dev/sdb1
	devid    3 size 894.25GiB used 362.03GiB path /dev/sda1

Btrfs v3.17
$ sudo btrfs device ready /dev/sda1 ; echo $?
1
$ sudo btrfs device ready /dev/sdb1 ; echo $?
1
$ uname -a
Linux workstation 3.19.0-18-generic #18-Ubuntu SMP Tue May 19 18:31:35
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlVwkX4ACgkQmOOfHg372QTEjQCgmhFU8Gxx8VOeNay2fkJjgpaU
ZOEAn18pogQVQnS8AzPzSEY7gu6rH+q3
=foM6
-----END PGP SIGNATURE-----

