Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EA7C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 10:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04FA620652
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 10:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04FA620652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbeJERkr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:40:47 -0400
Received: from [195.159.176.226] ([195.159.176.226]:52916 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJERkr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 13:40:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g8NWu-0007uY-L5
        for linux-btrfs@vger.kernel.org; Fri, 05 Oct 2018 12:40:20 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding BTRFS RAID0 Performance
Date:   Fri, 5 Oct 2018 10:40:14 +0000 (UTC)
Message-ID: <pan$77fbd$8ebaf02d$210deb71$a2b73f29@cox.net>
References: <54026c92-9cd1-2ac8-5747-c5405dd82087@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Wilson, Ellis posted on Thu, 04 Oct 2018 21:33:29 +0000 as excerpted:

> Hi all,
> 
> I'm attempting to understand a roughly 30% degradation in BTRFS RAID0
> for large read I/Os across six disks compared with ext4 atop mdadm
> RAID0.
> 
> Specifically, I achieve performance parity with BTRFS in terms of
> single-threaded write and read, and multi-threaded write, but poor
> performance for multi-threaded read.  The relative discrepancy appears
> to grow as one adds disks.

[...]

> Before I dive into the BTRFS source or try tracing in a different way, I
> wanted to see if this was a well-known artifact of BTRFS RAID0 and, even
> better, if there's any tunables available for RAID0 in BTRFS I could
> play with.  The man page for mkfs.btrfs and btrfstune in the tuning
> regard seemed...sparse.

This is indeed well known for btrfs at this point, as it hasn't been 
multi-read-thread optimized yet.  I'm personally more familiar with the 
raid1 case, where which one of the two copies gets the read is simply 
even/odd-PID-based, but AFAIK raid0 isn't particularly optimized either.

The recommended workaround is (as you might expect) btrfs on top of 
mdraid.  In fact, while it doesn't apply to your case, btrfs raid1 on top 
of mdraid0s is often recommended as an alternative to btrfs raid10, as 
that gives you the best of both worlds -- the data and metadata integrity 
protection of btrfs checksums and fallback (with writeback of the correct 
version) to the other copy if the first copy read fails checksum 
verification, with the much better optimized mdraid0 performance.  So it 
stands to reason that the same recommendation would apply to raid0 -- 
just do single-mode btrfs on mdraid0, for better performance than the as 
yet unoptimized btrfs raid0.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

