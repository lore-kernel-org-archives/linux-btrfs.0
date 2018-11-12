Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CFAC43610
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BACDB2245E
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BACDB2245E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbeKMEQW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 23:16:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:48460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729133AbeKMEQV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 23:16:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7EBEEAFA6
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 18:21:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 52E8BDAFAE; Mon, 12 Nov 2018 19:21:40 +0100 (CET)
Date:   Mon, 12 Nov 2018 19:21:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2 0/9] Removal of optionsl extent_io_ops callbacks
Message-ID: <20181112182140.GJ24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181109140838.10457-1-nborisov@suse.com>
 <918e21ad-0e82-f18a-1bac-5f3685752089@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <918e21ad-0e82-f18a-1bac-5f3685752089@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 09, 2018 at 04:12:20PM +0200, Nikolay Borisov wrote:
> 
> 
> On 9.11.18 г. 16:08 ч., Nikolay Borisov wrote:
> > Here is the 2nd revision of the extent_io_ops optinal callbacks removal. What 
> > prompted this version was that I identified a flaw in the initial version - while
> > it did check for the presence of an inode in extent_io_tree::private_data, i 
> > forgot to explicitly check the ino to be different than the ino of the btree inode. 
> > 
> > While this doesn't lead to any corruption or risks at the moment it results in 
> > additional operation being performed on the btree inode io_tree. 
> > 
> > This is now fixed by introducing a new function in the first patch and changing
> > everything that follows to utilize it in addition to the presence of ->private_data
> > 
> > Testing with xfstests didn't uncover any regressions so this series should be 
> > good to replace the on in misc-next. 
> > 
> > Nikolay Borisov (9):
> >   btrfs: Add function to distinguish between data and btree inode
> >   btrfs: Remove extent_io_ops::fill_delalloc
> >   btrfs: Remove extent_io_ops::writepage_start_hook
> >   btrfs: Remove extent_io_ops::writepage_end_io_hook
> >   btrfs: Remove extent_io_ops::check_extent_io_range callback
> >   btrfs: Remove extent_io_ops::set_bit_hook extent_io callback
> >   btrfs: Remove extent_io_ops::clear_bit_hook callback
> >   btrfs: Remove extent_io_ops::merge_extent_hook callback
> >   btrfs: Remove extent_io_ops::split_extent_hook callback
> 
> Actually patches 2/3/4 are not affected by the problem. Only the rest so
> David you might want to use only them + the 1 one that introduces the
> new function.

THanks for the update. I've replaced the additional checks manually.
