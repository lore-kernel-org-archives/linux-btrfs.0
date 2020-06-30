Return-Path: <SRS0=P7ik=AL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B16C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 08:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC81E20759
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 08:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbgF3IvH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 04:51:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:36244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbgF3IvG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jun 2020 04:51:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1F12CADF8;
        Tue, 30 Jun 2020 08:51:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 01F78DA790; Tue, 30 Jun 2020 10:50:49 +0200 (CEST)
Date:   Tue, 30 Jun 2020 10:50:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Hans van Kranenburg <hans@knorrie.org>
Cc:     dsterba@suse.cz, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Message-ID: <20200630085049.GV27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Hans van Kranenburg <hans@knorrie.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20200626150107.19666-1-johannes.thumshirn@wdc.com>
 <20200626200619.GI27795@twin.jikos.cz>
 <e59c3b69-d10c-198d-2f69-b3936f908a73@knorrie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e59c3b69-d10c-198d-2f69-b3936f908a73@knorrie.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jun 27, 2020 at 11:01:36PM +0200, Hans van Kranenburg wrote:
> > There's effectively no change in the implementation, other than
> > documenting the 'in' semantics.
> > 
> > Although this is basically the same situation as in the LOGICAL_INO v1
> > and v2, the number of users of FS_INFO ioctl is presumably not high and
> > the buffer has been write-only so far, there's no existing logic that
> > would had to be tweaked.
> > 
> > Once the flags are there, all new implementations should take the
> > semantics into account. Therefore I think this is a safe plan, but feel
> > free to poke more holes to that.
> 
> In the V2 thread you mentioned generation, metadata_uuid, total_bytes as
> interesting missing ones. What about adding them just right now directly?

If you mean in the same patch, that would be mixing interface fix with
interface extension, so no, unless there's a really good reason to do
that in one patch.
