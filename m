Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C072C10F00
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 23:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 696C221773
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 23:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfC0X0j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 19:26:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:42242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbfC0X0i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 19:26:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 94ABCAA71;
        Wed, 27 Mar 2019 23:26:37 +0000 (UTC)
Date:   Wed, 27 Mar 2019 18:26:35 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        marcin.slusarz@intel.com
Subject: Re: [PATCH v2 00/15] btrfs dax support
Message-ID: <20190327232635.zw4edleqwowxfzej@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190908.uz5rqakhr5er3r3z@merlin>
 <20190327201442.GA22587@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327201442.GA22587@angband.pl>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 21:14 27/03, Adam Borowski wrote:
> On Tue, Mar 26, 2019 at 02:09:08PM -0500, Goldwyn Rodrigues wrote:
> > This patch set adds support for dax on the BTRFS filesystem.
> 
> This patchset doesn't seem to support MAP_SYNC, which is the usual way to
> use (and detect) DAX.  Basically, it requests for page faults to be
> synchronous -- ie, when a page fault returns, the mapping points to actual
> memory rather than to some buffer that'll be written back to the destination
> at some point in the future.

The translation (in different flags/returns) goes as follows
MAP_SYNC -> VM_SYNC -> VM_NEEDDSYNC.
So, when dax_iomap_fault() returns, it is handled through
dax_finish_sync_fault(). This is how all filesystems are doing it currently.
Refer patch 09/15.

> 
> Also, not really understanding these parts of the kernel, I can't tell if
> the snapshots are atomic.  Ie, while the kernel walks over pages to set
> mprotect flags, the process does two writes:
>    RRRRRRRRRRRRRRRRRRRWWWWWWWWWWWWWWWWWWWWWW (R=ro W=rw)
>         A                       B
> The write at A causes a page fault, which clones the page, CoWing it and
> letting the write into only one of the replicas.  After this, write to B
> happens before the mprotect, thus goes into both replicas -- and despite
> the process having issued proper memory barriers, the other replica has
> B but not A.  To fix this, earlier page faults can't get finalized until
> all mprotects are in place.  (I'm writing this as a query rather than a
> problem report -- I'm an ignoramus here.)

When you initiate a snapshot, btrfs forces everything to CoW until
snapshot finishes. This guarantees all new allocations
are Cow, even if the extent is set to nocow. During this time, all
"writebacks" happen. We don't have writebacks in DAX, but we take this
opportunity to wrprotect the mmap'd pages.
For more details, refer to patch 15/15 in the series.

-- 
Goldwyn
