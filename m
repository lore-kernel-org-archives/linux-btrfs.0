Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54255 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752642AbdJSPl2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 11:41:28 -0400
Date: Thu, 19 Oct 2017 17:39:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 0/6] Btrfs: populate heuristic with code
Message-ID: <20171019153940.GL3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
 <20170929162200.GP31640@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170929162200.GP31640@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 06:22:00PM +0200, David Sterba wrote:
> On Thu, Sep 28, 2017 at 05:33:35PM +0300, Timofey Titovets wrote:
> > Compile tested, hand tested on live system
> > 
> > Change v7 -> v8
> >   - All code moved to compression.c (again)
> >   - Heuristic workspaces inmplemented another way
> >     i.e. only share logic with compression workspaces
> >   - Some style fixes suggested by Devid
> >   - Move sampling function from heuristic code
> >     (I'm afraid of big functions)
> >   - Much more comments and explanations
> 
> Thanks for the update, I went through the patches and they looked good
> enough to be put into for-next. I may have more comments about a few
> things, but nothing serious that would hinder testing.

I did a final pass through the patches and edited comments wehre I was
not able to undrerstand them. Please check the updated patches in [1] if
I did not accidentally change the meaning.

I'm about to add the patchset to the main patch pile for 4.15 soon.
Further tuning is possible and such patches will be probably accepted
during the 4.15 development cycle once the as parts have landed. It's
desirable to gather some testing results of heuristic effects on various
data types. So far I've been watching for performance drops only.

In case the heuristic would turn out to cause problems we can't fix
during 4.15 cycle, we can still disable it. This is only a last resort
measure but we need to be prepared.
