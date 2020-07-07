Return-Path: <SRS0=Adlh=AS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFB3C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jul 2020 16:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6A72065D
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jul 2020 16:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgGGQRO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 12:17:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:37794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgGGQRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Jul 2020 12:17:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 89101AF73;
        Tue,  7 Jul 2020 16:17:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7E763DA818; Tue,  7 Jul 2020 18:16:54 +0200 (CEST)
Date:   Tue, 7 Jul 2020 18:16:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Hans van Kranenburg <hans@knorrie.org>
Subject: Re: [PATCH RFC 2/2] btrfs: space-info: Don't allow signal to
 interrupt ticket waiting
Message-ID: <20200707161654.GC16141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Hans van Kranenburg <hans@knorrie.org>
References: <20200706074435.52356-1-wqu@suse.com>
 <20200706074435.52356-3-wqu@suse.com>
 <9ca1e526-6149-c5f2-402f-6e7331ac02ea@toxicpanda.com>
 <8f742315-6f47-771e-234e-98d7428c2f5b@suse.com>
 <d01c2c4a-0c3e-c599-fd64-715c000ad31f@toxicpanda.com>
 <13f7d3b6-e555-38cc-b73c-817bab70924c@gmx.com>
 <9cc6e3ff-ef7f-0948-f55c-b940364cf67f@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9cc6e3ff-ef7f-0948-f55c-b940364cf67f@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 06, 2020 at 10:33:56AM -0400, Josef Bacik wrote:
> On 7/6/20 10:05 AM, Qu Wenruo wrote:
> >> This only needs to be handled for FLUSH_ALL and FLUSH_STEAL.  Anybody
> >> doing btrfs_start_transaction() should be able to fail with -EINTR,
> >> because they should be close to the syscall path.  Balance needs to be
> >> fixed to deal with it, and I assume there might be a few other places,
> >> but by-in-large none of these places should flip read only.  Thanks,
> > 
> > There are already ones existing, for btrfs_drop_snapshot().
> > 
> > This is mostly caused by btrfs_delalloc_reserve_metadata(), which always
> > use FLUSH_ALL unless there is a running trans or its space cache inode.
> > 
> > But still, for a lot of relocation code, we don't really want to bother
> > the EINTR and just want uninterruptible at least for now.
> > 
> > Any idea for that?
> > Or just rework how we handle errors in a lot of places?
> > 
> > It doesn't look correct for such a low level mechanism to return -EINTR
> > while most of callers doesn't really want to bother.
> > 
> 
> That's the point, most callers shouldn't have to, because most callers shouldn't 
> be far enough into their operations that -EINTR causes problems.

Agreed, that's a sane pattern to follow so we should convert the
remaining cases, perhaps also auditing all existing
btrfs_start_transaction calls but after a quick look I haven't spotted
anything else than the reloc and drop snapshot.

> We should probably just change btrfs_drop_snapshot to use join, and then have it 
> do any space reservation it needs outside of the trans handle.  The other option 
> is a FLUSH_ALL_UNKILLABLE.  Thanks,

I'd rather not push the killable semantics to the flushing state machine
and let it up to the caller context to decide.
