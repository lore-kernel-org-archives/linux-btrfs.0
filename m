Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50236C282DD
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 288ED2077C
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfDWLlV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 07:41:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:43896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfDWLlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 07:41:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FAB4AD1E
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2019 11:41:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A8F5BDA7FC; Tue, 23 Apr 2019 13:42:24 +0200 (CEST)
Date:   Tue, 23 Apr 2019 13:42:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 0/9] btrfs: Refactor delayed ref parameter list
Message-ID: <20190423114224.GT20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
 <20190405120609.GV29086@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190405120609.GV29086@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 05, 2019 at 02:06:09PM +0200, David Sterba wrote:
> >               |      base |  w/ patchset |  no qgroups |
> > -------------------------------------------------------------
> > relocated     |     23765 |        23772 |       23811 |
> > qgroup dirty  |    124498 |           70 |           0 |
> > time (sec)    |    23.353 |        3.505 |       3.421 |
> > 
> > 
> > Changelog:
> > v2:
> > - Better documentation for btrfs_ref declaration
> > - Rebase to newer delayed subtree rescan patchset
> > - Add reviewed-by tags
> > - Remove unnecessary ASSERT() for NULL pointer.
> > 
> > v3:
> > - Rebase to misc-next branch as that branch has all prerequisite now.
> > - Update benchmark result, compare with qgroups disabled case directly.
> > 
> > v3.1:
> > - Rebase to misc-next branch.
> 
> This does not seem to exhibit the problems I recall from previous
> testing, so I'll queue it for merge to misc-next unless there are more
> review comments.

Added to misc-next, ie. the argument cleanup and there's the
qgroup+metadata balance improvement. Thanks.
