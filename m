Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40807 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab3AXVwr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 16:52:47 -0500
Date: Thu, 24 Jan 2013 16:52:45 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes
Message-ID: <20130124215245.GG10162@shiny.int.fusionio.com>
References: <20130123004833.GA30526@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130123004833.GA30526@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 05:48:33PM -0700, Chris Mason wrote:
> Hi Linus,
> 
> My for-linus branch has our batch of btrfs fixes:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> We've been hammering away at a crc corruption as well, which I was
> really hoping to get into this pull.  It isn't nailed down yet, but we
> were finally able to get a solid way to reproduce.  The only good
> news is it isn't a recent regression.

Update on this, we've tracked down the crc errors and are doing final
checks on the patches.  Linus are you planning on taking this pull?  If
not I can just fold the new stuff into a bigger request.

-chris
