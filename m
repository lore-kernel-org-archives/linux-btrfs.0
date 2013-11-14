Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab3KNMt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 07:49:27 -0500
Date: Thu, 14 Nov 2013 13:49:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Dieter Ries <lists@dieterries.net>, Ian Kumlien <pomac@demius.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Message-ID: <20131114124921.GI18494@suse.cz>
Reply-To: dsterba@suse.cz
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-3-git-send-email-pomac@demius.net>
 <51AB691A.90605@dieterries.net>
 <20131113171337.GD18494@twin.jikos.cz>
 <CAOi1vP_jpK4mW0HcuJtZnCOaFmQPimzA+PAXQXPxg-m7M-3YNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOi1vP_jpK4mW0HcuJtZnCOaFmQPimzA+PAXQXPxg-m7M-3YNg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 14, 2013 at 11:25:55AM +0200, Ilya Dryomov wrote:
> On Wed, Nov 13, 2013 at 7:13 PM, David Sterba <dsterba@suse.cz> wrote:
> >> For this to have any effect, 'h' must be added to getopt_long(), see
> >> attached patch 1.
> >>
> >> However, this results in btrfsck -h and --help doing different things:
> >>
> >> --help prints the usage message to stdout and exits with exit(0).
> >> -h prints the usage message to stderr and exits with exit(129).
> >>
> >> I made a patch to fix this, see attached patch 2.
> >> What it doesn't fix though is, that -h/--help and -? don't do the same
> >> thing. This is more complicated, as getop_long returns '?' for unknown
> >> options.
> >
> > FYI, both patchess added to integration.
> 
> FWIW, I think none of the btrfs sub-commands treat -h as a help option.
> (This is an artifact that was inherited from the the old btrfs-progs
> utility.)  -h vs --help is actually consistent: -h results in a "btrfs
> check: invalid option -- 'h'" message, and therefore exits with 129.
> Since 'btrfs check -h' has clearly never worked we might want to keep
> the status quo.

Good point, I'll drop the patches.

david
