Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbcIIOCh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 10:02:37 -0400
Date: Fri, 9 Sep 2016 16:00:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Lukas Lueg <lukas.lueg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: State of the fuzzer
Message-ID: <20160909140059.GT16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJF-kYmnBt6yRLJ+R3HdJ03oqp_ptwXpat40vXoD_b=MUvJZUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJF-kYmnBt6yRLJ+R3HdJ03oqp_ptwXpat40vXoD_b=MUvJZUw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2016 at 10:32:28PM +0200, Lukas Lueg wrote:
> I'm currently fuzzing rev 2076992 and things start to slowly, slowly
> quiet down. We will probably run out of steam at the end of the week
> when a total of (roughly) half a billion BTRFS-images have passed by.
> I will switch revisions to current HEAD and restart the whole process
> then. A few things:
> 
> * There are a couple of crashes (mostly segfaults) I have not reported
> yet. I'll report them if they show up again with the latest revision.

Ok.

> * The coverage-analysis shows assertion failures which are currently
> silenced. An assertion failure is technically a worse disaster
> successfully prevented, it still constitutes unexpected/unusable
> behaviour, though. Do you want assertions to be enabled and images
> triggering those assertions reported? This is basically the same
> conundrum as with BUG_ON and abort().

Yes please. I'd like to turn most bugons/assertions into a normal
failure report if it would make sense.

> * A few endless loops entered into by btrfsck are currently
> unmitigated (see bugs 155621, 155571, 155551 and 155151). It would be
> nice if those had been taken care of by next week if possible.

Two of them are fixed, the other two need more work, updating all
callers of read_node_slot and the callchain. So you may still see that
kind of looping in more images. I don't have an ETA for the fix, I won't
be available during the next week.

At the moment, the initial sanity checks should catch most of the
corrupted values, so I'm expecting that you'll see different classes of
problems in the next rounds.

The testsuite now contains all images that you reported and we have a
fix in git. There are more utilities run on the images, there may be
more problems for us to fix.
