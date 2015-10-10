Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:51027 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbJJXVc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 19:21:32 -0400
Subject: Re: btrfs says no errors, but booting gives lots of errors
To: covici@ccs.covici.com
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com>
 <11640.1444488108@ccs.covici.com> <561932EF.2090005@bouton.name>
 <5619385C.7040103@googlemail.com> <16953.1444496102@ccs.covici.com>
 <56198B7B.90806@bouton.name> <27402.1444518173@ccs.covici.com>
Cc: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56199D79.4000204@bouton.name>
Date: Sun, 11 Oct 2015 01:21:29 +0200
MIME-Version: 1.0
In-Reply-To: <27402.1444518173@ccs.covici.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/10/2015 01:02, covici@ccs.covici.com a écrit :
> Lionel Bouton <lionel+ceph@bouton.name> wrote:
>
>> Le 10/10/2015 18:55, covici@ccs.covici.com a écrit :
>>> [...]
>>> But do you folks have any idea about my original question, this leads me
>>> to think that btrfs is too new or something.
>> I've seen a recent report of a problem with btrfs-progs 4.2 confirmed as
>> a bug in mkfs. As you created the filesystem with it, it could be the
>> problem.
>> Note that btrfs-progs 4.2 is marked ~amd64 on Gentoo: when you live on
>> the bleeding edge you shouldn't be surprised to bleed sometimes ;-)
>>
>> You might have more luck by better describing the errors. Your title
>> mentions lots of errors, but there's only one log extract in a zip file
>> for a filesystem being mounted and it's only a warning about lock
>> contention which from an educated guess seems unlikely to make programs
>> crash.
>> I'm not familiar with the 203 exit codes you mention. This seems a
>> systemd thing with unclear meaning from a quick Google search so it
>> isn't really helpful unless there are kernel oops or panics for these
>> errors too.
> These errors are not kernel panicks, they are just that systemd units
> are not starting and the programs that  are executed in the unit files
> are returning these errors such as the 203 with no other explanation.  I
> tried for instance to run /usr/bin/postgresql-9.4-check-db-dir and it
> said that postgresql.conf was missing, but I could do an ls on that file
> and got the name.

If you can list files and read them, your problems probably have nothing
to do with the filesystem itself.

Lionel
