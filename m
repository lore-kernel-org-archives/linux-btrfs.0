Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:44788 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab2HUDXh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 23:23:37 -0400
Message-ID: <5032FF35.1010407@csamuel.org>
Date: Tue, 21 Aug 2012 13:23:33 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 1/2] Btrfs fixes
References: <20120809155029.GA29278@shiny> <5032EA29.2060002@csamuel.org> <CA+55aFxQiV2iHYQ3NVm=9K=9i6mBo1zwMuvXNrpwnLQwpsRx3A@mail.gmail.com>
In-Reply-To: <CA+55aFxQiV2iHYQ3NVm=9K=9i6mBo1zwMuvXNrpwnLQwpsRx3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/08/12 11:55, Linus Torvalds wrote:

> Read my -rc2 release notes.

Ahh, thanks (I'm not on LKML so didn't see those).

> TL;DR: I rejected big pull requests that didn't convince me. Make a
> damn good case for it, or send minimal fixes instead.

Can't argue with that!

> I'm tried of these "oops, what we sent you for -rc1 wasn't ready, so
> here's a thousand lines of changes" crap.

I can understand that with respect to the send/recv stuff, so it's
really down to Chris Mason to extract just the fixes to problems that
are in 3.5 and earlier and submit just those instead.

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
