Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbbI2JcW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 05:32:22 -0400
Date: Tue, 29 Sep 2015 11:31:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
Message-ID: <20150929093121.GV11442@suse.cz>
Reply-To: dsterba@suse.cz
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150911145638.GP8891@twin.jikos.cz>
 <56034F7B.5050107@cn.fujitsu.com>
 <20150925151951.GI11442@twin.jikos.cz>
 <56064FBA.4000809@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56064FBA.4000809@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 26, 2015 at 03:56:42PM +0800, Qu Wenruo wrote:
> > So can we do it like this:
> >
> > 1) enable support for mixed bg in convert
> > 2) implement mixed -> split conversion in balance
> > 3) force convert to do mixed bgs by default
> >
> > The conversion from/to mixed would be good on it's own but may not be
> > trivial to implement.
> 
> Agreed, and consider it is kernel code, it will be much harder to 
> code/debug.

I've looked into that some time ago. The relocation code seems ready for
that, the data and metadata blocks are filtered separately from the
given chunk and moved to the new chunk. We need to propagate the request
to convert from/to mixed-bg through the balance filters.

> > If the main concern about result of conversion is
> > bad bg layout, I'd say that we rely on balance to reshuffle the bgs to
> > make the filesystem more up to the desired layout.
> 
> That's OK.
> At least we don't need to implement kernel convert support for mixed bg.
> 
> I'll implement both mixed bg and separate one and allow user to choose.
> 
> And for extreme case, if we can't allocate any metadata chunk larger 
> than 16M, either info user and exit or do automatic mixed-bg conversion 
> if no conflicting options.

We can possibly scan the image first for the available holes and then
decide if it's feasible to do the conversion with the requested fs features.
