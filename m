Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A5DC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB342064C
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:22:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DB342064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbeJWCm2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:42:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:44388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728353AbeJWCm2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 22:42:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB4E7AE06;
        Mon, 22 Oct 2018 18:22:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B5603DA6FB; Mon, 22 Oct 2018 20:22:43 +0200 (CEST)
Date:   Mon, 22 Oct 2018 20:22:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Olof Johansson <olof@lixom.net>
Cc:     dsterba@suse.de, linux-btrfs@vger.kernel.org, clm@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: Circular lock dep in btrfs triggered by shrinker
Message-ID: <20181022182243.GM16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Olof Johansson <olof@lixom.net>,
        dsterba@suse.de, linux-btrfs@vger.kernel.org, clm@fb.com,
        linux-kernel@vger.kernel.org
References: <20181022100726.5hwvc5xswg3k3a2f@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022100726.5hwvc5xswg3k3a2f@localhost>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 03:07:26AM -0700, Olof Johansson wrote:
> I hit the below circular locking dependency. Seems like the assumption made in
> 712e36c5f2a7fa56 ("btrfs: use GFP_KERNEL in btrfs_alloc_inode") either isn't
> true, or has since changed?

I think it must have been there from the beginning. There were reports
of this lockdep warning like the below and IIRC a few more
(https://lkml.kernel.org/r/20180627120523.GA2287@suse.cz), but without a
resolution.

Incidentally, there was a fix that's now in the 4.20 pull and only after
I had seen your report I realized that it was the fix for the warning:

https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git/commit/?h=for-4.20-part1&id=84de76a2fb217dc1b6bc2965cc397d1648aa1404

It disables the filesystem allocations using the memalloc_nofs mechanism
around free space inode allocation, while my original patch expected
only regular inodes created by VFS.

> ======================================================
> WARNING: possible circular locking dependency detected
> 4.19.0 #25 Not tainted
> ------------------------------------------------------
> kswapd0/414 is trying to acquire lock:
> 000000008b8f1971 (&delayed_node->mutex){+.+.}, at: __btrfs_release_delayed_node+0x35/0x1e0
> but task is already holding lock:
> 00000000032f657e (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x0/0x30
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> -> #3 (fs_reclaim){+.+.}:
>        kmem_cache_alloc+0x24/0x270
>        btrfs_alloc_inode+0x1f/0x260
>        alloc_inode+0x13/0x80
>        iget5_locked+0x3f/0x80
>        btrfs_iget+0x52/0x680
>        __lookup_free_space_inode+0xd9/0x110

The patch adds memalloc_nofs into ^^^^.  It's scheduled for stable so
the warning will disappear eventually, thanks for the report.
