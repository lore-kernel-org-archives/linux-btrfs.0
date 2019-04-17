Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DF1C10F12
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27D9C2073F
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfDQJah (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:30:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:51268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbfDQJag (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 05:30:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D0DD3AC84;
        Wed, 17 Apr 2019 09:30:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 789BCDA871; Wed, 17 Apr 2019 11:31:43 +0200 (CEST)
Date:   Wed, 17 Apr 2019 11:31:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] cleanup property and extended attribute set
Message-ID: <20190417093142.GC20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190412080259.5192-1-anand.jain@oracle.com>
 <20190415190117.GA20156@twin.jikos.cz>
 <5e49b381-ef69-f9d9-c934-7122bbc5406b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e49b381-ef69-f9d9-c934-7122bbc5406b@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 06:01:58AM +0800, Anand Jain wrote:
> 
> 
> On 16/4/19 3:01 am, David Sterba wrote:
> > On Fri, Apr 12, 2019 at 04:02:53PM +0800, Anand Jain wrote:
> >> In an attempt to stream line the property and extended attribute set here
> >> are the few cleanup patches.
> >>
> >>   1/6 to 3/6 are mostly non functional cleanups (except for the conversion
> >>    to non static function in 3/6) and can be merged together.
> >>   4/6 removes the readonly root check in btrfs_setxattr() more details in
> >>    the change log.
> >>   5/6 as now we have btrfs_setxattr() and btrfs_setxattr_trans() for the
> >>    threads with transaction and without transaction respectively, so this
> >>    patch uses them.
> >>   6/6 as 5/6 as diverted the threads with transaction to btrfs_setxattr(),
> >>    now btrfs_setxattr_trans() can drop the trans arg.
> >>
> >> Anand Jain (6):
> >>    btrfs: rename btrfs_setxattr to btrfs_setxattr_trans
> >>    btrfs: rename do_setxattr to btrfs_setxattr
> >>    btrfs: declare btrfs_setxattr as a non static function
> >>    btrfs: remove redundant readonly root check in btrfs_setxattr_trans
> >>    btrfs: split thread with trans to use btrfs_setxattr
> >>    btrfs: cleanup btrfs_setxattr_trans drop trans arg
> > 
> > Looks good to me, thanks. The result is very close to what the previous
> > patchset did. Patchset will go to for-next soon.
> > 
> 
> Thanks. On top of these, I am writing patches to merge 
> start_transactions in btrfs_ioctl_setflags().

My current idea how to change btrfs_ioctl_setflags is like that (but I
haven't prototyped it so it might not work):

- don't change binode->flags directly, but do all flag updates on a
  temporary variable

- if a property needs to be changed, do validation first, then start
  transaction and pass it to the property handler

- in the finalizing code, start a transaction unless it's been started
  already, apply the iflags and end transaction

This means there are up to 4 starting points of transaction, but the
property validation should never fail between start/end region. There
are other potential failures due to ENOMEM or ENOSPC, but that's the
general set of errors we can't avoid.
