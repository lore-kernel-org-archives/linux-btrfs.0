Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbcILQwv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 12:52:51 -0400
Date: Mon, 12 Sep 2016 18:51:07 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Message-ID: <20160912165107.GG16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2016 at 10:54:40AM -0400, Austin S. Hemmelgarn wrote:
> > Somebody has put that table on the wiki, so it's a good starting point.
> > I'm not sure we can fit everything into one table, some combinations do
> > not bring new information and we'd need n-dimensional matrix to get the
> > whole picture.
> Agreed, especially because some things are only bad in specific 
> circumstances (For example, snapshots generally work fine on almost 
> anything, until you get into the range of more than about 250, then they 
> start causing issues).

The performance aspect could be hard to estimate. Each feature has some
cost, we can document what's expected hit but various combinations and
actual runtime performance is unpredictable. I'd rather let the tools do
what the user asks for, as we might not be able to even detect there are
some bad external factors. I think that 250 snapshots would perform
better on an ssd than a rotational disk. In the end this leads to the
"dos & don'ts".
