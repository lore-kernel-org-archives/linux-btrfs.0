Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50877 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbcJIXda (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 19:33:30 -0400
Date: Mon, 10 Oct 2016 10:32:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: dsterba@suse.cz, Tim Small <tim@seoss.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Making statfs return qgroup info (for container use case etc.)
Message-ID: <20161009233251.GZ27872@dastard>
References: <32dfef18-ca3b-6c29-252a-4fc9e36b373a@seoss.co.uk>
 <20161006224011.GF9806@dastard>
 <20161007165847.GG11398@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161007165847.GG11398@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2016 at 06:58:47PM +0200, David Sterba wrote:
> On Fri, Oct 07, 2016 at 09:40:11AM +1100, Dave Chinner wrote:
> > XFS does this with directory tree quotas. It was implmented 10 years
> > ago or so, IIRC...
> 
> Sometimes, the line between a historical remark and trolling is thin....

All I've done is quickly point out that we've already got an
implementation of the exact functionality being asked for and given
a rough indication of when the commits hit the tree. i.e. so anyone
wanting to implment this in btrfs can search for it easily and work
out how to use the existing VFS infrastructure to report this
information.

You can take that as trolling if you want, but if you think I have
time for playing stupid, petty, idiotic games like that then you
need to ask yourself why you have had such a defensive and
paranoid reaction...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
