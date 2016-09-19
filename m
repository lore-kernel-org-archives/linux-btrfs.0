Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36690 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbcISPik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 11:38:40 -0400
Date: Mon, 19 Sep 2016 17:38:15 +0200
From: David Sterba <dave@jikos.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Message-ID: <20160919153815.GH933@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2016 at 01:31:42PM -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-12 12:51, David Sterba wrote:
> > On Mon, Sep 12, 2016 at 10:54:40AM -0400, Austin S. Hemmelgarn wrote:
> >>> Somebody has put that table on the wiki, so it's a good starting point.
> >>> I'm not sure we can fit everything into one table, some combinations do
> >>> not bring new information and we'd need n-dimensional matrix to get the
> >>> whole picture.
> >> Agreed, especially because some things are only bad in specific
> >> circumstances (For example, snapshots generally work fine on almost
> >> anything, until you get into the range of more than about 250, then they
> >> start causing issues).
> >
> > The performance aspect could be hard to estimate. Each feature has some
> > cost, we can document what's expected hit but various combinations and
> > actual runtime performance is unpredictable. I'd rather let the tools do
> > what the user asks for, as we might not be able to even detect there are
> > some bad external factors. I think that 250 snapshots would perform
> > better on an ssd than a rotational disk. In the end this leads to the
> > "dos & don'ts".
> >
> In general yes in this case, but performance starts to degrade 
> exponentially beyond a certain point.  The difference between (for 
> example) 10 and 20 snapshots is not as much as between 1000 and 1010. 
> The problem here is that we don't really have a BCP document that anyone 
> ever reads.  A lot of stuff that may seem obvious to us after years of 
> working with BTRFS isn't going to be to a newcomer, and it's a lot more 
> likely that some random person will get things write if we have a good, 
> central BCP document than if it stays as scattered tribal knowledge.

The IRC tribe answers the same newcomer questions over and over, which
is fine for the interaction itself, but if all that also ended up in
wiki we'd have perfect documentation years ago. Also the current status
of features and bugs is kept in the IRC-hive-mind yet it still needs
some other way to actually make it appear on wiki. Edit with courage!
