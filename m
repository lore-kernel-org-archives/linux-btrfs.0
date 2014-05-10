Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:49166 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbaEJIEz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 04:04:55 -0400
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Abbas <mickylmartin@gmail.com>
Subject: Re: Sending incremental backup causes deadlock (3.14.3)
Date: Sat, 10 May 2014 18:04:31 +1000
Message-ID: <1718079.d2fxXYZyoQ@quad>
In-Reply-To: <536D0ED3.2050602@fb.com>
References: <CAKAA-n=_jMyWFbfcGvMsMDJg3t7VpRegDDDybEeQ5oxof8graA@mail.gmail.com> <536D0ED3.2050602@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Josef,

On Fri, 9 May 2014 01:22:27 PM Josef Bacik wrote:

> Known problem, fixed in 3.15-rc1.  Thanks,

Is the fix suitable for -stable too?

All the best,
Chris
- -- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUBU23dko1yjaOTJg85AQLPwggAw6zkv1svCb5PToUiwhjwArArlaa/hLjR
n0YgbWpfACpvL0iDrbbEKwIn6cBBOwe/wm5vSF/JoAmgRk8UWkxZrsItjBXt9XjR
Z1O/SJFUjJILxbiKNx4qjEHVKNZfBuPb5fBkcU9iRUzeAXzJUGfC5oWBx29fi187
7G+gJ/axApMdtbNkVyAzRdoS8ehDJgpb95dhxmuSv30d9sYvHlt6k+Ye6ulTO4V2
q2XUQoxTxs5HRACWToZiB5T89GQgJSppLxvRCYlHIYxOpjHvOQDkVvHnIHhVtJhl
ko0TwiQwXNVxwQ825y5T07vhlifWlRx0QHysoqBWP4Qwlfdf1cyjtw==
=xkLU
-----END PGP SIGNATURE-----

