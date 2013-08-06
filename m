Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078Ab3HFSBk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 14:01:40 -0400
Date: Tue, 6 Aug 2013 11:01:37 -0700
From: Zach Brown <zab@redhat.com>
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: introduce command namespace for
 development features
Message-ID: <20130806180137.GM12314@lenny.home.zabbo.net>
References: <cover.1375791411.git.dsterba@suse.cz>
 <79debec8a345c66dd0b02793de680e0438428ee0.1375791411.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <79debec8a345c66dd0b02793de680e0438428ee0.1375791411.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 06, 2013 at 02:25:20PM +0200, David Sterba wrote:
> We'd like to make it easier to preview a new feature and remove the
> burden to invent sane user interface (command name, placement,
> arguments, man) from the beginning.

My biggest worry about this is that it complicates the coordination of
automated testing, which is already in a terrible state for btrfs-progs.
It can't possibly motivate people to write tests if we make the process
more cumbersome than it already is.

So we develop tests for a command (maybe in xfstests,  maybe in
btrfs-progs) that use this magical _ namespace.  Then the command is
merged.  When are the tests updated?  Do they fallback to both so that
the tests can work across the merge?   Do we add some complexity to try
and magically match _ commands that aren't found with matching commands
somewhere else in the heirarchy?  Ugh, all 'round.

I'm not sure I understand what problem this is really solving.  People
shouldn't be expecting to find incomplete features in the master branch,
right?  If people are looking to test incomplete work they can get your
integration branch and, well, we don't care if it changes later?

- z
