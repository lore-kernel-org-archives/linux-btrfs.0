Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaKXS1f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 13:27:35 -0500
Date: Mon, 24 Nov 2014 19:27:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs deadlock fix
Message-ID: <20141124182734.GE26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141123151439.GA16816@ret.masoncoding.com>
 <20141124173909.GC26471@twin.jikos.cz>
 <1416852070.3019.5@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416852070.3019.5@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 01:01:10PM -0500, Chris Mason wrote:
> > I've retested it again including this pull and still deadlocks 
> > reliably
> > at btrfs/070.
> 
> This wasn't a new problem, so I had it queued for the merge window.

Well, I don't remember seeing this problem with anything 3.17 based but
I can check. I know this does not mean that it was introduced in 3.18,
only that other changes exposed the problem, but this still IMHO
qualifies as a bug to be fixed within 3.18. Besides, it makes testing
3.18-rc slightly more annoying (either skip the test or manually pick
the patch after each pull).
