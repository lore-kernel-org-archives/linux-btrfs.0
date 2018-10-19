Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AD8ECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 10:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C847720836
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 10:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C847720836
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJSScA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 14:32:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:54148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726609AbeJSScA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 14:32:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE0E1AD82;
        Fri, 19 Oct 2018 10:26:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5F14ADA6F5; Fri, 19 Oct 2018 12:26:24 +0200 (CEST)
Date:   Fri, 19 Oct 2018 12:26:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix use-after-free during inode eviction
Message-ID: <20181019102624.GD16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181012120248.32262-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012120248.32262-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 01:02:48PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> At inode.c:evict_inode_truncate_pages(), when we iterate over the inode's
> extent states, we access an extent state record's "state" field after we
> unlocked the inode's io tree lock. This can lead to a use-after-free issue
> because after we unlock the io tree that extent state record might have
> been freed due to being merged into another adjacent extent state
> record (a previous inflight bio for a read operation finished in the
> meanwhile which unlocked a range in the io tree and cause a merge of
> extent state records, as explained in the comment before the while loop
> added in commit 6ca0709756710 ("Btrfs: fix hang during inode eviction due
> to concurrent readahead")).
> 
> Fix this by keeping a copy of the extent state's flags in a local variable
> and using it after unlocking the io tree.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201189
> Fixes: b9d0b38928e2 ("btrfs: Add handler for invalidate page")
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to misc-next, thanks.
