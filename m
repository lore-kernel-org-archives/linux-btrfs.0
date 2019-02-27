Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E992CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6CF820C01
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfB0QX7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:23:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:54806 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbfB0QX7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 11:23:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 936D7ACC8
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 16:23:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6EC48DA83C; Wed, 27 Feb 2019 17:25:19 +0100 (CET)
Date:   Wed, 27 Feb 2019 17:25:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: balance: Sync the fs before balancing
 metadata chunks
Message-ID: <20190227162519.GX24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190129065739.31707-1-wqu@suse.com>
 <20190225172118.GA24609@twin.jikos.cz>
 <3e574c54-f714-424e-78bb-4a251a864153@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e574c54-f714-424e-78bb-4a251a864153@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 26, 2019 at 01:55:06PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/2/26 上午1:21, David Sterba wrote:
> > On Tue, Jan 29, 2019 at 02:57:39PM +0800, Qu Wenruo wrote:
> >> The most straightforward is to sync the fs before balancing metadata
> >> chunks.
> >>
> >> We could enhance the kernel bytes_may_use calculation, but I doubt about
> >> the complexity.
> >> So I take the easy fix to reduce the false ENOSPC reports.
> > 
> > Agreed.
> > 
> >> +	/*
> >> +	 * There may be many over-reserved space for metadata block groups,
> >> +	 * especially for inlined file extents.
> >> +	 *
> >> +	 * Do a sync here will free those over-reserved space and hugely
> >> +	 * reduce the possibility of some false ENOSPC
> >> +	 */
> >> +	if (args->flags & BTRFS_BALANCE_METADATA) {
> >> +		ret = btrfs_util_sync(path);
> > 
> > As the fd is already open, we should use the _fd version,
> > 
> >> +		if (ret) {
> >> +			error("failed to sync the fs before balance: %m");
> >> +			ret = -errno;
> >> +			goto out;
> > 
> > and possibly only warn if there's an error returned as the sync failure
> > is not a critical condition.
> 
> AFAIK if we can't even sync the fs, the balance is definitely going to
> fail, as the most common failure mode for syncfs is RO fs, caused by
> aborted transaction.
> 
> Thus I still think we should error out. Or is there some other
> non-critical failure mode I missed?

The read-only filesystem will be checked when balance starts, that's
where it gets reported.
