Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3BHWaT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 17:30:19 -0500
Date: Fri, 8 Feb 2013 23:30:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH 6/6] Btrfs-progs: add the rescue section to btrfs
Message-ID: <20130208223013.GK12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-7-git-send-email-pomac@demius.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360283822-23452-7-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 01:37:02AM +0100, Ian Kumlien wrote:
> the btrfs command now lists:
>     btrfs rescue select-super -s <number> <device>
>         Select a superblock
>     btrfs rescue dump-super <device>
>         Dump a superblock to disk
>     btrfs rescue debug-tree [options] <device>
>         Debug the filesystem

Let me summarize here the comments I've read so far and what we disussed
with Ilya on irc:

* btrfs check -- seems to be accepted
* btrfs restore -- seems to be accepted

* btrfs rescue
  * select-super -- it is a command that can make
    things bad and should be used with caution, thus not very suitable
    to put under 'rescue' command, let's keep it as a standalone utitly
    for now

  * show-super +
  * dump-super -- they do basically the same thing, the output is
    different, Ilya suggests to keep only 'dump-super' with 2 output
    modes, and I agree with him

  * debug-tree -- suggested name is 'dump-tree'

Then, the namespace 'rescue' does not fit the purpose, these are
debugging commands, so the proposed name is 'debug'.

They do not seem to fit into 'inspect-internal' which is supposed to
work on a mounted filesystem, and  I think this should contain commands
for infrequent but useful things.

Let's focus on the above commands for start, we can add more later (eg.
the repair subcommand).


thanks,
david
