Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51234 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2HUB4V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 21:56:21 -0400
MIME-Version: 1.0
In-Reply-To: <5032EA29.2060002@csamuel.org>
References: <20120809155029.GA29278@shiny> <5032EA29.2060002@csamuel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Aug 2012 18:55:59 -0700
Message-ID: <CA+55aFxQiV2iHYQ3NVm=9K=9i6mBo1zwMuvXNrpwnLQwpsRx3A@mail.gmail.com>
Subject: Re: [GIT PULL 1/2] Btrfs fixes
To: Chris Samuel <chris@csamuel.org>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 20, 2012 at 6:53 PM, Chris Samuel <chris@csamuel.org> wrote:
>
> This pull request with a whole heap of btrfs fixes (46 commits) appears
> not to have been merged yet, does anyone know if it was rejected or just
> missed ?

Read my -rc2 release notes.

TL;DR: I rejected big pull requests that didn't convince me. Make a
damn good case for it, or send minimal fixes instead.

I'm tried of these "oops, what we sent you for -rc1 wasn't ready, so
here's a thousand lines of changes" crap.

             Linus
