Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7362BC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 19:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52A3A218D3
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 19:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfCUTJK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:09:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:41094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727976AbfCUTJK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 15:09:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F156AEFF;
        Thu, 21 Mar 2019 19:09:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A0E6CDA824; Thu, 21 Mar 2019 20:10:22 +0100 (CET)
Date:   Thu, 21 Mar 2019 20:10:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH][RFC] btrfs: fix relocation panic
Message-ID: <20190321191022.GB28481@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
References: <20190225161445.2025-1-josef@toxicpanda.com>
 <CAL3q7H6qPTDXrHRE0wngm5gX5syTmWFW862E6raYco5V_e3h2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6qPTDXrHRE0wngm5gX5syTmWFW862E6raYco5V_e3h2Q@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 05:45:51PM +0000, Filipe Manana wrote:
> On Mon, Feb 25, 2019 at 4:16 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > We've been seeing the following sporadically throughout our fleet
> >
> > panic: kernel BUG at fs/btrfs/relocation.c:4584!
> > netversion: 5.0-0
> > Backtrace:
> >  #0 [ffffc90003adb880] machine_kexec at ffffffff81041da8
> >  #1 [ffffc90003adb8c8] __crash_kexec at ffffffff8110396c
> >  #2 [ffffc90003adb988] crash_kexec at ffffffff811048ad
> >  #3 [ffffc90003adb9a0] oops_end at ffffffff8101c19a
> >  #4 [ffffc90003adb9c0] do_trap at ffffffff81019114
> >  #5 [ffffc90003adba00] do_error_trap at ffffffff810195d0
> >  #6 [ffffc90003adbab0] invalid_op at ffffffff81a00a9b
> >     [exception RIP: btrfs_reloc_cow_block+692]
> >     RIP: ffffffff8143b614  RSP: ffffc90003adbb68  RFLAGS: 00010246
> >     RAX: fffffffffffffff7  RBX: ffff8806b9c32000  RCX: ffff8806aad00690
> >     RDX: ffff880850b295e0  RSI: ffff8806b9c32000  RDI: ffff88084f205bd0
> >     RBP: ffff880849415000   R8: ffffc90003adbbe0   R9: ffff88085ac90000
> >     R10: ffff8805f7369140  R11: 0000000000000000  R12: ffff880850b295e0
> >     R13: ffff88084f205bd0  R14: 0000000000000000  R15: 0000000000000000
> >     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> >  #7 [ffffc90003adbbb0] __btrfs_cow_block at ffffffff813bf1cd
> >  #8 [ffffc90003adbc28] btrfs_cow_block at ffffffff813bf4b3
> >  #9 [ffffc90003adbc78] btrfs_search_slot at ffffffff813c2e6c
> >
> > The way relocation moves data extents is by creating a reloc inode and
> > preallocating extents in this inode and then copying the data into these
> > preallocated extents.  Once we've done this for all of our extents,
> > we'll write out these dirty pages, which marks the extent written, and
> > goes into btrfs_reloc_cow_block().  From here we get our current
> > reloc_control, which _should_ match the reloc_control for the current
> > block group we're relocating.
> >
> > However if we get an ENOSPC in this path at some point we'll bail out,
> > never initiating writeback on this inode.  Not a huge deal, unless we
> > happen to be doing relocation on a different block group, and this block
> > group is now rc->stage == UPDATE_DATA_PTRS.  This trips the BUG_ON() in
> > btrfs_reloc_cow_block(), because we expect to be done modifying the data
> > inode.  We are in fact done modifying the metadata for the data inode
> > we're currently using, but not the one from the failed block group, and
> > thus we BUG_ON().
> >
> > Fix this by writing out the reloc data inode always, and then breaking
> > out of the loop after that point to keep from tripping this BUG_ON()
> > later.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Perhaps it's worth noting that this happens when writeback finishes
> for extents from the previous group, when we are
> at btrfs_finish_ordered_io() which updates the data reloc tree (inode
> item, drops/adds extent items, etc).
> 
> Anyway, looks good to me as it is.

I'll add it to the changelog, and add the patch to misc-next, thanks.
