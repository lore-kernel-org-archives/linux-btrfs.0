Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab3H3XKX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 19:10:23 -0400
Date: Sat, 31 Aug 2013 01:10:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 0/2] btrfs-progs: prevent mkfs from aborting with small
 volume
Message-ID: <20130830231020.GU23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52170114.7060604@jp.fujitsu.com>
 <521B64EA.2080106@redhat.com>
 <521D842D.6020100@jp.fujitsu.com>
 <521F72C6.3040600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <521F72C6.3040600@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 11:11:50AM -0500, Eric Sandeen wrote:
> >> Also, I'm curious - I know the code existed before your patch 2/2,
> >> but I don't understand why it reserves 1MB for the first superblock 
> >> when the first superblock is actually at 64k.  Any idea?
> > 
> > I'm not sure... According to the git-log, this 1M trick is in 
> > the following old commit by Chris:
> > 
> >   commit a6de0bd778475504f42a142c83b8077993cbddfe
> >   Author: Chris Mason <chris.mason@oracle.com>
> >   Date:   Thu Apr 3 16:35:48 2008 -0400
> > 
> >      Add mirroring support across multiple drives
> 
> Yep I saw that too.  Seemingly unrelated.  :(  Unless I'm missing
> something (which I probably am).

IIRC the 1 MB of unused space (minus the first superblock) is there to
avoid random overwrites from paritioners or somesuch. If the whole
megabyte is overwritten including the superblock, the 1st copy lives at
64 MB which exists on practically every fs and the one at 64k can be
retored from it.

david
