Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab3CCQdH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Mar 2013 11:33:07 -0500
Date: Sun, 3 Mar 2013 17:33:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Eric Sandeen <sandeen@redhat.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: usage should match what is coded
Message-ID: <20130303163303.GY27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362132602-29501-1-git-send-email-anand.jain@oracle.com>
 <1362132602-29501-2-git-send-email-anand.jain@oracle.com>
 <5130E9C6.6000704@redhat.com>
 <20130301180521.GO14283@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130301180521.GO14283@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 01, 2013 at 06:05:21PM +0000, Hugo Mills wrote:
> On Fri, Mar 01, 2013 at 11:47:50AM -0600, Eric Sandeen wrote:
> > On 3/1/13 4:10 AM, Anand Jain wrote:
> > > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > 
> > Revieed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > But the curious side of me wonders how it got this way.
> > 
> > commit e43cc461550130494194201037590a2b1f0f6880
> > Author: Ian Kumlien <pomac@demius.net>
> > Date:   Fri Feb 8 01:37:02 2013 +0100
> > 
> >     Btrfs-progs: add restore command to btrfs
> > 
> > added the usage text below, but didn't change the getopt
> > or add code to handle them.
> > 
> > No idea where it came from, it wasn't in the standalone
> > restore either.  *shrug*  I guess nothing got lost.
> 
>    -m was definitely a thing at some point, as I recall using it. I
> think the code was in josef's progs tree. I suspect the other options
> were part of that, too. (And -m was definitely really useful for me).

My fault here, I cherry-picked Ian's commit from a branch with Josef's
updates to restore (adding all the commandline options). I'll pick
Anand's fix to keep help and functionality matching. The updates to
restore are wanted, but as they are based on an old progs version it's
not all trivial to merge them.

david
