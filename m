Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47073 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdJTNrB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 09:47:01 -0400
Date: Fri, 20 Oct 2017 15:45:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v8 0/6] Btrfs: populate heuristic with code
Message-ID: <20171020134511.GQ3521@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
 <20170929162200.GP31640@twin.jikos.cz>
 <20171019153940.GL3521@twin.jikos.cz>
 <CAGqmi75Zz=RqsOymdFOHwHNE7X+2G3Viiitmq+ZROurBOon=FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi75Zz=RqsOymdFOHwHNE7X+2G3Viiitmq+ZROurBOon=FQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 01:48:01AM +0300, Timofey Titovets wrote:
> 2017-10-19 18:39 GMT+03:00 David Sterba <dsterba@suse.cz>:
> > On Fri, Sep 29, 2017 at 06:22:00PM +0200, David Sterba wrote:
> >> On Thu, Sep 28, 2017 at 05:33:35PM +0300, Timofey Titovets wrote:
> >> > Compile tested, hand tested on live system
> >> >
> >> > Change v7 -> v8
> >> >   - All code moved to compression.c (again)
> >> >   - Heuristic workspaces inmplemented another way
> >> >     i.e. only share logic with compression workspaces
> >> >   - Some style fixes suggested by Devid
> >> >   - Move sampling function from heuristic code
> >> >     (I'm afraid of big functions)
> >> >   - Much more comments and explanations
> >>
> >> Thanks for the update, I went through the patches and they looked good
> >> enough to be put into for-next. I may have more comments about a few
> >> things, but nothing serious that would hinder testing.
> >
> > I did a final pass through the patches and edited comments wehre I was
> > not able to undrerstand them. Please check the updated patches in [1] if
> > I did not accidentally change the meaning.
> 
> I don't see a link [1] in mail, may be you missed it?

Yeah, sorry:
https://github.com/kdave/btrfs-devel/commits/ext/timofey/heuristic
