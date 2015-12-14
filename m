Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:52167 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbbLNVa1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 16:30:27 -0500
Subject: Re: btrfs: poor performance on deleting many large files
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
 <pan$eea04$e9596e27$78b44461$c5754723@cox.net>
 <1448488198.4717.4.camel@gmail.com>
 <pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
 <1448562347.8809.16.camel@scientia.net>
 <pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
 <1448582805.11377.9.camel@scientia.net>
 <pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
 <1448683025.6837.4.camel@scientia.net>
 <pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
 <1449958538.15961.3.camel@scientia.net> <566ED124.30803@gmail.com>
 <1450121957.6629.41.camel@scientia.net> <566F261F.4040705@gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <566F34F0.8050407@bouton.name>
Date: Mon, 14 Dec 2015 22:30:24 +0100
MIME-Version: 1.0
In-Reply-To: <566F261F.4040705@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 14/12/2015 21:27, Austin S. Hemmelgarn a écrit :
> AFAIUI, the _only_ reason that that is still the default is because of
> Mutt, and that won't change as long as some of the kernel developers
> are using Mutt for e-mail and the Mutt developers don't realize that
> what they are doing is absolutely stupid.
>

Mutt is often used as an example but tmpwatch uses atime by default too
and it's quite useful.

If you have a local cache of remote files for which you want a good hit
ratio and don't care too much about its exact size (you should have
Nagios/Zabbix/... alerting you when a filesystem reaches a %free limit
if you value your system's availability anyway), using tmpwatch with
cron to maintain it is only one single line away and does the job. For
an example of this particular case, on Gentoo the /usr/portage/distfiles
directory is used in one of the tasks you can uncomment to activate in
the cron.daily file provided when installing tmpwatch.
Using tmpwatch/cron is far more convenient than using a dedicated cache
(which might get tricky if the remote isn't HTTP-based, like an
rsync/ftp/nfs/... server or doesn't support HTTP IMS requests for example).
Some http frameworks put sessions in /tmp: in this case if you want
sessions to expire based on usage and not creation time, using tmpwatch
or similar with atime is the only way to clean these files. This can
even become a performance requirement: I've seen some servers slowing
down with tens/hundreds of thousands of session files in /tmp because it
was only cleaned at boot and the systems were almost never rebooted...

I use noatime and nodiratime on some BTRFS filesystems for performance
reasons: Ceph OSDs, heavily snapshotted first-level backup servers and
filesystems dedicated to database server files (in addition to
nodatacow) come to mind, but the cases where these options are really
useful even with BTRFS doesn't seem to be the common ones.

Finally Linus Torvalds has been quite vocal and consistent on the
general subject of the kernel not breaking user-space APIs no matter
what so I wouldn't have much hope for default kernel mount options
changes...

Lionel
