Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0ABC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 14:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79AB920675
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 14:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfAOOgX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:36:23 -0500
Received: from aquinas.techsquare.com ([75.125.237.226]:37169 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727163AbfAOOgX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 09:36:23 -0500
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1gjPpD-0005yR-Ih; Tue, 15 Jan 2019 09:36:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23613.61411.481078.442640@techsquare.com>
Date:   Tue, 15 Jan 2019 09:36:19 -0500
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     "Scott E. Blomquist" <sb@techsquare.com>, Jojo <jojo@automatix.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs hang on nfs?
In-Reply-To: <c7b86349-4fea-e727-f912-03b5fb123ddd@suse.com>
References: <23605.54017.819143.292441@techsquare.com>
        <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
        <23605.63394.330818.203495@techsquare.com>
        <23607.12444.740949.683554@techsquare.com>
        <f95b63e3-9da5-ea60-3b4c-fbdf223f439c@suse.com>
        <23607.13250.659000.140295@techsquare.com>
        <23612.30105.728099.63687@techsquare.com>
        <89a8a3a1-07bc-6cdc-1278-b9649f2b477e@suse.com>
        <23612.35592.599043.773332@techsquare.com>
        <c7b86349-4fea-e727-f912-03b5fb123ddd@suse.com>
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Nikolay Borisov writes:
 > 
 <snip>
 > > 
 > > I'll have to rebuild the kernel with debug symbols.  Do I have to be
 > > booted into the kernel for that command to be useful?
 > 
 > Actually I think you are hitting the issue fixed by the following patch: 
 > https://github.com/kdave/btrfs-devel/commit/db0d10b02620b83ee592f6fc023ae146d72c5f65
 > 
 > 
 > The patch went into 4.18, yet your initial report said the hang occurs on 4.17. Could you try running 4.19 with e73e81b6d011 ("btrfs: balance dirty metadata pages in btrfs_finish_ordered_io")
 > reverted. 
 > 
 <snip>

As an update....

Yesterday after a hang up, I upgraded the firmware on the raid card.
There were items in the changelog that seemed like they might apply.

Unfortunately, later in the day the system hung up again.  It was also
unfortunate that I didn't have the debug kernel installed at the time.

I am now rebuilding a debug kernel with the patch you mention above.

FWIW i do see from fs/inode.c

        /* once for the tree */
        btrfs_put_ordered_extent(ordered_extent);

        /* Try to release some metadata so we don't get an OOM but don't wait */
        btrfs_btree_balance_dirty_nodelay(fs_info);

around the same place in the un-patched linux-4.17.14 source tree that
I built from, so I might have been hitting this in the previous kernel
also.

Cheers and thank you for all the help.

sb.  Scott Blomquist



