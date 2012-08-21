Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:57121 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2HUNKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 09:10:17 -0400
Date: Tue, 21 Aug 2012 09:10:14 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Samuel <chris@csamuel.org>, "Chris L. Mason" <clmason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 1/2] Btrfs fixes
Message-ID: <20120821131014.GA1722@shiny>
References: <20120809155029.GA29278@shiny>
 <5032EA29.2060002@csamuel.org>
 <CA+55aFxQiV2iHYQ3NVm=9K=9i6mBo1zwMuvXNrpwnLQwpsRx3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+55aFxQiV2iHYQ3NVm=9K=9i6mBo1zwMuvXNrpwnLQwpsRx3A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 20, 2012 at 07:55:59PM -0600, Linus Torvalds wrote:
> On Mon, Aug 20, 2012 at 6:53 PM, Chris Samuel <chris@csamuel.org> wrote:
> >
> > This pull request with a whole heap of btrfs fixes (46 commits) appears
> > not to have been merged yet, does anyone know if it was rejected or just
> > missed ?
> 
> Read my -rc2 release notes.
> 
> TL;DR: I rejected big pull requests that didn't convince me. Make a
> damn good case for it, or send minimal fixes instead.
> 
> I'm tried of these "oops, what we sent you for -rc1 wasn't ready, so
> here's a thousand lines of changes" crap.

When just the second pull went in, I wasn't sure if it was waiting for
vacation or you felt it was too big, but when I saw rc2 it was pretty
clear.

So I'm working up an rc3 pull with longer explanations.  The bulk of my
last pull was send/receive fixes.  The rc1 send/recv worked fine for me
on my test box, but larger scale use on well aged filesystems showed
some problems.

It's fair to say send/receive wasn't ready.  I did expect some fixes for
rc2 but not that many.  More details will be in my pull this afternoon,
but with our current code it is working very well for me.

-chris

