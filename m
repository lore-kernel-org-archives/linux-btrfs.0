Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaFJLFL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 07:05:11 -0400
Date: Tue, 10 Jun 2014 13:05:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Hesse <mail@eworm.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fix compiler warning
Message-ID: <20140610110506.GI1903@suse.cz>
Reply-To: dsterba@suse.cz
References: <1401794959-25907-1-git-send-email-mail@eworm.de>
 <538EC135.6060105@cn.fujitsu.com>
 <20140604091926.37ad5ef2@leda.localdomain>
 <20140604164437.GA1903@twin.jikos.cz>
 <20140605105937.33bdd84d@leda.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140605105937.33bdd84d@leda.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2014 at 10:59:37AM +0200, Christian Hesse wrote:
> David Sterba <dsterba@suse.cz> on Wed, 2014/06/04 18:44:
> > On Wed, Jun 04, 2014 at 09:19:26AM +0200, Christian Hesse wrote:
> > > > It seems to be related to default gcc flags from distribution?
> > > 
> > > Probably. I did compile with optimization, so adding -O2 may do the trick:
> > > 
> > > make CFLAGS="${CFLAGS} -O2" all
> > 
> > The warning appears with -O2, so the question is if gcc is not able to
> > reason about the values (ie. a false positive) or if there's a bug that
> > I don't see.
> 
> I do not see a bug either. So probably this is a false positive...

Yeah I think so.

> Looks like the warning is triggered as soon as -ftree-vrp is added to CFLAGS.

Good catch

$ make CFLAGS="${CFLAGS} -O2 -Wall -fno-tree-vrp" all

does not print the warning (gcc 4.8.1).

> From gcc man page:
> 
> -ftree-vrp
>        Perform Value Range Propagation on trees.  This is similar to the
>        constant propagation pass, but instead of values, ranges of values are
>        propagated.  This allows the optimizers to remove unnecessary range
>        checks like array bound checks and null pointer checks.  This is
>        enabled by default at -O2 and higher.  Null pointer check elimination
>        is only done if -fdelete-null-pointer-checks is enabled.
> 
> Is it possibly that gcc optimized away any checks?

I'm not sure, that way lies gcc optimization maze.

Looking at the assembly from tree-vrp and no-tree-vrp it's probably the
case, the vrp-optimized version is restructured (and shorter) and looks
almost the same. Some of the bounds checks are missing (at least cannot
be easily paired). Better ask gcc people.
