Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38518 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2LDHWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2012 02:22:15 -0500
Message-ID: <50BDA49F.5090703@petaramesh.org>
Date: Tue, 04 Dec 2012 08:22:07 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Chris Samuel <chris@csamuel.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Example of BTRFS uglyssima performance : Bitcoin
References: <50BC92F6.6050404@petaramesh.org> <20121203120952.GE7289@carfax.org.uk> <50BC9A1A.9030204@petaramesh.org> <50BD5D5E.5040601@csamuel.org>
In-Reply-To: <50BD5D5E.5040601@csamuel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Le 04/12/2012 03:18, Chris Samuel a écrit :
> In that case maybe using an experimental filesystem that is under rapid
> development might not be a good choice, it might be better to stick to
> one of the existing stable filesystems instead.

I already made the move back and forth ext4 <-> BTRFS twice... Reading
here or there that the new (or the next) kernel is the one that indeed
fixes the bugs (3.3) or gives performance improvements (3.5), or will
make you happy this time, etc...

And each time I'm told that well, the current kernel is not so good
actually, but the next one is so much better ! So you should try the
next beta, or fetch and compile the curent mainline kernel...
...Neverending story...

All this boils down to : I do really need some of the features of BTRFS
(snapshots, checksumming, supposed high reliability...) but I also need
my computers to stay usable on a daily basis without too much hassle and
not spending 3 hours a day beta-testing or upgrading kernels... or
waiting for my mouse click to produce a result.

For getting this result I have a choice between :

- ZFS, that has proven rock-solid, feature-rich and efficient on one of
my machines for 2+ years, but is'nt part of "standard" Linux, will
probably never be, so causes issues at each distro, is tricky installing
as rootfs and which future in Linux is unclear (I don't want to have to
reinstall in 6 months a machine I install now because its filesystem
would end being unsupported...)

- BTRFS, which has already proven that it could kill all my data 3
times, which is badly slow, immature, but part of the standard kernel,
and supposed to improve at a fast pace and have its future ahead.

So basically each time I install a new system, I ask myself : ext4 ?
(but I will lack features I badly need)... ZFS ? (Excellent today, but
will I have to reinstall the machine in 6 months ?)... BTRFS (a slow
unreliable pain in the a** today, but is it this time mature enough that
this bet will make sense ?).

So well... 3.5 is a pain for databases... Now I hope I will be happy in
6 months at next Ubuntu release... If not, maybe in a year... Or a
couple years... Well...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

