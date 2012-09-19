Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:27206 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2ISRyl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 13:54:41 -0400
Message-ID: <505A06DE.1050503@petaramesh.org>
Date: Wed, 19 Sep 2012 19:54:38 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: "free space cache generation" ?
References: <50597CD5.5060001@petaramesh.org> <20120919160109.GC2272@localhost.localdomain> <505A013F.8000303@petaramesh.org> <20120919173628.GD2272@localhost.localdomain>
In-Reply-To: <20120919173628.GD2272@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 19/09/2012 19:36, Josef Bacik a écrit :
> It can happen for all sorts of different reasons. Did you have a
> unclean unmount at some point?

Not that I'm aware of...

> Do you have a particularly full file system?

~1 TB FS, 23% full...

Only, I have several Linux distros installed on the same BTRFS  - in
different subvols - so I sometimes mount it with a 3.5.x kernel, and
more rarely - but sometimes - with a 3.2.x...

=> Also I have to mention that I have lost a complete BTRFS FS, that was
a /boot with snapshots. At some point it started to fail mounting, the
kernel complaining that some trees (corresponding to removed snapshots
as far as I could tell) were b0rked, and btrfsck couldn't help...

So I lost the FS - and lost quite a bit of confidence into BTRFS the
same day... :-\


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

