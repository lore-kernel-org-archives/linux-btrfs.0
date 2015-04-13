Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbbDMNtp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 09:49:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D036FACBA
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 13:49:43 +0000 (UTC)
Date: Mon, 13 Apr 2015 15:49:43 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: RFC: plan to allow documentation contributions via github
Message-ID: <20150413134943.GK25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

plan: I'd like to allow documentation updates through github web interface.
"patches via mailinglist" will continue to work unchanged.

The current way to clone the git, edit files, send to mailinglist might
discourage people who are not developers or not used to working with git
that way.

There are some issues around the pull request I'm not yet clear how to
resolve.  I'd like to keep the git history clean so the pull requests
will not get merged the usual way. I'll probably merge the
changes/patches manually and then close the request. There shall be a
branch to serve as a starting point for any new edits, but will be a
moving target after the pending patches get merged. I hope this will
work for the browser-only approach, the merging burden is on my side.

In order to get a working 'Preview' for the changes, we'd have to rename
all .txt files to .asciidoc. Then you get a nice formatting on the
github site for free.

You can see an example here:
https://github.com/kdave/btrfs-progs/blob/test-asciidoc/Documentation/btrfs-balance.asciidoc

The documentation is separated from code so we can afford to relax the
submission rules, though we'll still need the signed-off-by and names
for the final commits.

Thanks for feedback.
