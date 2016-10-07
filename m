Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42367 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbcJGPv6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 11:51:58 -0400
Date: Fri, 7 Oct 2016 17:51:55 +0200
From: David Sterba <dsterba@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Brian Foster <bfoster@redhat.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is is possible to submit binary image as fstest test case?
Message-ID: <20161007155155.GC11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
 <20161006122927.GB16893@bfoster.bfoster>
 <20161006192452.qj3stqmhhz5cq3wj@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161006192452.qj3stqmhhz5cq3wj@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2016 at 03:24:52PM -0400, Theodore Ts'o wrote:
> On Thu, Oct 06, 2016 at 08:29:28AM -0400, Brian Foster wrote:
> > Doesn't necessarily bother me one way or the other, but something we've
> > done with XFS in such situations is introduce a DEBUG mode only sysfs
> > tunable that delays certain infrastructure (log recovery in our case) to
> > coordinate with test cases that try to reproduce such timing/racing
> > problems.
> 
> The other approach the btrfs folks might consider is to have a
> sufficiently powerful "debugfs" or "xfs_db" program that can generate
> test images with the desired property.

We can generate certain classes of testing images, eg. by mkfs, adding
files and then corrupting specific keys after unmount. This could be
unreliable for timing-dependent bugs, or catching some intermediate
filesystem state that is created by kernel for free but would be tedious
to recreate manually from scratch in userspace.

> I've found that the time I've invested in creating debugfs has repaid
> itself a hundred times over, especially when maintaining a regression
> test suite for e2fsck.

I agree that's a good thing.
