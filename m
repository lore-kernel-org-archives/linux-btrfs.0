Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36354 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2IGTgn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2012 15:36:43 -0400
Received: by wibhr14 with SMTP id hr14so131743wib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2012 12:36:42 -0700 (PDT)
Message-ID: <504A4CBF.7000605@gmail.com>
Date: Fri, 07 Sep 2012 21:36:31 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Cannot create subvolume with quota enabled
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

The following steps reproduce the error. My kernel is 3.6-rc4 and
btrfs-progs are at commit 89fe5b5f666c247aa3173745fb87c710f3a71a4a from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
master.

thor ~ # mkfs.btrfs -L test /dev/vg1/test

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label test on /dev/vg1/test
        nodesize 4096 leafsize 4096 sectorsize 4096 size 20.00GB
Btrfs Btrfs v0.19
thor ~ # mount /dev/vg1/test /mnt/tmp
thor ~ # btrfs quota enable /mnt/tmp
thor ~ # btrfs subvolume create /mnt/tmp/test
Create subvolume '/mnt/tmp/test'
ERROR: cannot create subvolume - Invalid argument

Please, do not hesitate to contact me for any further information etc.

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQSky/AAoJEIW3W1BiBxU7/AIH/0K+FRSFl619SKnSrpiib+wk
5Rf+R9mjMn9yateRbhtblBF5KuWfGELO8w7okf6Mg6L/wCD7fYFuwo8Gwm7RvG/T
lBrOCRPvrdkT78+elX/Jaj1QKWcYkTz7bkpcXf57zdzLruO1VwF0aCQZOFDR/qD2
d3oI5OCc/3Qw9G0ZnqV/z+bT3oqJRPJBV4ihB1SSI+5YpCAtHBW1jFGfwWRuA+ZV
Q+iPPjMKZALG6wQYu+4WG5M1l9pC9y/aRetBfWplQTVgfT4Hh3eZjvq6OnDv9ZiO
rWLSTqG0uBRCW2Sws0uFpPKMod0RFWm0sJNfkzGAM6O3a15CGTPnA9Hq0SgMRL4=
=pr3t
-----END PGP SIGNATURE-----
