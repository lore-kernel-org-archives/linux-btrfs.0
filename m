From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Honest timeline for btrfsck
Date: Wed, 5 Oct 2011 02:16:28 -0400
Message-ID: <20111005061628.GA3702@shiny.elevennetworks.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <4E5FE9FC.9040705@cchtml.com>
 <20110901203442.GA17928@carfax.org.uk>
 <201109101209.40759.Martin@lichtvoll.de>
 <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Putney <jeffrey.putney@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 13, 2011 at 01:01:00PM -0500, Jeff Putney wrote:
> Isn't it about time to make some hard decisions about btrfsck?  Three
> years is enough time to go without this type of functionality in a
> modern filesystem, especially given btrfs's fragility in the face of
> power failures.

So this criticism is well deserved.  I'm juggling a ton of btrfs todos
and not doing a great job at communicating the current status of things.

Currently we have a pretty big queue of changes that I'm integrating for
3.2, and I had to delay btrfsck again so that I could start testing
things.  The merge window is pretty short, and there are some
fantastic changes that deserve to go in.

Inside of Oracle, we've decided to make btrfs the default filesystem for
Oracle Linux.  This is going into beta now and we'll increase our usage
of btrfs in production over the next four to six months.  This is a
really big step forward, but it doesn't cover btrfs in database
workloads (since we recommend asm for that outside of the filesystem).

What this means is that absolutely cannot move forward without btrfsck.
RH, Fujitsu, SUSE and others have spent a huge amount of time on the filesystem
and it is clearly time to start putting it into customer hands.

So over the next two weeks I'm juggling the merge window and the fsck
release.  My goal is to demo fsck at linuxcon europe.  Thanks again for
all of your patience and help with Btrfs!

-chris
