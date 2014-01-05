Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59196 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaAEIfi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 03:35:38 -0500
Date: Sat, 4 Jan 2014 22:13:53 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: coredump in btrfsck
Message-ID: <20140105061353.GD11749@merlins.org>
References: <52C4884F.6040000@gmail.com>
 <45E0985F-4F75-47D1-BD6E-2286D5844AE3@colorremedies.com>
 <52C4982C.1040606@gmail.com>
 <4656C292-30C5-4D72-AB46-654EC7C4FBD3@colorremedies.com>
 <20140103123311.GH10886@merlins.org>
 <DC2CCC7E-46BF-428E-BACE-5A7D5931BEC1@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <DC2CCC7E-46BF-428E-BACE-5A7D5931BEC1@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 05:14:56PM -0700, Chris Murphy wrote:
> 
> On Jan 3, 2014, at 5:33 AM, Marc MERLIN <marc@merlins.org> wrote:
> > 
> > Would it be possible for whoever maintains btrfs-tools to change both
> > the man page and the help included in the tool to clearly state that
> > running the fsck tool is unlikely to be the right course of action
> > and talk about btrfs-zero-log as well as mount -o recovery?
> 
> The problem FAQ doesn't even mention btrfsck so I think people are just getting around that page or making assumptions.
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ

It's easy to find btrfsck without the wiki, whether it's with dpkg -l,
rpm -ql, or command line completion.
My point is that as you said, it's most often not the command to use, it
can even do more damage than good, but neither its command line help,
nor the man page warn of anything dangerous or bad in using it.

Telling people they should have read a wiki instead of the canonical man
page isn't the right way to go longer term, nor how things are done on
linux usually.
 
> Should btrfs check (btrfsck without --repair) work similar to xfs_repair when the file system is not cleanly unmounted? If an XFS volume is not cleanly unmounted, running xfs_repair will instruct the user to first mount the volume so that the journal is replayed, then umount the volume, then run xfs_repair.

I don't know about what the actual tool does when it works, I've never
had it do anything useful for me, so I can't comment, except about the
fact that it should warn users about "I'm not the fsck you're used to or
are likely looking for"

> A possible variant of this for btrfs check: inform the user the first step in repairing a problem Btrfs volume is to use -o recovery, for more information see Btrfs FAQ <url> for additional problem solving recommendations.

Yes, along with tweaking the man page to say the same.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
