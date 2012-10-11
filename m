Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:44593 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030247Ab2JKUuy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 16:50:54 -0400
Message-ID: <0a76c1f5c0474ef27b0863f93aeaf41d.squirrel@webmail.psioc.net>
In-Reply-To: <20121009152153.GU4405@twin.jikos.cz>
References: <1349723270-12773-1-git-send-email-mail@dieterries.net>
    <1349723270-12773-4-git-send-email-mail@dieterries.net>
    <20121009152153.GU4405@twin.jikos.cz>
Date: Thu, 11 Oct 2012 22:50:51 +0200
Subject: Re: [PATCH 3/4] btrfs-progs: btrfsck: Print feedback about fscking
 to stdout.
From: mail@dieterries.net
To: dave@jikos.cz
Cc: "Dieter Ries" <mail@dieterries.net>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> I agree that the important messages from fsck process should be printed
> to stdout, and the rest like 'cannot find a valid fs on /dev' belong to
> stderr so the user can simply call
>
>   btrfsck > logfile
>
> and does not miss any messages in the log, while will be informed that
> the process cannot proceed for some urgent reason.

That's what I thought as well. I started small, but IMHO, a lot of the
output of btrfsck should go to stdout instead of stderr

Is there a general agreement on that for a fsck utility, it is normal
output, if the filesystem is damaged, and really only stuff which makes
the checking stop abnormally should go to stderr?

Also, right now there is a very mixed level of verbosity used. I was
thinking about adding a '-v' option, and making some of the output
conditional on that. The normal enduser will not really care about the
number of csum bytes, and as a dev you can still alias the -v.

> I think doing the stdout/stderr split properly would need more than
> fixing btrfsck.c, it uses code from other .c files, looks like an
> overhaul of the logging in the whole codebase.

I haven't looked into many other files there, but maybe you are right. I
started with btrfsck.c because I think it's a nice entry point.

> david

Cheers,

Dieter

