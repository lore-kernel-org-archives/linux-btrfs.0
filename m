Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B1AC67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 07:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D575B2075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 07:53:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D575B2075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbeJWQPp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 12:15:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:53154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727017AbeJWQPp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 12:15:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1328AEBB;
        Tue, 23 Oct 2018 07:53:30 +0000 (UTC)
Date:   Tue, 23 Oct 2018 09:53:30 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Olof Johansson <olof@lixom.net>, dsterba@suse.de,
        linux-btrfs@vger.kernel.org, clm@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: Circular lock dep in btrfs triggered by shrinker
Message-ID: <20181023075330.GP18839@dhcp22.suse.cz>
References: <20181022100726.5hwvc5xswg3k3a2f@localhost>
 <20181022182243.GM16290@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022182243.GM16290@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon 22-10-18 20:22:43, David Sterba wrote:
> On Mon, Oct 22, 2018 at 03:07:26AM -0700, Olof Johansson wrote:
> > I hit the below circular locking dependency. Seems like the assumption made in
> > 712e36c5f2a7fa56 ("btrfs: use GFP_KERNEL in btrfs_alloc_inode") either isn't
> > true, or has since changed?
> 
> I think it must have been there from the beginning. There were reports
> of this lockdep warning like the below and IIRC a few more
> (https://lkml.kernel.org/r/20180627120523.GA2287@suse.cz), but without a
> resolution.
> 
> Incidentally, there was a fix that's now in the 4.20 pull and only after
> I had seen your report I realized that it was the fix for the warning:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git/commit/?h=for-4.20-part1&id=84de76a2fb217dc1b6bc2965cc397d1648aa1404
> 
> It disables the filesystem allocations using the memalloc_nofs mechanism
> around free space inode allocation, while my original patch expected
> only regular inodes created by VFS.

Wouldn't it be better/possible to take the mark the scope at the higher
level where you take the trans handle?
-- 
Michal Hocko
SUSE Labs
