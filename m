Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaIBJAm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 05:00:42 -0400
Date: Tue, 2 Sep 2014 11:00:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: Marc MERLIN <marc@merlins.org>, Jean-Denis Girard <jd.girard@sysnux.pf>,
        linux-btrfs@vger.kernel.org
Subject: Re: Undelete files / directory
Message-ID: <20140902090040.GB5888@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53FE1DB2.8040900@sysnux.pf>
 <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net>
 <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com>
 <ltnnfo$a57$1@ger.gmane.org>
 <54002E66.703@gmail.com>
 <lttb7j$ef$1@ger.gmane.org>
 <lttfit$lk7$1@ger.gmane.org>
 <20140901162713.GS23400@merlins.org>
 <5404A613.5040405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5404A613.5040405@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 01, 2014 at 08:00:03PM +0300, Konstantinos Skarlatos wrote:
> On 1/9/2014 7:27 μμ, Marc MERLIN wrote:
> >On Sat, Aug 30, 2014 at 11:26:52AM -1000, Jean-Denis Girard wrote:
> >>So I commented out the break on line 238 of btrfs-find-root so that it
> >Thanks for that report.
> >Can a developer review this and see if it should be made an option or
> >removed entirely?
> I think that is the best way to proceed, or maybe even better make a "brute
> force" option for btrfs restore that does something like my for loop,
> recovering what it can through the filesystem.

Agreed, let's make 'find-root' a subcommand of 'rescue' instead of a
standalone utility. Then we can add options to allow inspecting a more
broken filesystem, eg. like the 'block out of fs'.
