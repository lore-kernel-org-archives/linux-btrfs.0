Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA132C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 14:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90F0B20685
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 14:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbfCZOde (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:33:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:43964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726285AbfCZOde (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 10:33:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0AEE7B010;
        Tue, 26 Mar 2019 14:33:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1632BDA8A5; Tue, 26 Mar 2019 15:34:43 +0100 (CET)
Date:   Tue, 26 Mar 2019 15:34:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCh v2 1/9] btrfs: Move btrfs_check_chunk_valid() to
 tree-check.[ch] and export it
Message-ID: <20190326143441.GS10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-2-wqu@suse.com>
 <20190325170630.GO10640@twin.jikos.cz>
 <7f08dfa3-2b60-9213-9409-83db61c969b8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f08dfa3-2b60-9213-9409-83db61c969b8@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 07:02:20AM +0800, Qu Wenruo wrote:
> On 2019/3/26 上午1:06, David Sterba wrote:
> > On Wed, Mar 20, 2019 at 02:37:09PM +0800, Qu Wenruo wrote:
> >> By function, chunk item verification is more suitable to be done inside
> >> tree-checker.
> >>
> >> So move btrfs_check_chunk_valid() to tree-checker.c and export it.
> >>
> >> And since it's now moved to tree-checker, also add a better comment for
> >> what this function is doing.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>  fs/btrfs/tree-checker.c | 99 +++++++++++++++++++++++++++++++++++++++++
> >>  fs/btrfs/tree-checker.h |  3 ++
> >>  fs/btrfs/volumes.c      | 94 +-------------------------------------
> >>  3 files changed, 103 insertions(+), 93 deletions(-)
> >>
> >> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> >> index b8cdaf472031..4e44323ae758 100644
> >> --- a/fs/btrfs/tree-checker.c
> >> +++ b/fs/btrfs/tree-checker.c
> >> @@ -448,6 +448,105 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
> >>  	return 0;
> >>  }
> >>  
> >> +/*
> >> + * The common chunk check which could also work on super block sys chunk array.
> >> + *
> >> + * Return -EUCLEAN if anything is corrupted.
> > 
> > Well, that's still confusing if you say EUCLEAN in the commend and use
> > EIO in the code.
> > 
> Oh, that EIO to EUCLEAN change is in later patch (3/9).

Yes, but this patch when viewed on itself is confusing. The EIO->EUCLEAN
in the comment belongs to 3/9 too.

> Do I need to resend the patchset?

No, such small fixups I do myself but I need to point that out so we
reach a common understanding and what's expected.
