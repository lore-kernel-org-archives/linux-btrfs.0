Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A62C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF702184A
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733260AbfB1Qvw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:51:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:49122 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733239AbfB1Qvv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 11:51:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5ACB7AEB7
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 16:51:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ED3C4DA944; Thu, 28 Feb 2019 17:53:10 +0100 (CET)
Date:   Thu, 28 Feb 2019 17:53:10 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 05/12] btrfs: Populate ->orig_block_len during
 read_one_chunk
Message-ID: <20190228165310.GN31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190211083510.27591-1-nborisov@suse.com>
 <20190211083510.27591-6-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211083510.27591-6-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 10:35:03AM +0200, Nikolay Borisov wrote:
> Chunks read from disk currently don't get their ->orig_block_len member
> set, in contrast when a new chunk is allocated, the respective
> extent_map's ->orig_block_len is assigned the size of the stripe of this
> chunk. Let's apply the same strategy for chunks which are read from
> disk, not only does this codify the invariant that ->orig_block_len
> always contains the size of the stripe for a chunk (when the em belongs
> to the mapping tree). But it's also a preparatory patch for further work
> around tracking chunk allocation in an extent tree rather than
> pinned/pending lists.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
