Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B01C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1EC5206BA
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfDCQ2e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 12:28:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:50412 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbfDCQ2e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 12:28:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 23060AF8F
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 16:28:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4FDD2DA8D8; Wed,  3 Apr 2019 18:29:39 +0200 (CEST)
Date:   Wed, 3 Apr 2019 18:29:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/9] btrfs: Refactor delayed ref parameter list
Message-ID: <20190403162935.GS29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211051653.3167-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 01:16:44PM +0800, Qu Wenruo wrote:
> Qu Wenruo (9):
>   btrfs: delayed-ref: Introduce better documented delayed ref structures
>   btrfs: extent-tree: Open-code process_func in __btrfs_mod_ref
>   btrfs: delayed-ref: Use btrfs_ref to refactor
>     btrfs_add_delayed_tree_ref()
>   btrfs: delayed-ref: Use btrfs_ref to refactor
>     btrfs_add_delayed_data_ref()
>   btrfs: ref-verify: Use btrfs_ref to refactor btrfs_ref_tree_mod()
>   btrfs: extent-tree: Use btrfs_ref to refactor add_pinned_bytes()
>   btrfs: extent-tree: Use btrfs_ref to refactor btrfs_inc_extent_ref()
>   btrfs: extent-tree: Use btrfs_ref to refactor btrfs_free_extent()

If you would like to get the above merged (ie. the parameter cleanup) to
5.2, please refresh and resend on top of current misc-next. I tested
this patchset back then and it did not pass fstests but I haven't
investigated. As this patchset does only a transformation, I'm
suspecting some typo so another look from you would be helpful. Thanks.
