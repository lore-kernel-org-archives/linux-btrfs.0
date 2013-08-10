Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:54886 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab3HJN4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 09:56:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id AA11C40C14
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 23:56:11 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 29921-01 for <linux-btrfs@vger.kernel.org>;
 Sat, 10 Aug 2013 23:56:11 +1000 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 4D73340C13
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 23:56:11 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs device stats /dev/mapper/ext4 SEGV
Date: Sat, 10 Aug 2013 23:56:06 +1000
Message-ID: <1384122.xvVNAvLv2n@quad>
In-Reply-To: <201308101907.50539.russell@coker.com.au>
References: <201308101907.50539.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11667450.45kN0fiDsq"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart11667450.45kN0fiDsq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sat, 10 Aug 2013 07:07:50 PM Russell Coker wrote:

> I can repeatedly get the following SEGV from running "btrfs device stats" on
> a  device node for an Ext3/4 filesystem.  This happens with the version of
> the code downloaded from the above GIT repository as well as with an older
> version.  Obviously the command in question is not going to do anything
> useful when run against a non-BTRFS filesystem, but it should do something
> other than crash.

The code calls btrfs_read_dev_super() on that filesystem, but it looks like the 
checks are failing to detect it as not btrfs.  :-(

I can reproduce the crash here too with ext3 and XFS filesystems.

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart11667450.45kN0fiDsq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUAUgZGdo1yjaOTJg85AQIyvQf/RX+t1tWgbIaj45nDM5Gn3mwgbL+4hV7r
vW3M6opk7eYk/jEyc9QUlHD8HakDjnad2twu/cxrxnCXTVD4H5JTewpyLefPL8RV
OjFQ9TZqqoaOC/YSd1X1btdiKxl8vP++aKSxXnGhlK0IX70EVP4jPkIiiNWz7P4R
Zt2IGdLXzPE818Yxw6OlopRt1mZGmcgeUDCl7/1+7v2hMfAjTODOB1PiAjNTXX3Z
n2YLbLq2Y9zGnT4gQjPavXJFsl+YaZlMwHQvwHt9sGzdBlcZYhx5ihg3ce30dKPa
fzxipjaxr9EXnP2947saYpK6sIO+cQ/ws9cwpn2TcNH7bQpPRHs4yw==
=OR2K
-----END PGP SIGNATURE-----

--nextPart11667450.45kN0fiDsq--

