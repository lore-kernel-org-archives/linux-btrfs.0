Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E884AEB64DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jul 2023 15:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjGSPZx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 11:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjGSPZw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2023 11:25:52 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F931FD3;
        Wed, 19 Jul 2023 08:25:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 805CE67373; Wed, 19 Jul 2023 17:25:29 +0200 (CEST)
Date:   Wed, 19 Jul 2023 17:25:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: small writeback fixes
Message-ID: <20230719152529.GA434@lst.de>
References: <20230713130431.4798-1-hch@lst.de> <20230718171744.GA843162@perftesting> <20230719053901.GA3241@lst.de> <20230719115010.GA15617@lst.de> <20230719143032.GA856129@perftesting>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719143032.GA856129@perftesting>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 19, 2023 at 10:30:32AM -0400, Josef Bacik wrote:
> I backed your patches out and re-ran and I hit hangs with generic/475 still, so
> I think you're clear.  There's something awkward going on here, the below hang
> just looks like we're waiting for IO.  The caching thread is blocking the
> transaction commit because it's trying to read some old blocks, and it's been
> waiting for them to come back for 2 minutes.  That's holding everybody else up.
> I'll dig into all of this, misc-next is definitely fucked somehow, your stuff
> may just be a victim.  Thanks,

Yes.  I think this has shown up in misc-next as so far I've not
been able to reproduce anything on 6.5-rc2.
