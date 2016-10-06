Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38258 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936519AbcJGBn7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 21:43:59 -0400
Date: Thu, 6 Oct 2016 15:24:52 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Brian Foster <bfoster@redhat.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, fstests@vger.kernel.org,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is is possible to submit binary image as fstest test case?
Message-ID: <20161006192452.qj3stqmhhz5cq3wj@thunk.org>
References: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
 <20161006122927.GB16893@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161006122927.GB16893@bfoster.bfoster>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2016 at 08:29:28AM -0400, Brian Foster wrote:
> Doesn't necessarily bother me one way or the other, but something we've
> done with XFS in such situations is introduce a DEBUG mode only sysfs
> tunable that delays certain infrastructure (log recovery in our case) to
> coordinate with test cases that try to reproduce such timing/racing
> problems.

The other approach the btrfs folks might consider is to have a
sufficiently powerful "debugfs" or "xfs_db" program that can generate
test images with the desired property.

I've found that the time I've invested in creating debugfs has repaid
itself a hundred times over, especially when maintaining a regression
test suite for e2fsck.

Cheers,

					- Ted
