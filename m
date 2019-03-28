Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15CBC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C07EE20823
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfC1Pxl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:53:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:37528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726173AbfC1Pxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 11:53:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE582AD72;
        Thu, 28 Mar 2019 15:53:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9B58DA8D8; Thu, 28 Mar 2019 16:54:51 +0100 (CET)
Date:   Thu, 28 Mar 2019 16:54:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Btrfs: do not allow trimming when a fs is mounted with
 the nologreplay option
Message-ID: <20190328155451.GO29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20190326104956.10314-1-fdmanana@kernel.org>
 <d828e591-22f6-faf2-76ec-1f52397ba858@suse.com>
 <CAL3q7H56EUFNBBt7ZL8sojzgh=+QJQUzOBBOez75-WVjbCZ4=A@mail.gmail.com>
 <a0adb139-eb89-558e-9017-bca33d871d4f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0adb139-eb89-558e-9017-bca33d871d4f@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:39:45PM +0200, Nikolay Borisov wrote:
> On 26.03.19 г. 14:35 ч., Filipe Manana wrote:
> > On Tue, Mar 26, 2019 at 12:17 PM Nikolay Borisov <nborisov@suse.com> wrote:
> >> On 26.03.19 г. 12:49 ч., fdmanana@kernel.org wrote:
> >>> From: Filipe Manana <fdmanana@suse.com>
> >>>
> >>> Whan a filesystem is mounted with the nologreplay mount option, which
> >>> requires it to be mounted in RO mode as well, we can not allow discard on
> >>> free space inside block groups, because log trees refer to extents that
> >>> are not pinned in a block group's free space cache (pinning the extents is
> >>> precisely the first phase of replaying a log tree).
> >>>
> >>> So do not allow the fitrim ioctl to do anything when the filesystem is
> >>> mounted with the nologreplay option, because later it can be mounted RW
> >>> without that option, which causes log replay to happen and result in
> >>> either a failure to replay the log trees (leading to a mount failure), a
> >>> crash or some silent corruption.
> >>>
> >>> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >>
> >> Does it make sense to make the check a bit more specific and only return
> >> EROFS when NOLOGREPLAY and the log tree has non-null generation?
> > 
> > It would make sense checking if there's actually a log tree as well.
> > Neither the xfs nor ext4 (which is already in Linus' tree) do such
> > equivalent checks, nor the proposed fstests test case makes sure a
> > journal/log exists.
> > 
> > Not against it, but this isn't a common use case either.
> 
> I think of this as sorts of "optimisation" where if we don't have a tree
> then we can allow trim. Though this is much simpler so I'm fine with it
> as well.

Agreed, the simple solution sounds ok to me, trim is not a critical
operation so we don't need to try harder to make it work even with the
mount option.
