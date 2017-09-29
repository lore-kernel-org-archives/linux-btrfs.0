Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751224AbdI2RX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 13:23:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5A4BAC3E
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 17:23:28 +0000 (UTC)
Date: Fri, 29 Sep 2017 19:21:54 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] btrfs-progs: check: supplement extent backref list
 with rbtree
Message-ID: <20170929172154.GR31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170725205138.28376-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170725205138.28376-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 25, 2017 at 04:51:32PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> For the pathlogical case, like xfstests generic/297 that creates a
> large file consisting of one, repeating reflinked extent, fsck can
> take hours.  The root cause is that calling find_data_backref while
> iterating the extent records is an O(n^2) algorithm.  For my
> example test run, n was 2*2^20 and fsck was at 8 hours and counting.
> 
> This patch supplements the list with an rbtree and drops the runtime
> of that testcase to about 20 seconds.
> 
> A previous version of this patch introduced a regression that would
> have corrupted file systems during repair.  It was traced to the
> compare algorithm honoring ->bytes regardless of whether the
> reference had been found and a failure to reinsert nodes after
> the target reference was found.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Josef has fixed the crash so I've added the patchset to devel.
