Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DF0C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 15:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A03C2087C
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 15:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A03C2087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389989AbeKQBbL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 20:31:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:55074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728169AbeKQBbL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 20:31:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC311AB7D
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 15:18:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 67081DAC3E; Fri, 16 Nov 2018 16:18:06 +0100 (CET)
Date:   Fri, 16 Nov 2018 16:18:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Misc cleanups in balance code
Message-ID: <20181116151806.GZ24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540554201-11305-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 26, 2018 at 02:43:16PM +0300, Nikolay Borisov wrote:
> While investigating the balance hang I came across various inconsistencies in 
> the source. This series aims to fix those. 
> 
> The first patch is (I believe) a fix to a longstanding bug that could cause 
> balance to fail due to ENOSPC. The code no properly ensures that there is 
> at least 1g of unallocated space on every device being balance.
> 
> Patch 2 makes btrfs_can_relocate a bit more obvious and removes leftovers from 
> previous cleanup
> 
> Patches 3/4/5 remove some redundant code from various functions. 
> 
> This series has survived multiple xfstest runs. 
> 
> Nikolay Borisov (5):
>   btrfs: Ensure at least 1g is free for balance
>   btrfs: Refactor btrfs_can_relocate
>   btrfs: Remove superfluous check form btrfs_remove_chunk
>   btrfs: Sink find_lock_delalloc_range's 'max_bytes' argument
>   btrfs: Replace BUG_ON with ASSERT in find_lock_delalloc_range

Patches 2-5 on the way to misc-next, thanks. The first one can have user
visible consequences, so I'd rather first find out why the 1MB was there
and if it's really a bug and what exactly will change when it's 1G.
