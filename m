From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] new free space caching stuff
Date: Fri, 22 May 2009 10:11:34 -0400
Message-ID: <20090522141133.GA8762@think>
References: <20090521184351.GC11101@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090521184351.GC11101@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2009 at 02:43:52PM -0400, Josef Bacik wrote:
> Hello,
> 
> Okay I'm looking at redoing all of this stuff again, and I'd like to make this
> the last time, so I'm going to outline what we currently have, what the problems
> are with it, and what I want to do.  I would appreciate any/all input so I can
> try and get this right the first time.
> 

Josef and I hashed this out someone on IRC.  I think the bitmaps alone
aren't going to scale all that well for huge filesystems, so he is
looking into a hybrid bitmap/extent approach based on the size of the
free space.

-chris
