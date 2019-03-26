Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23197C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 13:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26292075C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 13:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731565AbfCZNrJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:47:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:35282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730697AbfCZNrJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 09:47:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95139AD84;
        Tue, 26 Mar 2019 13:47:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 260A5DA8A5; Tue, 26 Mar 2019 14:48:19 +0100 (CET)
Date:   Tue, 26 Mar 2019 14:48:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not allow trimming when a fs is mounted with
 the nologreplay option
Message-ID: <20190326134817.GR10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190326104956.10314-1-fdmanana@kernel.org>
 <d828e591-22f6-faf2-76ec-1f52397ba858@suse.com>
 <dbf7aa7b-3ea8-e5da-eb8f-746cbc5e4487@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dbf7aa7b-3ea8-e5da-eb8f-746cbc5e4487@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 09:40:08PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/3/26 下午8:17, Nikolay Borisov wrote:
> >
> >
> > On 26.03.19 г. 12:49 ч., fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >>
> >> Whan a filesystem is mounted with the nologreplay mount option, which
> >> requires it to be mounted in RO mode as well, we can not allow discard on
> >> free space inside block groups, because log trees refer to extents that
> >> are not pinned in a block group's free space cache (pinning the extents is
> >> precisely the first phase of replaying a log tree).
> >>
> >> So do not allow the fitrim ioctl to do anything when the filesystem is
> >> mounted with the nologreplay option, because later it can be mounted RW
> >> without that option, which causes log replay to happen and result in
> >> either a failure to replay the log trees (leading to a mount failure), a
> >> crash or some silent corruption.
> >>
> >> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >
> > Does it make sense to make the check a bit more specific and only return
> > EROFS when NOLOGREPLAY and the log tree has non-null generation?
> 
> To me fstrim is a WRITE operation, why it is allowed even in RO mount?

It's write to the block device, not to the filesystem.
