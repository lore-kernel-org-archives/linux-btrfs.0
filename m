Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0ABC10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE42E20656
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388528AbfDRNDs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:03:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:35828 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729497AbfDRNDs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 09:03:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C13CB656
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 13:03:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D4F34DA871; Thu, 18 Apr 2019 15:04:54 +0200 (CEST)
Date:   Thu, 18 Apr 2019 15:04:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] Simplifications around submit_bio_hook
Message-ID: <20190418130454.GL20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190410142443.6470-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410142443.6470-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 10, 2019 at 05:24:37PM +0300, Nikolay Borisov wrote:
> I've been taking a look at the submit_bio_hook et al  and I saw some
> opportunities for improvement. First I begin by simplifying the definition of 
> submit_bio_hook callback and making one of its arguments explicit. 
> 
> Patch 3 removes a redundant extent_io_tree argument that was passed through 
> several layers of functions and ultimately made it somewhat cumbersome to reason
> what extent_io_tree is being used. 
> 
> Patch 4 and 5 hardcode a 0 being passed  for the bio_offset parameter to
> btrfs_submit_bio_start/btree_submit_bio_start since it only matters for DIO. 
> 
> Patch 6 finally does away with the bio_offset parameter of submit_bio_hook. 
> 
> Here is the output of bloat-o-meter for posterity:
> 
> add/remove: 0/0 grow/shrink: 4/7 up/down: 48/-319 (-271)
> Function                                     old     new   delta
> read_extent_buffer_pages                     784     822     +38
> btrfs_add_ordered_sum                        100     104      +4
> btrfs_submit_bio_hook                        364     367      +3
> btree_submit_bio_hook                        175     178      +3
> end_bio_extent_readpage                     2119    2116      -3
> btrfs_reloc_clone_csums                      272     262     -10
> btrfs_csum_one_bio                          1358    1348     -10
> btree_read_extent_buffer_pages               282     272     -10
> readahead_tree_block                          73      55     -18
> reada_tree_block_flagged                     194     165     -29
> submit_one_bio                               313      74    -239
> Total: Before=1072719, After=1072448, chg -0.03%
> 
> Nikolay Borisov (6):
>   btrfs: Define submit_bio_hook's type directly
>   btrfs: Change submit_bio_hook to taking an inode directly
>   btrfs: Remove 'tree' argument from read_extent_buffer_pages
>   btrfs: Pass 0 for bio_offset to btrfs_wq_submit_bio
>   btrfs: Always pass 0 bio_offset for btree_submit_bio_start
>   btrfs: Remove bio_offset argument from submit_bio_hook

Patchset added to misc-next, thanks.
