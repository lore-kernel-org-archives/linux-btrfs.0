Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA20C433B4
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Apr 2021 11:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0C1C61139
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Apr 2021 11:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhDWLcg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:32:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:42562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhDWLcf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Apr 2021 07:32:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B1F9CB113;
        Fri, 23 Apr 2021 11:31:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 98C9FDA7FE; Fri, 23 Apr 2021 13:29:38 +0200 (CEST)
Date:   Fri, 23 Apr 2021 13:29:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: the missing 4 patches to implement metadata
 write path
Message-ID: <20210423112938.GG7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210406003603.64381-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406003603.64381-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 06, 2021 at 08:35:59AM +0800, Qu Wenruo wrote:
> When adding the comments for subpage metadata code, I inserted the
> comment patch into the wrong position, and then use that patch as a
> separator between data and metadata write path.
> 
> Thus the submitted metadata write path patchset lacks the real functions
> to submit subpage metadata write bio.
> 
> Qu Wenruo (4):
>   btrfs: introduce end_bio_subpage_eb_writepage() function
>   btrfs: introduce write_one_subpage_eb() function
>   btrfs: make lock_extent_buffer_for_io() to be subpage compatible
>   btrfs: introduce submit_eb_subpage() to submit a subpage metadata page

For the record, the patches have been added to 5.13 queue a few days
ago.
