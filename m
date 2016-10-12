Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:48186 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932827AbcJLXPZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 19:15:25 -0400
Subject: Re: Incremental send robustness question
To: Sean Greenslade <sean@seangreenslade.com>,
        Btrfs List <linux-btrfs@vger.kernel.org>
References: <20161012222955.GB2412@fox.home>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1bfe5018-3540-319d-813f-32a0571b57d1@mendix.com>
Date: Thu, 13 Oct 2016 01:14:51 +0200
MIME-Version: 1.0
In-Reply-To: <20161012222955.GB2412@fox.home>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/13/2016 12:29 AM, Sean Greenslade wrote:
> Hi, all. I have a question about a backup plan I have involving
> send/receive. As far as I can tell, there's no way to to resume a send
> that has been interrupted. In this case, my interruption comes from an
> overbearing firewall that doesn't like long-lived connections. I'm
> trying to do the initial (non-incremental) sync of the first snapshot
> from my main server to my backup endpoint. The snapshot is ~900 GiB, and
> the internet link is 25 Mbps, so this'll be going for quite a long time.

You can't resume an interrupted send. You'll have to remove the target
subvolume on the destination and start again.

Pipe the send into a local file, and then use any tool that can reliably
resume interrupted transfers to get it to the other side.

Or, if faster, put in on a disk and drive there with your car. :)

At the receiving side, cat the file into btrfs receive.

> What I would like to do is "fake" the first snapshot transfer by
> rsync-ing the files over. So my question is this: if I rsync a subvolume
> (with the -a option to make all file times, permissions, ownerships,
> etc. the same), is that good enough to then be used as a parent for
> future incremental sends?

No. btrfs send/receive works on a different level than rsync. Because
btrfs internally tags all things that happen with a "generation" number,
it can compare two snapshots which were taken from the same subvolume at
different moments, and just walk the btrees and see which parts of it
were updated between the previous and current snapshot.

The first send needs a read-only snapshot of a subvolume and if that one
made it to the remote, you can send incrementals by taking another read
only snapshot and letting btrfs decide what changed between them very
efficiently.

That's why btrfs send -p can do very fast transfers of differences for
snapshots, while rsync would need to compare all metadata of all files
over and over again.

> And while we're at it, what are the failure modes for incremental sends?
> Will it throw an error if the parents don't match, or will there just be
> silent failures?

Create a list of possibilities, create some test filesystems, try it.

> I would imagine receive would barf if it was told to
> reference a file that didn't exist, but what if the referenced file is
> there but contains different data? Are there checks for this sort of
> thing, or is it always assumed that the parent subvols are identical and
> if they're not, you're in undefined behavior land?

btrfs send/receive is not rsync :-)

-- 
Hans van Kranenburg
