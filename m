Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40333 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932415AbdC1MvA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 08:51:00 -0400
Date: Tue, 28 Mar 2017 14:50:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2] Btrfs: fix unexpected file hole after disk errors
Message-ID: <20170328125006.GY4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
 <1488831810-26684-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1488831810-26684-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 06, 2017 at 12:23:30PM -0800, Liu Bo wrote:
> Btrfs creates hole extents to cover any unwritten section right before
> doing buffer writes after commit 3ac0d7b96a26 ("btrfs: Change the expanding
> write sequence to fix snapshot related bug.").
> 
> However, that takes the start position of the buffered write to compare
> against the current EOF, hole extents would be created only if (EOF <
> start).
> 
> If the EOF is at the middle of the buffered write, no hole extents will be
> created and a file hole without a hole extent is left in this file.
> 
> This bug was revealed by generic/019 in fstests.  'fsstress' in this test
> may create the above situation and the test then fails all requests
> including writes, so the buffer write which is supposed to cover the
> hole (without the hole extent) couldn't make it on disk.  Running fsck
> against such btrfs ends up with detecting file extent holes.
> 
> Things could be more serious, some stale data would be exposed to
> userspace if files with this kind of hole are truncated to a position of
> the hole, because the on-disk inode size is beyond the last extent in the
> file.
> 
> This fixes the bug by comparing the end position against the EOF.

Is the test reliable? As I read it, it should be possible to craft the
file extents and trigger the bug. And verify the fix.
