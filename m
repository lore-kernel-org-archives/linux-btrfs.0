Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59877 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758460AbaLKTir (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 14:38:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xz9ZV-00019V-Fl
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 20:38:45 +0100
Received: from cruzio-216-173-135-181.static.cruzio.com ([216.173.135.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 20:38:45 +0100
Received: from rogerb by cruzio-216-173-135-181.static.cruzio.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 20:38:45 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
Date: Thu, 11 Dec 2014 11:38:29 -0800
Message-ID: <m6crrn$63l$1@ger.gmane.org>
References: <547BCB43.5020505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <547BCB43.5020505@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/30/2014 05:58 PM, Qu Wenruo wrote:
> 2. Heavy dependency If use it, btrfs-progs will include RDBMS as
> the make and runtime dependency. Such low level progs depend on
> high level programs like sqlite3 may be very strange.

BTW SQLite is designed as a library.  It is shipped as a single file
with the deliberate intention you add the sqlite3.c file to your
project.  For private internal tool use you don't need to depend or
use the system SQLite in any way.

  https://www.sqlite.org/amalgamation.html

SQLite also lets you easily define collation sequences, your own
functions and virtual tables which will make all this easier.  Using
pragmas you can control use of memory and disk space for operation.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSJ8rAACgkQmOOfHg372QRzJACgoip0vhoM0XEkVIB9/ZggPXX1
PuMAn3/0lP+SQyxDh6UFStt5hlA2Wwkz
=b5GF
-----END PGP SIGNATURE-----

