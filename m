Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE13C433C1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Mar 2021 12:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C312061A0A
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Mar 2021 12:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhCYMKQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 08:10:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:38568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhCYMKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Mar 2021 08:10:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A956DAC16;
        Thu, 25 Mar 2021 12:10:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2F70DA732; Thu, 25 Mar 2021 13:08:02 +0100 (CET)
Date:   Thu, 25 Mar 2021 13:08:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 26/44] btrfs: track qgroup released data in
 own variable in insert_prealloc_file_extent
Message-ID: <20210325120802.GK7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-26-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325112459.1926846-26-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:24:41AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit fbf48bb0b197e6894a04c714728c952af7153bf3 ]
> 
> There is a piece of weird code in insert_prealloc_file_extent(), which
> looks like:
> 
> 	ret = btrfs_qgroup_release_data(inode, file_offset, len);
> 	if (ret < 0)
> 		return ERR_PTR(ret);
> 	if (trans) {
> 		ret = insert_reserved_file_extent(trans, inode,
> 						  file_offset, &stack_fi,
> 						  true, ret);
> 	...
> 	}
> 	extent_info.is_new_extent = true;
> 	extent_info.qgroup_reserved = ret;
> 	...
> 
> Note how the variable @ret is abused here, and if anyone is adding code
> just after btrfs_qgroup_release_data() call, it's super easy to
> overwrite the @ret and cause tons of qgroup related bugs.
> 
> Fix such abuse by introducing new variable @qgroup_released, so that we
> won't reuse the existing variable @ret.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch is a preparatory work and does not make sense for backport
standalone. Either this one plus
https://lore.kernel.org/linux-btrfs/20210303104152.105877-2-wqu@suse.com/
or neither. And IIRC it does not apply directly and needs some
additional review before it can be backported to older code base, so it
has no CC: stable tags.
