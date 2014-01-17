Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbaAQPeE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 10:34:04 -0500
Date: Fri, 17 Jan 2014 16:34:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        sbehrens@giantdisaster.de
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140117153403.GW6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 16, 2014 at 07:23:18PM +0000, Toggenburger Lukas wrote:
> Hi all
> 
> I'm a student of ICT currently doing my master's degree besides
> working as a research assistant. Currently I'm looking for topics for
> my master thesis. One of my ideas was to work on Btrfs. I studied the
> list of project ideas at
> https://btrfs.wiki.kernel.org/index.php/Project_ideas and am
> especially interested in working on one of the following topics:

Please beware that the project ideas are unreviewed, sometimes very
short on details or not up-to-date with the people silently implementing
them. (Wiki is not the perfect tool for tracking tasks.)

> 1. (Enhanced) hot spare support as described in
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Hot_spare_support
> and
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#.22Enhanced.22_.28ala_RAID.29_support

This logically fits to the set of features like 'error statistics',
device replace, so I'm not sure if Stefan is not working on this
already.

> 2. Adding more checksumming algorithms ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#More_checksumming_algorithms )

As you've found, Josef is claiming this, but it's not mentioned on the
idea's page.

> 3. Improving subvolume handling regarding taking recursive snapshots (
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Take_recursive_snapshots
> ) and taking snapshots of arbitrary directories (
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Snapshot_arbitrary_directories
> )

Goffredo sent patches for the recursive snapshots, implemented in
userspace. http://www.spinics.net/lists/linux-btrfs/msg29553.html
I have some notes on kernel implementation from the time I reviewed the
patches.

The second project is essentially implementing the
'cp --reflink=always dir newsubvol' workaround.

> What is the current state of development concerning these features?

Unless there are patches in the mailinglist, hard to say. Sometimes the
status is shared on IRC.

> What would I need to know before going about one of these?

Not sure what exactly you're asking about.
Have an idea how to implement it. Then try to get ack from someobody
familiar with the area you're going to touch. Implement, write tests,
write some howto/docs, submit it.

HTH,
david
