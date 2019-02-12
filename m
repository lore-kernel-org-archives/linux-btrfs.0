Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737AFC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 14:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F53E20838
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 14:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbfBLOT6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:19:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:39150 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730157AbfBLOT5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 09:19:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6A64EAECE;
        Tue, 12 Feb 2019 14:19:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0BC91DA84E; Tue, 12 Feb 2019 15:19:16 +0100 (CET)
Date:   Tue, 12 Feb 2019 15:19:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
Message-ID: <20190212141916.GB2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20190116160057.22040-1-josef@toxicpanda.com>
 <2bdd075d-2c56-611b-c0a0-4126d27daec5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bdd075d-2c56-611b-c0a0-4126d27daec5@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 12, 2019 at 01:07:19PM +0800, Qu Wenruo wrote:
> > @@ -1288,11 +1290,13 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
> >  					ret = -EIO;
> >  					goto out;
> >  				}
> > -				btrfs_tree_read_lock(eb);
> > +				if (!path->skip_locking)
> > +					btrfs_tree_read_lock(eb);
> >  				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> 
> This btrfs_set_lock_blocking_rw() or the btrfs_set_lock_blocking_read()
> in latest misc-next call need @eb to be read locked first.
> 
> So this line should also be in the (!path->skip_locking) branch, and
> such modification solves the BUG_ON() caused by btrfs/007.

Thanks.  btrfs_set_lock_blocking_rw is gone from misc-next so the patch
needs a refresh and resend, besides passing fstests of course.
