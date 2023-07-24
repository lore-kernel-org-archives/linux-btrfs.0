Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22CEEB64DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Jul 2023 19:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjGXT63 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjGXT62 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2023 15:58:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A611C
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2023 12:58:28 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 54C1E68AA6; Mon, 24 Jul 2023 21:58:24 +0200 (CEST)
Date:   Mon, 24 Jul 2023 21:58:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Burkov <boris@bur.io>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs NOCOW fix and cleanups
Message-ID: <20230724195824.GA30526@lst.de>
References: <20230724142243.5742-1-hch@lst.de> <20230724183033.GB587411@zen> <20230724194923.GC30159@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724194923.GC30159@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 24, 2023 at 09:49:23PM +0200, Christoph Hellwig wrote:
> Yeah, looks like for-next got rebased again today.  I'll rebase and
> push it out to the git tree later today and can resend as needed.

Looks like for-next has in fact pulled this series in already.
