Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F69C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Jan 2021 10:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B04DC64DD8
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Jan 2021 10:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhA1Kwu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 05:52:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:41548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhA1Kws (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jan 2021 05:52:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E79F6AC97;
        Thu, 28 Jan 2021 10:52:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2BA47DA7D9; Thu, 28 Jan 2021 11:50:19 +0100 (CET)
Date:   Thu, 28 Jan 2021 11:50:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix a bug that btrfs_invalidapge() can double
 account ordered extent for subpage
Message-ID: <20210128105019.GI1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20210127063848.72528-1-wqu@suse.com>
 <CAL3q7H4kBWVewu8-yof-xzEZ1q24Xrz_h7hZHrOPEj_=9Lh1zA@mail.gmail.com>
 <d4a1aae2-6941-0e7b-fbd4-30d28d58b6f5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4a1aae2-6941-0e7b-fbd4-30d28d58b6f5@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 27, 2021 at 06:52:04PM +0800, Qu Wenruo wrote:
> On 2021/1/27 下午6:44, Filipe Manana wrote:
> > On Wed, Jan 27, 2021 at 8:29 AM Qu Wenruo <wqu@suse.com> wrote:
> >> As the first iteration will find OE 1, which doesn't cover the full
> >> page, thus after cleanup code, we need to retry again.
> >> But again label will reset start to page_start, and we got OE 1 again,
> >> which causes double account on OE1, and cause OE1's byte_left to
> >> underflow.
> >>
> >> The only good news is, this problem can only happen for subpage case, as
> >> for regular sectorsize == PAGE_SIZE case, we will always find a OE ends
> >> at or after page end, thus no way to trigger the problem.
> >>
> >> This patch will move the again label after start = page_start, to fix
> >> the bug.
> >> This is just a quick fix, which is easy to backport.
> >
> > Hum? Why does it need to be backported?
> > There are no kernel releases that support subpage sector size yet and
> > this does not affect the case where sector size is the same as the
> > page size.
> 
> 
> Hmmm, right, there is no need to backport.
> 
> Hopes David can remove that line when merging.

Yes, I've dropped the 'backport' line and slightly changed the wording
so it sounds like it's preparatory patch.
