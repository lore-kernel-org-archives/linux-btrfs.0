Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33130 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752090AbdF0MHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 08:07:47 -0400
Date: Tue, 27 Jun 2017 14:06:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: lowmem check: Fix false alert about file
 extent interrupt
Message-ID: <20170627120637.GS2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170622075237.1852-1-lufq.fnst@cn.fujitsu.com>
 <20170622081256.4981-1-lufq.fnst@cn.fujitsu.com>
 <20170626145504.GM2866@twin.jikos.cz>
 <20170627053747.GA2596@lufq.5F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170627053747.GA2596@lufq.5F>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 01:37:47PM +0800, Lu Fengqi wrote:
> On Mon, Jun 26, 2017 at 04:55:04PM +0200, David Sterba wrote:
> >On Thu, Jun 22, 2017 at 04:12:56PM +0800, Lu Fengqi wrote:
> >> As Qu mentioned in this thread
> >> (https://www.spinics.net/lists/linux-btrfs/msg64469.html), compression
> >> can cause regular extent to co-exist with inlined extent. This coexistence
> >> makes things confusing. Since it was permitted currently, so fix
> >> btrfsck to prevent a bunch of error logs that will make user feel
> >> panic.
> >> 
> >> When check file extent, record the extent_end of regular extent to check
> >> if there is a gap between the regular extents. Normally there is only one
> >> inlined extent, so the extent_end of inlined extent is useless. However,
> >> if regular extent can co-exist with inlined extent, the extent_end of
> >> inlined extent also need to record.
> >> 
> >> Reported-by: Marc MERLIN <marc@merlins.org>
> >> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> >
> >Applied, thanks.
> >
> >Do you have a test for that?
> 
> Yes, I have already posted this testcase
> (https://www.spinics.net/lists/linux-btrfs/msg66802.html) yesterday.

I see, thanks.

> In
> addition, this patch has an updated version
> (https://www.spinics.net/lists/linux-btrfs/msg66803.html) which make
> lowmem mode output more detailed information when file extent interrupt.
> Since the patch v2 has been applied, then I will send a patch for this
> modification alone.

I'll replace the patch with v3.
