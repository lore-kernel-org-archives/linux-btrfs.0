Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59387 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3AMDMN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 22:12:13 -0500
Date: Sat, 12 Jan 2013 19:12:12 -0800
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130113031212.GI4038@merlins.org>
References: <20130108164958.GA2044@merlins.org> <20130108182541.GE2389@localhost.localdomain> <20130108184603.GG2044@merlins.org> <20130110162009.GF16943@merlins.org> <20130111144952.GA1876@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130111144952.GA1876@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 09:49:52AM -0500, Josef Bacik wrote:
> On Thu, Jan 10, 2013 at 09:20:09AM -0700, Marc MERLIN wrote:
> > On Tue, Jan 08, 2013 at 10:46:03AM -0800, Marc MERLIN wrote:
> > > On Tue, Jan 08, 2013 at 01:25:41PM -0500, Josef Bacik wrote:
> > > > On Tue, Jan 08, 2013 at 09:49:58AM -0700, Marc MERLIN wrote:
> > > > > Unfortunately my laptop deadlocks from time to time, and too often
> > > > > it triggers this bug in btrfs which is quite hard to recover from.
> > > > > 
> > > > 
> > > > You are getting bad tree blocks which really isn't the tree logs fault.  Can you
> > > > scrub your file system and make sure there's not some sort of latent issue going
> > > > on?  And if you have problems again please try btrfs-next as I've fixed a few
> > > > log replay bugs recently.  Thanks,
> > > 
> > > Thanks for your answer.
> > > 
> > > I've only read about scrub in a mirorr situation, as per
> > > https://blogs.oracle.com/wim/entry/btrfs_scrub_go_fix_corruptions
> > > 
> > > It's a single device here, so if there are problems, I'm not sure how scrub
> > > will be able to fix them.
> > > Would you like me to go ahead and do it anyway?
> > > 
> 
> Well its mostly to verify you have some sort of latent corruption sitting
> around.  If you have DUP it will be able to fix it, but if you don't we'll at
> least know something else is wrong and we can try and work out if fsck will fix
> it.
 
Looks like I had no problems if I'm reading this right:
scrub status:1
92584fa9-85cd-4df6-b182-d32198b76a0b:1|data_extents_scrubbed:7739406|tree_extents_scrubbed:2351353|data_bytes_scrubbed:347948277760|tree_bytes_scrubbed:9631141888|read_errors:0|csum_errors:0|verify_errors:0|no_csum:52600|csum_discards:0|super_errors:0|malloc_errors:0|uncorrectable_errors:0|corrected_errors:0|last_physical:474268106752|t_start:1357918734|t_resumed:0|duration:984|canceled:0|finished:1


> > > And before I further remove potential debug state
> > > 1) what about this problem?
> > > btrfs-image: btrfs-image.c:518: create_metadump: Assertion `!(ret < 0)'
> > > failed.
> > > Aborted
> 
> Probably just related to whatever corruption it is you are seeing.
 
So I have no corruption afterall, correct?

That's good news, but then it does mean that unclean sudden shutdowns in the wrong place.

I still have a truncated fs_image if someone wants it, and with an
apparently uncorrupted FS, btrfs-image is still dying for me:
andalfthegreat:~# btrfs-image -c 9 /dev/mapper/cryptroot  /var/tmp/fs_image2
Check tree block failed, want=4261896192, have=10797364022063960087
Check tree block failed, want=4261896192, have=10797364022063960087
Check tree block failed, want=4261896192, have=13996544474027288730
Check tree block failed, want=4261896192, have=10797364022063960087
Check tree block failed, want=4261896192, have=10797364022063960087
read block failed check_tree_block
btrfs-image: btrfs-image.c:518: create_metadump: Assertion `!(ret < 0)' failed.
Aborted
gandalfthegreat:~# 

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
