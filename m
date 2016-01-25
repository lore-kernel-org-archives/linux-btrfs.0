Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:49685 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbcAYXQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 18:16:19 -0500
Date: Tue, 26 Jan 2016 10:16:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, linux-next@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Add my git tree for linux-next
Message-ID: <20160126101616.682677d4@canb.auug.org.au>
In-Reply-To: <20160125182445.GA8567@twin.jikos.cz>
References: <20160125182445.GA8567@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On Mon, 25 Jan 2016 19:24:45 +0100 David Sterba <dsterba@suse.cz> wrote:
>
> please add my git tree to linux-next branches
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> 
> It's not populated yet, I'm planning to add namely other developer
> patchsets (targeting the next release cycle) as I'm able to review them.
> I won't track all pending patchsets nor all single patches that go to
> the mailinglist, due to time reasons.

What subsystem will these patches relate to? (just btrfs)?  Will you be sending pull
requests?  To whom? (Chris and Josef)?  If so, how will this be
different to the current btrfs tree?

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
