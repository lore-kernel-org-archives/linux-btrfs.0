Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37406 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3HRDZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 23:25:48 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so1074901bkb.31
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 20:25:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130817115901.17880.38963@localhost.localdomain>
References: <pan$926b0$b4061d31$38c7ab48$19af94f0@cox.net> <20130817115901.17880.38963@localhost.localdomain>
From: Tom Gundersen <teg@jklm.no>
Date: Sun, 18 Aug 2013 11:25:26 +0800
Message-ID: <CAG-2HqWDqjS2Er8FvwwgTkfMjoouwvjQeipHy_+ia7iTTfT==w@mail.gmail.com>
Subject: Re: Question: btrfs-progs releases?
To: Chris Mason <chris.mason@fusionio.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 17, 2013 at 7:59 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> The problem with the progs release is I keep finding more things I want
> to add.  My local git tree has about a dozen commits that I feel are
> important enough for v1.0.  I just have to cut it, the distros and
> others are completely correct in asking for an official release.

I know this feeling too well.

In order to just "get something out", it might make sense to just do
some time-based releases every now and again (and maybe call them 0.X,
rather than 1.0 until you are happy). Even the occasional (maybe after
each kernel release) git tag (without actually creating tarballs etc)
would be very helpful, as at least we would have a common reference
point for bug reports and similar (and after all, numbers are cheap
;-)).

>From your point of view, having frequent releases will also (I
suppose) be helpful as it will make sure your users/testers are using
the most recent version (at least in Arch, whatever you tag we will
ship within a few days) and hence you won't have to ask them to
rebuild from git to make sure the bug hasn't already been fixed.

> In terms of the quality of the commits, I only put things into the
> master branch of the git tree that I have fully confidence in.

Thanks for the info Chris, this is useful to know. I'll keep pushing
git snapshots then (but as I said, tags would be better).

-t
