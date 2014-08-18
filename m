Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ore.jhcloos.com ([198.147.23.85]:47250 "EHLO ore.jhcloos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaHRUpo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 16:45:44 -0400
From: James Cloos <cloos@jhcloos.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
In-Reply-To: <20140812044953.GF8314@merlins.org> (Marc MERLIN's message of
	"Mon, 11 Aug 2014 21:49:53 -0700")
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<53C7CD0F.7070603@fb.com>
	<CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
	<1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com>
	<20140812025521.GA6730@pyropus.ca> <20140812044953.GF8314@merlins.org>
Date: Mon, 18 Aug 2014 16:34:53 -0400
Message-ID: <m3bnrhsfiq.fsf@carbon.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "MM" == Marc MERLIN <marc@merlins.org> writes:

MM> Note 3.16.0 is actually worse than 3.15 for me.

Here (a single partition btrfs), 3.16.0 works fine, but 3.17-rc1 fails again.

My /var/log is also a compressed, single-partition btrfs; that doesn't
show the problem with any version.  Just the partition with git, svn and
rsync trees.

Last night's test of 3.17-rc1 showed the problem with the first git
pull, getting stuck reading FETCH_HEAD.  All repos on that fs failed
the same way.

But rebooting back to 3.16.0 let everything work perfectly.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 0x997A9F17ED7DAEA6
