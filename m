Return-Path: <SRS0=0wlt=2B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D08C43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 15:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5752077B
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 15:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbfLKPeb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:34:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:37686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733083AbfLKPe3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Dec 2019 10:34:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B44E3AD6B;
        Wed, 11 Dec 2019 15:34:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A68F2DA883; Wed, 11 Dec 2019 16:34:29 +0100 (CET)
Date:   Wed, 11 Dec 2019 16:34:29 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: fixes for relocation to avoid KASAN reports
Message-ID: <20191211153429.GO3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191211050004.18414-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211050004.18414-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 11, 2019 at 01:00:01PM +0800, Qu Wenruo wrote:
> Due to commit d2311e698578 ("btrfs: relocation: Delay reloc tree
> deletion after merge_reloc_roots"), reloc tree lifespan is extended.
> 
> Although we always set root->reloc_root to NULL before we drop the reloc
> tree, but that's not multi-core safe since we have no proper memory
> barrier to ensure other cores can see the same root->reloc_root.
> 
> The proper root fix should be some proper root refcount, and make
> btrfs_drop_snapshot() to wait for all other root owner to release the
> root before dropping it.

This would block cleaning deleted subvolumes, no? We can skip the dead
tree (and add it back to the list) in that can and not wait. The
cleaner thread is able to process the list repeatedly.

> But for now, let's just check the DEAD_RELOC_ROOT bit before accessing
> root->reloc_root.

Ok, the bit is safe way to sync that as long as the correct order of
setting/clearing is done.  The ops are atomic wrt to the value itself
but need barriers around as they're simple atomic ops (not RMW,
according to Documentation/atomic_bitops.txt) and there's no outer
synchronization.

Check:

	smp_mb__before_atomic();
	if (test_bit() ...)
		return;

Set:

	set_bit()
	smp_mb__after_atomic();
	(delete reloc_root)
	reloc_root = NULL

Clearing of the bit is done when there are not potential other users so
that part does not need the barrier (I think).

The checking part could use a helper so we don't have barriers scattered
around code.
