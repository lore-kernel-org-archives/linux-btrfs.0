Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6069DC282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 18:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42AC42083B
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 18:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbfBESXp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 13:23:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:37442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725921AbfBESXp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 13:23:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4AC32B655;
        Tue,  5 Feb 2019 18:23:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 90BAEDA7E3; Tue,  5 Feb 2019 19:23:05 +0100 (CET)
Date:   Tue, 5 Feb 2019 19:23:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 3/3] btrfs: replace cleaner_delayed_iput_mutex with a
 waitqueue
Message-ID: <20190205182302.GW2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190111152103.17001-1-josef@toxicpanda.com>
 <20190111152103.17001-4-josef@toxicpanda.com>
 <20190116191216.GQ2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116191216.GQ2900@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 08:12:16PM +0100, David Sterba wrote:
> > +/**
> > + * btrfs_wait_on_delayed_iputs - wait on the delayed iputs to be done running
> > + * @fs_info - the fs_info for this fs
> > + * @return - EINTR if we were killed, 0 if nothing's pending
> > + *
> > + * This will wait on any delayed iputs that are currently running with KILLABLE
> > + * set.  Once they are all done running we will return, unless we are killed in
> > + * which case we return EINTR.
> 
> I still wonder from which context the 'killable' property is used.
> 
> btrfs_alloc_data_chunk_ondemand is indirectly inside zero range and
> fallocate, there it makes sense. With flush_space is less obvious, so
> this should be explained in the changelog what's expected.

Something along those lines is now in the changelog and patch goes to
misc-next.
