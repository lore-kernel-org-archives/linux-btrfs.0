Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE673C43334
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jun 2022 07:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352515AbiFVHrd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 03:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353601AbiFVHrY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Jun 2022 03:47:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA37E37A1A
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2022 00:47:22 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 463FC68AA6; Wed, 22 Jun 2022 09:47:19 +0200 (CEST)
Date:   Wed, 22 Jun 2022 09:47:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: repair all bad mirrors
Message-ID: <20220622074719.GA24601@lst.de>
References: <20220619082821.2151052-1-hch@lst.de> <6490bdce-d5f6-9e59-ba04-41f0fdf8bbff@gmx.com> <20220622050658.GA22104@lst.de> <baeb9e98-fba4-8af9-9fd5-da6e1bd8ee34@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baeb9e98-fba4-8af9-9fd5-da6e1bd8ee34@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 22, 2022 at 01:14:30PM +0800, Qu Wenruo wrote:
>> We need to record at least one failed mirror to be able to repair it, and
>> with the design in this patch we can trivially walk back from the first
>> good mirror to the first bad one.
>
> Then in that case, I guess we can also just submit the good copy to all
> mirrors instead, no matter if it's corrupted or not?

Why would we submit it to a known good mirror?

> But considering repair_io_failure() is still synchronous submission,
> it's definitely going to be slower for RAID1C3/C4.

Yes, two or in the worst case three repair writes are going to be slower
than a single one.  But I think that is worth it for the improved
reliability.

> Just a small nitpick related to the failrec.
> Isn't the whole failrec facility going to be removed after the read
> repair code rework?

Yes.

> So I guess this patch itself is just to solve the test case failure, but
> will still be replaced by the new read repair rework?

I've shifted plans for repair a bit and plan to do more gradual work.
Eventually the failrec should go away in this form, though.
