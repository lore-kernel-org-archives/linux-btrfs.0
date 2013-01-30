Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:49202 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3A3V7K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 16:59:10 -0500
Received: by mail-ea0-f179.google.com with SMTP id d12so904640eaa.24
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 13:59:08 -0800 (PST)
Date: Wed, 30 Jan 2013 23:59:05 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Ian Kumlien <pomac@vapor.com>
Cc: Filipe Brandenburger <filbranden@google.com>,
        Ian Kumlien <pomac@demius.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] [RFC] include btrfsck in btrfs - including "name check"
Message-ID: <20130130215905.GA2031@zambezi.lan>
References: <1359500633-7219-1-git-send-email-pomac@demius.net>
 <1359500633-7219-2-git-send-email-pomac@demius.net>
 <CADU+-uCUUCeSxLSwE_s+-e0XtfUE9NG4Xb5Vn2WkTWgNLmMjnQ@mail.gmail.com>
 <20130130211144.GJ15780@pomac.netswarm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130130211144.GJ15780@pomac.netswarm.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 10:11:44PM +0100, Ian Kumlien wrote:
> On Wed, Jan 30, 2013 at 12:33:42PM -0800, Filipe Brandenburger wrote:
> > Hi Ian,
> > 
> > On Tue, Jan 29, 2013 at 3:03 PM, Ian Kumlien <pomac@demius.net> wrote:
> > > This patch includes fsck as a subcommand of btrfs, but if you rename
> > > the binary to btrfsck (or, preferably, use a symlink) it will act like
> > > the old btrfs command.
> > 
> > You can rename files in your git (there's "git mv" for that), only
> > thing is when you generate the patch with format-patch (or "git show",
> > "git diff" etc.) pass it the -M option to detect moves and act
> > appropriately.
> 
> git send-email seems to send the full diff, diffing against /dev/null =P
> This is why i skipped that part.
> 
> > Regarding your patches, I really like the idea of "btrfs fsck" but I
> > think I'd prefer to keep the external commands as wrapper scripts
> > instead of adding busybox-style name detection to btrfs... But then,
> > that's just my opinion.
> 
> Well, now both works.
> 
> > I guess I would have a "btrfsck" that would simply contain:
> > 
> >     #! /bin/sh
> >     exec btrfs fsck "$@"
> > 
> > Downside is that error reporting (e.g. invalid syntax, etc.) would
> > show "btrfs fsck" instead of the command the user actually typed...
> 
> Actually it still does, due to how btrfs handles things... It's a simple
> enough fix and it will make rescue cd's or dracut images, or just about
> anything.
> 
> I understand your point, but i think this is a simpler solution =)

FWIW I agree with Filipe, this name detection thing looks ugly to me.
The merge itself is a good idea, but I think we should stick with shell
wrappers for everything else.

Thanks,

		Ilya
