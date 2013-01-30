Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:62842 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3A3Udo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 15:33:44 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so1452103lab.9
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 12:33:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359500633-7219-2-git-send-email-pomac@demius.net>
References: <1359500633-7219-1-git-send-email-pomac@demius.net>
	<1359500633-7219-2-git-send-email-pomac@demius.net>
Date: Wed, 30 Jan 2013 12:33:42 -0800
Message-ID: <CADU+-uCUUCeSxLSwE_s+-e0XtfUE9NG4Xb5Vn2WkTWgNLmMjnQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] include btrfsck in btrfs - including "name check"
From: Filipe Brandenburger <filbranden@google.com>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ian,

On Tue, Jan 29, 2013 at 3:03 PM, Ian Kumlien <pomac@demius.net> wrote:
> This patch includes fsck as a subcommand of btrfs, but if you rename
> the binary to btrfsck (or, preferably, use a symlink) it will act like
> the old btrfs command.

You can rename files in your git (there's "git mv" for that), only
thing is when you generate the patch with format-patch (or "git show",
"git diff" etc.) pass it the -M option to detect moves and act
appropriately.

Regarding your patches, I really like the idea of "btrfs fsck" but I
think I'd prefer to keep the external commands as wrapper scripts
instead of adding busybox-style name detection to btrfs... But then,
that's just my opinion.

I guess I would have a "btrfsck" that would simply contain:

    #! /bin/sh
    exec btrfs fsck "$@"

Downside is that error reporting (e.g. invalid syntax, etc.) would
show "btrfs fsck" instead of the command the user actually typed...

Cheers,
Filipe
