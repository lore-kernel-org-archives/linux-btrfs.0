Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51699 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3CCBKb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2013 20:10:31 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B28F57C0416
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Mar 2013 18:10:30 -0700 (MST)
Date: Sat, 2 Mar 2013 20:10:28 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20130303011028.GA11322@shiny.masoncoding.com>
References: <20130302151535.GD28634@shiny.masoncoding.com>
 <CA+55aFy6cUszGy2=afEP5BzotFLZoH1oSi5Hjr6Kk2PkvKg_kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+55aFy6cUszGy2=afEP5BzotFLZoH1oSi5Hjr6Kk2PkvKg_kQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 02, 2013 at 05:45:41PM -0700, Linus Torvalds wrote:
> On Sat, Mar 2, 2013 at 7:15 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > Our set of btrfs features, fixes and cleanups are in my for-linus
> > branch:
> 
> I *really* wish that big pull requests like this would come in earlier
> in the merge window. I hate seeing them the day before I close the
> window - really.  A number of the latter commits are done in the last
> few days, which also smells bad.

Definitely, I wanted to send this earlier in the merge window.  But I
was out last week and also didn't want to send the big stuff (raid 5/6
and the fsync work) to you right before I left on vacation.

So instead I sent things off to linux-next, and everyone on the btrfs
list collected fixes while I was gone.

-chris
