Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708A0C433EF
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jun 2022 12:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbiFBMH6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 08:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiFBMHy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2022 08:07:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196DA20043F;
        Thu,  2 Jun 2022 05:07:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3D0D768AFE; Thu,  2 Jun 2022 14:07:44 +0200 (CEST)
Date:   Thu, 2 Jun 2022 14:07:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/9] btrfs: test repair with sectors corrupted in
 multiple mirrors
Message-ID: <20220602120743.GA27700@lst.de>
References: <20220524071838.715013-1-hch@lst.de> <20220524071838.715013-9-hch@lst.de> <20220602113056.GA3347231@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602113056.GA3347231@falcondesktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 02, 2022 at 12:30:56PM +0100, Filipe Manana wrote:
> On Tue, May 24, 2022 at 09:18:37AM +0200, Christoph Hellwig wrote:
> > Test that repair handles the case where it needs to read from more than
> > a single mirror on the raid1c3 profile.
> 
> The test currently fails (at least on current misc-next branch), as the
> repair does not happen, see below. Is it a bug in the repair code for
> raid1c3 (I haven't checked)?

Yes, it only repairs the previously bad copy and doesn't propagate
the repair.

> Also why only raid1c3 coverage and not raid1c4 as well?

Because I've really wanted any coverage at all for mutiple mirror
repair operations.  raid1c4 is probably useful to test, but won't
increase the coverage of the read repair code much.
