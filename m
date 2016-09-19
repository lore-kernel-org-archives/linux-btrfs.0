Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34105 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751564AbcISOiW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 10:38:22 -0400
Date: Mon, 19 Sep 2016 16:38:07 +0200
From: David Sterba <dave@jikos.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: stability matrix
Message-ID: <20160919143807.GF933@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
 <1473905644.8603.44.camel@scientia.net>
 <c58cd350-a1e8-7d1c-cf8c-84f7f0c05682@mendix.com>
 <b21c740b-5d71-7edd-f2fd-1ba6ea156dba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b21c740b-5d71-7edd-f2fd-1ba6ea156dba@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 07:54:26AM -0400, Austin S. Hemmelgarn wrote:
> > I'd like to help creating/maintaining this bug overview. A good start
> > would be to just crawl through all stable kernels and some distro
> > kernels and see which commits show up in fs/btrfs.
> >
> As of right now, we kind of do have such a page:
> https://btrfs.wiki.kernel.org/index.php/Gotchas
> It's not really well labeled though, ans it's easy to overlook.

The page has been created long time ago, if you'd need to start a new
page with similar content I can add a redirect so the link still works.

A more detailed bug page would be welcome by users. The changelogs I
write per release are terse as I don't want to spend the day just on
that. All the information should be in the git log and possibly in
recent mails, so this is manual work to present in on the wiki and does
not need devs to assist.
