Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:40206 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbJJWOc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 18:14:32 -0400
Subject: Re: btrfs says no errors, but booting gives lots of errors
To: covici@ccs.covici.com,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com>
 <11640.1444488108@ccs.covici.com> <561932EF.2090005@bouton.name>
 <5619385C.7040103@googlemail.com> <16953.1444496102@ccs.covici.com>
Cc: linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel+ceph@bouton.name>
Message-ID: <56198B7B.90806@bouton.name>
Date: Sun, 11 Oct 2015 00:04:43 +0200
MIME-Version: 1.0
In-Reply-To: <16953.1444496102@ccs.covici.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 10/10/2015 18:55, covici@ccs.covici.com a écrit :
> [...]
> But do you folks have any idea about my original question, this leads me
> to think that btrfs is too new or something.

I've seen a recent report of a problem with btrfs-progs 4.2 confirmed as
a bug in mkfs. As you created the filesystem with it, it could be the
problem.
Note that btrfs-progs 4.2 is marked ~amd64 on Gentoo: when you live on
the bleeding edge you shouldn't be surprised to bleed sometimes ;-)

You might have more luck by better describing the errors. Your title
mentions lots of errors, but there's only one log extract in a zip file
for a filesystem being mounted and it's only a warning about lock
contention which from an educated guess seems unlikely to make programs
crash.
I'm not familiar with the 203 exit codes you mention. This seems a
systemd thing with unclear meaning from a quick Google search so it
isn't really helpful unless there are kernel oops or panics for these
errors too.

Lionel
