Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.tellerulam.com ([213.198.94.130]:38397 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3KNNCy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 08:02:54 -0500
Date: Thu, 14 Nov 2013 13:56:21 +0100
From: Ian Kumlien <pomac@vapor.com>
To: dsterba@suse.cz, Ilya Dryomov <idryomov@gmail.com>,
        Dieter Ries <lists@dieterries.net>, Ian Kumlien <pomac@demius.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Message-ID: <20131114125621.GA13064@pomac.netswarm.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-3-git-send-email-pomac@demius.net>
 <51AB691A.90605@dieterries.net>
 <20131113171337.GD18494@twin.jikos.cz>
 <CAOi1vP_jpK4mW0HcuJtZnCOaFmQPimzA+PAXQXPxg-m7M-3YNg@mail.gmail.com>
 <20131114124921.GI18494@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131114124921.GI18494@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 14, 2013 at 01:49:21PM +0100, David Sterba wrote:
> On Thu, Nov 14, 2013 at 11:25:55AM +0200, Ilya Dryomov wrote:
> > On Wed, Nov 13, 2013 at 7:13 PM, David Sterba <dsterba@suse.cz> wrote:
> > >> For this to have any effect, 'h' must be added to getopt_long(), see
> > >> attached patch 1.
> > >>
> > >> However, this results in btrfsck -h and --help doing different things:
> > >>
> > >> --help prints the usage message to stdout and exits with exit(0).
> > >> -h prints the usage message to stderr and exits with exit(129).
> > >>
> > >> I made a patch to fix this, see attached patch 2.
> > >> What it doesn't fix though is, that -h/--help and -? don't do the same
> > >> thing. This is more complicated, as getop_long returns '?' for unknown
> > >> options.
> > >
> > > FYI, both patchess added to integration.
> > 
> > FWIW, I think none of the btrfs sub-commands treat -h as a help option.
> > (This is an artifact that was inherited from the the old btrfs-progs
> > utility.)  -h vs --help is actually consistent: -h results in a "btrfs
> > check: invalid option -- 'h'" message, and therefore exits with 129.
> > Since 'btrfs check -h' has clearly never worked we might want to keep
> > the status quo.
> 
> Good point, I'll drop the patches.

This should be really easy to add, i don't know if i have the time
currently thuogh... 

> david
