Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3LKQhF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 11:37:05 -0500
Date: Wed, 11 Dec 2013 17:37:04 +0100
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs integration branch versioning
Message-ID: <20131211163704.GI10658@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CALOYprXUt5DqRHWX0jvF8t3mLssiHVW46bXF7gW930hfyMuDUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprXUt5DqRHWX0jvF8t3mLssiHVW46bXF7gW930hfyMuDUw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 11, 2013 at 03:59:48PM +0000, WorMzy Tykashi wrote:
> It's not a big deal, but I've just noticed that the most recent
> unstable-integration btrfs tools (built from [1]) are still reporting
> their version as v0.20-rc1-638-g8e44385, rather than
> v3.12-xxx-xxxxxxxx. I believe this is because the master branch in the
> devel repository has not been tagged with the new version.
>
> The github clone/mirror(?) of the devel repository [2] has no tags for
> some reason, and the btrfs tools built from it report their version
> simply as v0.20-rc1 or v3.12 (depending on which branch you check
> out).

Sorry, I haven't pushed the tags, fixed now. The repos are mostly
identical to increase availability.

david
