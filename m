Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbbAISzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 13:55:07 -0500
Date: Fri, 9 Jan 2015 19:55:05 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 3.18.1
Message-ID: <20150109185505.GI3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is a followup that updates documentation, contains a few fixes from
coverity reports and a few recent small-sized fixes.

There's a pile of patches that reorder subcommands in the manpages. I did
not send them to the mailinglist as they're pretty trivial and would be
just noise. Similar holds for the coverity fixes, they're mostly
straightforward.

Near future plans.  There are several patchsets pending, I'm not yet decided
in which order I'll merge them, but would like to get the core changes and
some UI updates in before I branch off 3.19.x. Then switch build system to
autotools and merge the rest.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

david
