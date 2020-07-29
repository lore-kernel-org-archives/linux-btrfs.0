Return-Path: <SRS0=lAVn=BI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25925C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 09:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE462068F
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 09:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgG2J6z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 05:58:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:53514 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgG2J6z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Jul 2020 05:58:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F406AC37;
        Wed, 29 Jul 2020 09:59:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 72E7BDA882; Wed, 29 Jul 2020 11:58:25 +0200 (CEST)
Date:   Wed, 29 Jul 2020 11:58:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs-progs: Add basic .editorconfig
Message-ID: <20200729095825.GY3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Daniel Xu <dxu@dxuuu.xyz>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20200728125732.GS3703@twin.jikos.cz>
 <C4IFKD9DTBS7.15BFX5LGQB0O5@maharaja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4IFKD9DTBS7.15BFX5LGQB0O5@maharaja>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 28, 2020 at 10:24:31AM -0700, Daniel Xu wrote:
> On Tue Jul 28, 2020 at 5:57 AM PDT, David Sterba wrote:
> > On Tue, Jul 28, 2020 at 08:12:40PM +0800, Qu Wenruo wrote:
> > > >>> +trim_trailing_whitespace = true
> > > >>
> > > >> Does this setting apply on lines that get changed or does it affect the
> > > >> whole file? If it's just for the lines, then it's what we want.
> > > >>
> > > > At least from the vim plugin code, it's just for the new lines:
> > > > 
> > > > https://github.com/editorconfig/editorconfig-vim/blob/0a3c1d8082e38a5ebadcba7bb3a608d88a9ff044/plugin/editorconfig.vim#L494
> > > > 
> > > > It just call the replace on the current line.
> > > 
> > > My bad, %s, it replaces all existing lines...
> >
> > So this would introduce unrelated changes, but it seems that we don't
> > have much trailing whitespaces in progs codebase:
> >
> > $ git grep '\s\+$'
> > btrfs-fragments.c:
> > btrfs-fragments.c: black = gdImageColorAllocate(im, 0, 0, 0);
> > crypto/crc32c.c:/*
> > crypto/crc32c.c: *
> > crypto/crc32c.c: * Software Foundation; either version 2 of the License,
> > or (at your option)
> > crypto/crc32c.c: * Steps through buffer one byte at at time, calculates
> > reflected
> > crypto/crc32c.c: * Steps through buffer one byte at at time, calculates
> > reflected
> > kernel-lib/radix-tree.h: *
> > kernel-lib/radix-tree.h: *
> > kernel-lib/rbtree.c: node = node->rb_right;
> > kernel-lib/rbtree.c: node = node->rb_left;
> > kernel-lib/rbtree.h:
> >
> > filtering only the sources. So let's keep it in the config.
> 
> Sounds good. Should I send a followup patch to delete the existing
> trailing lines?

That's all in files that are synced from kernel and we won't need to
edit them anyway.
