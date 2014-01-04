Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40105 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752807AbaADAPG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 19:15:06 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: coredump in btrfsck
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140103123311.GH10886@merlins.org>
Date: Fri, 3 Jan 2014 17:14:56 -0700
Cc: Marc MERLIN <marc@merlins.org>, Eric Sandeen <sandeen@sandeen.net>
Message-Id: <DC2CCC7E-46BF-428E-BACE-5A7D5931BEC1@colorremedies.com>
References: <52C4884F.6040000@gmail.com> <45E0985F-4F75-47D1-BD6E-2286D5844AE3@colorremedies.com> <52C4982C.1040606@gmail.com> <4656C292-30C5-4D72-AB46-654EC7C4FBD3@colorremedies.com> <20140103123311.GH10886@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2014, at 5:33 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> Would it be possible for whoever maintains btrfs-tools to change both
> the man page and the help included in the tool to clearly state that
> running the fsck tool is unlikely to be the right course of action
> and talk about btrfs-zero-log as well as mount -o recovery?

The problem FAQ doesn't even mention btrfsck so I think people are just getting around that page or making assumptions.
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ

Should btrfs check (btrfsck without --repair) work similar to xfs_repair when the file system is not cleanly unmounted? If an XFS volume is not cleanly unmounted, running xfs_repair will instruct the user to first mount the volume so that the journal is replayed, then umount the volume, then run xfs_repair.

A possible variant of this for btrfs check: inform the user the first step in repairing a problem Btrfs volume is to use -o recovery, for more information see Btrfs FAQ <url> for additional problem solving recommendations.

?

Chris Murphy