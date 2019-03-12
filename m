Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F60C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 18:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 417472087C
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 18:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfCLSGk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:06:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:34278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727485AbfCLRM2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 13:12:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DD0AAF79;
        Tue, 12 Mar 2019 17:12:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2497DDA8D5; Tue, 12 Mar 2019 18:13:43 +0100 (CET)
Date:   Tue, 12 Mar 2019 18:13:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix file corruption after snapshotting due to
 mix of buffered/DIO writes
Message-ID: <20190312171342.GZ31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190204142810.1800-1-fdmanana@kernel.org>
 <20190227134230.11860-1-fdmanana@kernel.org>
 <20190227172629.GB24609@twin.jikos.cz>
 <CAL3q7H4a6VjrFnxRtZVxdsjt7=bTGJCiXACyYDcEsCif7SHHcw@mail.gmail.com>
 <20190227183149.GB31119@twin.jikos.cz>
 <CAL3q7H4eJr5ymDgYFa0DTxPif=7yrOhqMFhvsByijbKjM+=UUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4eJr5ymDgYFa0DTxPif=7yrOhqMFhvsByijbKjM+=UUg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 06:56:10PM +0000, Filipe Manana wrote:
> > > What do you expect by falling back to writeback_inodes_sb()?
> > > It all ends up going through the same btrfs writeback path.
> > > And as I left it, if an error happens for one root, it still tries to
> > > flush writeback for all the remaining roots as well, so I don't get it
> > > why you fallback to writeback_inodes_sb().
> >
> > As I read the changelog, you say that the corruption does not happen
> > with FLUSHONCOMMIT, which does writeback_inodes_sb. Using that would be
> > too heavy, thus you only start the delalloc on snapshotted roots.
> 
> It does not happen with flushoncommit because delalloc is flushed for all roots.
> If flushoncommit (writeback_inodes_sb()) would flush only for roots
> that are about to be snapshotted, the corruption wouldn't happen as
> well.
> 
> >
> > So the idea is to use the same logic of flushoncommit in the unlikely
> > case when btrfs_start_delalloc_snapshot would fail. Only at some
> > performance cost, unless I'm missing something.
> 
> Ok, so I hope the first paragraph above explains why there's no need
> to fallback to the "flush all delalloc for all roots" logic
> (writeback_inodes_sb()).

Yeah, I think I get it now.

> > As for the v2 as you implement it without any error handling, doesn't
> > this allow the corruption to happen? If start_delalloc_inodes has a lot
> > of inodes for which it needs to allocate delalloc_work, the failure is
> > possible. That the list_for_each continues does not affect that
> > particular root.
> 
> Yes, it allows for the corruption to happen, that's why I had the
> error returned in v1.
> 
> writeback_inodes_sb() isn't special in any way - flushing some
> delalloc range can fail the same way, it ends up calling the same
> btrfs writepages() callback. Yes, it doesn't return any error, because
> it's relying on callers either not caring about it, or if they do,
> checking the inode's mapping for an error, which btrfs sets through
> its writepages() callback if any an error happens (by calling
> mapping_set_error()),
> or any other fs specific way of storing/checking for writeback errors.

Ok, so the the error handling needs to stay and there's no simple way
around it.

> If we get an error when flushing the dealloc range from the example in
> the changelog, then the corruption happens, regardless of writeback
> being
> triggered by writeback_inodes_sb() or btrfs_start_delalloc_snapshot().

Thanks for the time discussing that. I'll use code from v1 and the
subject from v2 and add the patch to the queue.
