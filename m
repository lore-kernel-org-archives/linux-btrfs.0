Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2866BC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 16:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01AFB2070D
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 16:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfCZQBh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:01:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:36086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728314AbfCZQBh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 12:01:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92DC1AE7F;
        Tue, 26 Mar 2019 16:01:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 910CFDA8D8; Tue, 26 Mar 2019 17:02:48 +0100 (CET)
Date:   Tue, 26 Mar 2019 17:02:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
Message-ID: <20190326160248.GV10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com>
 <a8e3f871-370a-464b-a0ae-f4da93f0eed8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8e3f871-370a-464b-a0ae-f4da93f0eed8@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 12:27:24PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/3/20 下午2:37, Qu Wenruo wrote:
> > There is a report in kernel bugzilla about mismatch file type in dir
> > item and inode item.
> >
> > This inspires us to check inode mode in inode item.
> >
> > This patch will check the following members:
> > - inode key objectid
> >   Should be ROOT_DIR_DIR or [256, (u64)-256] or FREE_INO.
> >
> > - inode key offset
> >   Should be 0
> >
> > - inode item generation
> > - inode item transid
> >   No newer than sb generation + 1.
> >   The +1 is for log tree.
> >
> > - inode item mode
> >   No unknown bits.
> >   No invalid S_IF* bit.
> >   NOTE: S_IFMT check is not enough, need to check every know type.
> >
> > - inode item nlink
> >   Dir should have no more link than 1.
> >
> > - inode item flags
> >
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> There is some bug report of kernel producing free space cache inode with
> mode 0, which is invalid and can be detected by this patch.
> 
> Although the patch itself is good, I'm afraid we need to address the
> invalid inode mode created by old kernel in btrfs-progs at least before
> merging this patch into upstream.

Can this be addressed on the kernel side? Like detecting the invalid
mode, print a warning and the fix on the next write. The progs can
detect and fix that too of course.

So I'll keep the patch working as-is, we can relax the error to a
warning if we're out of time or find out that it needs to be that way
due to backward compatibilit reasons.
