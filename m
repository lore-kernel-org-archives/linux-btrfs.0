Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC5DC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 433B72147C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfC0UOq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:14:46 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:56262 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfC0UOq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 16:14:46 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1h9Ewc-0006ZY-EP; Wed, 27 Mar 2019 21:14:42 +0100
Date:   Wed, 27 Mar 2019 21:14:42 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        marcin.slusarz@intel.com
Subject: Re: [PATCH v2 00/15] btrfs dax support
Message-ID: <20190327201442.GA22587@angband.pl>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190908.uz5rqakhr5er3r3z@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190326190908.uz5rqakhr5er3r3z@merlin>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:09:08PM -0500, Goldwyn Rodrigues wrote:
> This patch set adds support for dax on the BTRFS filesystem.

This patchset doesn't seem to support MAP_SYNC, which is the usual way to
use (and detect) DAX.  Basically, it requests for page faults to be
synchronous -- ie, when a page fault returns, the mapping points to actual
memory rather than to some buffer that'll be written back to the destination
at some point in the future.

Also, not really understanding these parts of the kernel, I can't tell if
the snapshots are atomic.  Ie, while the kernel walks over pages to set
mprotect flags, the process does two writes:
   RRRRRRRRRRRRRRRRRRRWWWWWWWWWWWWWWWWWWWWWW (R=ro W=rw)
        A                       B
The write at A causes a page fault, which clones the page, CoWing it and
letting the write into only one of the replicas.  After this, write to B
happens before the mprotect, thus goes into both replicas -- and despite
the process having issued proper memory barriers, the other replica has
B but not A.  To fix this, earlier page faults can't get finalized until
all mprotects are in place.  (I'm writing this as a query rather than a
problem report -- I'm an ignoramus here.)


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Did ya know that typing "test -j8" instead of "ctest -j8"
⢿⡄⠘⠷⠚⠋⠀ will make your testsuite pass much faster, and fix bugs?
⠈⠳⣄⠀⠀⠀⠀
