Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaAQN6P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 08:58:15 -0500
Date: Fri, 17 Jan 2014 14:58:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Ivan Jager <aij+@mrph.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Fix bus error on sparc
Message-ID: <20140117135813.GT6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAB5sJHwdf+MmNPfFrrmX7HYnmTjKXY-Wju2db_0i3VQ7A+eMag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB5sJHwdf+MmNPfFrrmX7HYnmTjKXY-Wju2db_0i3VQ7A+eMag@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 16, 2014 at 09:22:57PM -0500, Ivan Jager wrote:
> After patching this I realized Liu Bo had already written a similar
> patch, but I think mine is cleaner, so I'm sending it anyway.

Thanks for taking the time, I like your version better and will replace
Liu Bo's patch in integration branch.

> If you like, I could also change the location->objectid references
> between my two changes, which would make the patch bigger, but would
> make it actually reduce the overall code size slightly.

Not necessary.

> Feel free to make or request any necessary style changes as I couldn't
> find documentation on the coding style for btrfs-tools.

I'ts the same as the kernel coding style, code and people are mostly the
shared.

> PS: Here is the gdb output in case anyone is interested.

It helps to verify how the unaligned access propagated, thanks.

I'll put your analysis as a changelog and the missing Signed-off-by
line from your name + email.
It's the "Developer's Certificate of Origin 1.1", see
http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L307
if you'r not familiar with this practice.


david
