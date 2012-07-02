Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59914 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab2GBQKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 12:10:18 -0400
Date: Mon, 2 Jul 2012 18:10:11 +0200
From: David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jbacik@fusionio.com
Subject: Re: xfstests/224 lockup/slowdown (was: Please hammer my for-linus
 branch)
Message-ID: <20120702161011.GE5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120701012259.GM17638@shiny>
 <20120702141052.GC5326@twin.jikos.cz>
 <20120702143453.GD5326@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120702143453.GD5326@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 04:34:53PM +0200, David Sterba wrote:
> Bisection in progress.

commit cae76522b19735c576803bec273f49062aa418ab
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Thu Jun 21 14:05:49 2012 -0400

    Btrfs: flush delayed inodes if we're short on space

    Those crazy gentoo guys have been complaining about ENOSPC errors on their
    portage volumes.  This is because doing things like untar tends to create
    lots of new files which will soak up all the reservation space in the
    delayed inodes.  Usually this gets papered over by the fact that we will try
    and commit the transaction, however if this happens in the wrong spot or we
    choose not to commit the transaction you will be screwed.  So add the
    ability to expclitly flush delayed inodes to free up space.  Please test
    this out guys to make sure it works since as usual I cannot reproduce.
    Thanks,
