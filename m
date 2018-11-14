Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA10C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53D982077C
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:53:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53D982077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbeKOF6W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 00:58:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:58264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725814AbeKOF6W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 00:58:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8404EAEF0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 19:53:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 87E9FDACE4; Wed, 14 Nov 2018 20:53:27 +0100 (CET)
Date:   Wed, 14 Nov 2018 20:53:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/6] btrfs: unconditionally provide function prototypes
 from free-space-tree.h
Message-ID: <20181114195325.GK24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <20181114133520.16069-7-jthumshirn@suse.de>
 <f08d71fa-9e30-cd19-8389-ee8b4ef09212@suse.com>
 <d83aafb8-afd1-74a6-d961-1202dc114dd7@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d83aafb8-afd1-74a6-d961-1202dc114dd7@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 02:54:37PM +0100, Johannes Thumshirn wrote:
> On 14/11/2018 14:52, Nikolay Borisov wrote:
> > I agree with this patch, however you go into the gray area of
> > "everything which is exported should have btrfs_ prefix". It's up to
> > David to see if he is content with this change.
> 
> Yep you're right. I think I should change it, but I'll wait for David's
> response first.

There's one prior example of the conditionally exported functions:
btrfs_find_lock_delalloc_range . This function declaration and
definition are under the ifdef and it's a simple wrapper around a static
function find_lock_delalloc_range.

I'd do the same for the functions in your list, where applies. A static
function can be better optimized and I don't want to make it harder for
the compiler just to have it exported for the tests. They're not enabled
by default and never in production builds.

So:

free-space-tree.h:

#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS

struct btrfs_free_space_info *btrfs_search_free_space_info(
	struct btrfs_trans_handle *trans, struct btrfs_fs_info *fs_info,
	struct btrfs_block_group_cache *block_group, struct btrfs_path *path,
	int cow);
...

#endif

free-space-tree.c:

#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS

struct btrfs_free_space_info *btrfs_search_free_space_info(
	struct btrfs_trans_handle *trans, struct btrfs_fs_info *fs_info,
	struct btrfs_block_group_cache *block_group, struct btrfs_path *path,
	int cow)
{
	return search_free_space_info(trans, fs_info, block_group, path, cow);
}

...

#endif

I hope it's a reasonable compromise among the options.
