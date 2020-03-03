Return-Path: <SRS0=NN0a=4U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4AEC3F2C6
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 15:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78E8C20828
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 15:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgCCPwO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 10:52:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:54560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbgCCPwO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Mar 2020 10:52:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD3E7B4C4;
        Tue,  3 Mar 2020 15:52:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A70EBDA7AE; Tue,  3 Mar 2020 16:51:50 +0100 (CET)
Date:   Tue, 3 Mar 2020 16:51:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: hold a ref on the root->reloc_root
Message-ID: <20200303155150.GG2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20200302184757.44176-1-josef@toxicpanda.com>
 <20200302184757.44176-7-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302184757.44176-7-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 02, 2020 at 01:47:56PM -0500, Josef Bacik wrote:
> We previously were relying on root->reloc_root to be cleaned up by the
> drop snapshot, or the error handling.  However if btrfs_drop_snapshot()
> failed it wouldn't drop the ref for the root.  Also we sort of depend on
> the right thing to happen with moving reloc roots between lists and the
> fs root they belong to, which makes it hard to figure out who owns the
> reference.
> 
> Fix this by explicitly holding a reference on the reloc root for
> roo->reloc_root.  This means that we hold two references on reloc roots,
> one for whichever reloc_roots list it's attached to, and the
> root->reloc_root we're on.
> 
> This makes it easier to reason out who owns a reference on the root, and
> when it needs to be dropped.

I think the functions that add a reference should say that in it's
comment, so it can be easily pairred with btrfs_put_root.

Otherwise yes the explicit references make it easier to see the owner.
