Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36742 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3AHSqD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 13:46:03 -0500
Date: Tue, 8 Jan 2013 10:46:03 -0800
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130108184603.GG2044@merlins.org>
References: <20130108164958.GA2044@merlins.org> <20130108182541.GE2389@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130108182541.GE2389@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 01:25:41PM -0500, Josef Bacik wrote:
> On Tue, Jan 08, 2013 at 09:49:58AM -0700, Marc MERLIN wrote:
> > Unfortunately my laptop deadlocks from time to time, and too often
> > it triggers this bug in btrfs which is quite hard to recover from.
> > 
> 
> You are getting bad tree blocks which really isn't the tree logs fault.  Can you
> scrub your file system and make sure there's not some sort of latent issue going
> on?  And if you have problems again please try btrfs-next as I've fixed a few
> log replay bugs recently.  Thanks,

Thanks for your answer.

I've only read about scrub in a mirorr situation, as per
https://blogs.oracle.com/wim/entry/btrfs_scrub_go_fix_corruptions

It's a single device here, so if there are problems, I'm not sure how scrub
will be able to fix them.
Would you like me to go ahead and do it anyway?

And before I further remove potential debug state
1) what about this problem?
btrfs-image: btrfs-image.c:518: create_metadump: Assertion `!(ret < 0)'
failed.
Aborted

2) anything else you want me to get off my filesystem before I scrub it?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
