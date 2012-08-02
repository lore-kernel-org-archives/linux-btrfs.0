Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50308 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab2HBNkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 09:40:24 -0400
Date: Thu, 2 Aug 2012 15:40:03 +0200
From: David Sterba <dave@jikos.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: BTRFS crash on mount with 3.4.4
Message-ID: <20120802134003.GP17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120731180412.GA10520@merlins.org>
 <20120801010104.GA7089@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120801010104.GA7089@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2012 at 06:01:04PM -0700, Marc MERLIN wrote:
> On Tue, Jul 31, 2012 at 11:04:12AM -0700, Marc MERLIN wrote:
> > My kernel crashed for some other reason, and now I can't mount my btrfs
> > filesystem.
> > I don't care about the data, it's backed up.
> > 
> > I'll compile a 3.5 kernel, but is there any info you'd like off that
> > filesystem to see why btrfs is crashing on mount?
> 
> On the plus side, 3.5 mounted the filesystem:
> [  183.069179] device label btrfs_pool1 devid 1 transid 20769 /dev/mapper/test
> [  183.087805] btrfs: disk space caching is enabled
> [  183.224784] btrfs: no dev_stats entry found for device /dev/mapper/test (devid 1) (OK on first mount after mkfs)
> [  186.277795] Btrfs detected SSD devices, enabling SSD mode
> [  188.477443] btrfs: unlinked 6 orphans
> [  188.477451] btrfs: truncated 1 orphans
> [  411.837015] btrfs: unlinked 13 orphans
> [  414.373500] btrfs: unlinked 35 orphans

there's this commit in 3.5 that looks like it fixed the problem:

Author:     Josef Bacik <jbacik@fusionio.com>
AuthorDate: Wed Jun 27 15:10:56 2012 -0400

    Btrfs: fix tree log remove space corner case

    The tree log stuff can have allocated space that we end up having split
    across a bitmap and a real extent.  The free space code does not deal with
    this, it assumes that if it finds an extent or bitmap entry that the entire
    range must fall within the entry it finds.  This isn't necessarily the case,
    so rework the remove function so it can handle this case properly.  This
    fixed two panics the user hit, first in the case where the space was
    initially in a bitmap and then in an extent entry, and then the reverse
    case.  Thanks,
---

david
