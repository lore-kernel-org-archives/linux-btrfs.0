Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab3HGL1A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 07:27:00 -0400
Date: Wed, 7 Aug 2013 13:26:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: introduce command namespace for
 development features
Message-ID: <20130807112658.GP5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1375791411.git.dsterba@suse.cz>
 <79debec8a345c66dd0b02793de680e0438428ee0.1375791411.git.dsterba@suse.cz>
 <20130806180137.GM12314@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130806180137.GM12314@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 06, 2013 at 11:01:37AM -0700, Zach Brown wrote:
> My biggest worry about this is that it complicates the coordination of
> automated testing, which is already in a terrible state for btrfs-progs.
> It can't possibly motivate people to write tests if we make the process
> more cumbersome than it already is.
> 
> So we develop tests for a command (maybe in xfstests,  maybe in
> btrfs-progs) that use this magical _ namespace.  Then the command is
> merged.  When are the tests updated?  Do they fallback to both so that
> the tests can work across the merge?   Do we add some complexity to try
> and magically match _ commands that aren't found with matching commands
> somewhere else in the heirarchy?  Ugh, all 'round.

My motivation is to merge various patchsets into one git tree even if
it's not in a final state of development, to let people test use it and
give feedback about usability. Patches floating around in the
mailinglist get tested by very few people.

A test developed for a _ command is unlikely to be merged into xfstests,
I expect the test to land there after the command is fininished
and has fixed command line UI.

In the meantime, the test reflects the _ status of the command. I was
thinking about extending xfstests to allow external testscripts to be
run as if it were a regular xfstest (using all the infrastructure). That
way the test is part of the btrfs-progs patchset and is synchronized
with the command name. Once it's done, _ is dropped and test can be
submitted to xfstests.

> I'm not sure I understand what problem this is really solving.  People
> shouldn't be expecting to find incomplete features in the master branch,
> right?  If people are looking to test incomplete work they can get your
> integration branch and, well, we don't care if it changes later?

Well, I hope no incomplete feature ends up in master, but for example
the chunk-recover got merged. Moving the command name is simple, but we
want to catch it earlier than when it's too late.

I have to re-organize integration branch(es) better, so there is eg. a
branch without unstable stuff, possibly always in a pullable state. On
top of that a bunch of topic branches with the _ features.

Let me know if I missed to answer something important.
david
