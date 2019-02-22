Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DF1C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 14:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C8BB2075A
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 14:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfBVOdi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:33:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:52684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbfBVOdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 09:33:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A66AADE1;
        Fri, 22 Feb 2019 14:33:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BC0B4DAA56; Fri, 22 Feb 2019 15:34:53 +0100 (CET)
Date:   Fri, 22 Feb 2019 15:34:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove assertion when searching for a key in a
 node/leaf
Message-ID: <20190222143453.GC9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190220111143.15911-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220111143.15911-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 20, 2019 at 11:11:43AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> At ctree.c:key_search(), the assertion that verifies the first key on a
> child extent buffer corresponds to the key at a specific slot in the
> parent has a disadvantage: we effectively hit a BUG_ON() which requires
> rebooting the machine later. It also does not tell any information about
> which extent buffer is affected, from which root, the expected and found
> keys, etc.
> 
> However as of commit 581c1760415c48 ("btrfs: Validate child tree block's
> level and first key"), that assertion is not needed since at the time we
> read an extent buffer from disk we validate that its first key matches the
> key, at the respective slot, in the parent extent buffer. Therefore just
> remove the assertion at key_search().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
