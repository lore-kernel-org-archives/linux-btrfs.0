From: David Sterba <dave@jikos.cz>
Subject: Re: Warnings (was: Re: new integration-danger branch pushed out (kernel))
Date: Wed, 2 Nov 2011 14:06:37 +0100
Message-ID: <20111102130637.GK12759@twin.jikos.cz>
References: <20111101024957.GH4468@shiny> <20111101101110.GB12759@twin.jikos.cz> <20111102005615.GF15027@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, David Sterba <dave@jikos.cz>,
	linux-btrfs@vger.kernel.org, josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111102005615.GF15027@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 08:56:15PM -0400, Chris Mason wrote:
> > xfstests/083 and 089 cause the following warnings. I've seen them before when
> > testing josef/for-chris and josef/master branches (reported on irc).
> 
> Ok, just a status update on my end.  Josef and I have the block group
> warnings fixed.

I confirm the warnings do not show anymore with the "Btrfs: release
metadata from global reserve if we have to fallback for unlink" patch.

> The tree log crash is also explained, the eexist oops
> comes when you're using the inode_cache code (hopefully you are?).

yes,

MOUNT_OPTIONS='-o compress=lzo,discard,inode_cache,space_cache,autodefrag'

> I have one test fix for this but it still has a few wrinkles that I'll
> have to sort out in the morning.

Great, I'm ready to test it.


david
