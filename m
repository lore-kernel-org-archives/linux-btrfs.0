Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:56951 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbcJLX4d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 19:56:33 -0400
Date: Wed, 12 Oct 2016 19:47:43 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: Incremental send robustness question
Message-ID: <20161012234743.GA5000@fox.home>
References: <20161012222955.GB2412@fox.home>
 <1bfe5018-3540-319d-813f-32a0571b57d1@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1bfe5018-3540-319d-813f-32a0571b57d1@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 01:14:51AM +0200, Hans van Kranenburg wrote:
> On 10/13/2016 12:29 AM, Sean Greenslade wrote:
> > Hi, all. I have a question about a backup plan I have involving
> > send/receive. As far as I can tell, there's no way to to resume a send
> > that has been interrupted. In this case, my interruption comes from an
> > overbearing firewall that doesn't like long-lived connections. I'm
> > trying to do the initial (non-incremental) sync of the first snapshot
> > from my main server to my backup endpoint. The snapshot is ~900 GiB, and
> > the internet link is 25 Mbps, so this'll be going for quite a long time.
> 
> You can't resume an interrupted send. You'll have to remove the target
> subvolume on the destination and start again.
> 
> Pipe the send into a local file, and then use any tool that can reliably
> resume interrupted transfers to get it to the other side.
> 
> Or, if faster, put in on a disk and drive there with your car. :)

I may just end up doing that. Hugo's responce gave me some crazy ideas
involving a custom build of split that waits for a command after each
output file fills, which would of course require an equally weird build
of cat that would stall the pipe indefinitely until all the files showed
up. Driving the HDD over would probably be a little simpler. =P

> > And while we're at it, what are the failure modes for incremental sends?
> > Will it throw an error if the parents don't match, or will there just be
> > silent failures?
> 
> Create a list of possibilities, create some test filesystems, try it.

I may just do that, presuming I can find the spare time. Given that I'm
building a backup solution around this tech, it would definitely bolster
my confidence in it if I knew what its failure modes looked like.

Thanks to everyone for your fast responses.

--Sean

