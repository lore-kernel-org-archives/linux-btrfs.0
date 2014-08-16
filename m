Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55487 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaHPPLm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 11:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <53EE42A9.7000607@fb.com>
References: <53EE42A9.7000607@fb.com>
Date: Sat, 16 Aug 2014 09:11:41 -0600
Message-ID: <CA+55aFz-aSbmLoZv=CGY1bXpQ1zE935-FjTLMZF5=5hteyf9kg@mail.gmail.com>
Subject: Re: [GIT PULL] Smaller btrfs pull
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 15, 2014 at 11:26 AM, Chris Mason <clm@fb.com> wrote:
>
> I've been running xfstests with these against your current git
> overnight, but I'm queueing up longer tests as well.  I understand
> you may want to wait until rc2, but either way I'll get a sane queue
> into my linux-next branch for the rest of the rcs.

You completely mis-understand.

If something isn't appropriate for the merge window, then it sure as
HELL isn't appropriate for later rc's either.

So I'm not going to pull some "stragglers" later and just pull some
initial stuff now. That's not how this works.

The changes for the merge window should have been ready *before* the
merge window even opened. That has always been the rule. We don't do
random development and re-organization during the merge window, and we
certainly do not do it *later*.

I'm going to pull this reduced set, but that in no way means that I
will then pull later sets after the merge window.  The stuff after the
merge window should be pure fixes, and I'm in fact going to be
stricter with btrfs than usual, because I think this was such a
disaster. Oopses, regressions, data corruption, security fixes, and
things like that *only*. No cleanups, no random crap, nothing that
doesn't count as critical.

               Linus
