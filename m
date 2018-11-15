Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175E1C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 00:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C706321582
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 00:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C706321582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbeKOKP0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 05:15:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:43144 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbeKOKP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 05:15:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 938A6AED5
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 00:09:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4D9A2DACE4; Thu, 15 Nov 2018 01:09:39 +0100 (CET)
Date:   Thu, 15 Nov 2018 01:09:38 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/6] btrfs: unconditionally provide function prototypes
 from free-space-tree.h
Message-ID: <20181115000938.GM24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <20181114133520.16069-7-jthumshirn@suse.de>
 <f08d71fa-9e30-cd19-8389-ee8b4ef09212@suse.com>
 <d83aafb8-afd1-74a6-d961-1202dc114dd7@suse.de>
 <20181114195325.GK24115@twin.jikos.cz>
 <3f14522d-ea93-4be0-2787-aac9916d257c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f14522d-ea93-4be0-2787-aac9916d257c@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 11:05:16PM +0200, Nikolay Borisov wrote:
> 
> 
> On 14.11.18 г. 21:53 ч., David Sterba wrote:
> > On Wed, Nov 14, 2018 at 02:54:37PM +0100, Johannes Thumshirn wrote:
> >> On 14/11/2018 14:52, Nikolay Borisov wrote:
> >>> I agree with this patch, however you go into the gray area of
> >>> "everything which is exported should have btrfs_ prefix". It's up to
> >>> David to see if he is content with this change.
> >>
> >> Yep you're right. I think I should change it, but I'll wait for David's
> >> response first.
> > 
> > There's one prior example of the conditionally exported functions:
> > btrfs_find_lock_delalloc_range . This function declaration and
> > definition are under the ifdef and it's a simple wrapper around a static
> > function find_lock_delalloc_range.
> 
> I have a patch which actually simplifies this somewhat because,
> frankly I find it stupid and redundant to do this frickin' dance for
> functions which are used only in debugging. Here is the diff (still
> not submitted since it's waiting for some other cleanups to be
> merged): 
> 
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1556,10 +1556,13 @@ static noinline int lock_delalloc_pages(struct inode *inode,
>   *
>   * 1 is returned if we find something, 0 if nothing was in the tree
>   */
> -static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
> -                                   struct extent_io_tree *tree,
> -                                   struct page *locked_page, u64 *start,
> -                                   u64 *end)
> +#ifndef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +static
> +#endif
> +noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
> +                                               struct extent_io_tree *tree,
> +                                               struct page *locked_page,
> +                                               u64 *start, u64 *end)

If there's nostatic_for_tests or export_for_tests (possibly all caps),
then ok.
