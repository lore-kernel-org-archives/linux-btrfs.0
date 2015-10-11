Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:44692 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbbJKA3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 20:29:04 -0400
From: covici@ccs.covici.com
To: Lionel Bouton <lionel-subscription@bouton.name>
cc: =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FHolger=5FHoffst=3Dc3=3Da4tte=3F=3D?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs says no errors, but booting gives lots of errors
In-reply-to: <5619A615.3090503@bouton.name>
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com> <11640.1444488108@ccs.covici.com> <561932EF.2090005@bouton.name> <5619385C.7040103@googlemail.com> <16953.1444496102@ccs.covici.com> <56198B7B.90806@bouton.name> <27402.1444518173@ccs.covici.com> <56199D79.4000204@bouton.name> <28329.1444519978@ccs.covici.com> <5619A615.3090503@bouton.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Date: Sat, 10 Oct 2015 20:28:59 -0400
Message-ID: <29851.1444523339@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lionel Bouton <lionel-subscription@bouton.name> wrote:

> Le 11/10/2015 01:32, covici@ccs.covici.com a écrit :
> > [...]
> > I don't know if the file in question had the correct data, I only did a
> > directory listing, but this makes no sense -- I did an rsync just before
> > booting and got all kinds of errors and the only difference is the file
> > system, this is what I am saying.
> 
> What makes no sense is that the same filesystem both shows the file is
> there and isn't. If there was data corruption or buggy behaviour at
> least it should be somehow consistent.
> What is more likely is that the rsync was incomplete and didn't transfer
> some data needed by systemd: did you transfer (from the top of my head)
> extended attributes, special files, device files ? By default rsync
> doesn't do that.

The only thing I transferred that was unusual is hard links.  Otherwise
it was just
rsync --progress -avhH --numeric-ids followed by the various source
directories root file system to a subvolume rootfs, /usr to a subvolume
called usr, var to a subvolume called var and home to  a subvolume
called home.  And what is more confusing, I did check the contents of
postgresql.conf and they matched exactly, the one on my ext4 system and
the one on the btrfs file system -- so I don't know why the check
program gave that message.  Also, another thing which was not consistent
is that in my first boot mysql service did not start, but it did in
subsequent boots.  Now, I did not transfer anything under /var/run as
its linked to /run, same for /var/lock as its linked to /run/lock.
Device files, I did not transfer anythin specific, I would think udev
would create those under /dev.  In this case, I wish I were doing
something dumb, it would not be fun, but  at least I could proceed and I
could run with the system.


-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
