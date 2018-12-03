Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B862AC07E85
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 17:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 896AC20848
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 17:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 896AC20848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbeLCROl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 12:14:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:33002 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbeLCROh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 12:14:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC8B3ADD4
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2018 17:14:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 712C6DAF63; Mon,  3 Dec 2018 18:14:16 +0100 (CET)
Date:   Mon, 3 Dec 2018 18:14:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Replace custom device-replace locking with rwsem
Message-ID: <20181203171415.GA17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1542717531.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1542717531.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 20, 2018 at 01:50:54PM +0100, David Sterba wrote:
> The first cleanup part went to 4.19, the actual switch from the custom
> locking to rswem was postponed as I found performance degradation. This
> turned out to be related to VM cache settings, so I'm resending the
> series again.
> 
> The custom locking is based on rwlock protected reader/writer counters,
> waitqueues, which essentially is what the readwrite semaphore does.
> 
> Previous patchset:
> https://lore.kernel.org/linux-btrfs/cover.1536331604.git.dsterba@suse.com/
> 
> Patches correspond to 8/11-11/11 and there's no change besides
> refreshing on top of current misc-next.
> 
> David Sterba (4):
>   btrfs: reada: reorder dev-replace locks before radix tree preload
>   btrfs: dev-replace: swich locking to rw semaphore
>   btrfs: dev-replace: remove custom read/write blocking scheme
>   btrfs: dev-replace: open code trivial locking helpers

This has been sitting in for-next for some time, no problems reported.
If anybody wants to add a review tag, please let me know. I'm going to
add the patchset to misc-next soon.
