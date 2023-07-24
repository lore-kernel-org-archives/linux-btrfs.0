Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F8BEB64DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Jul 2023 19:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjGXTuN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjGXTuL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2023 15:50:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF2919B2
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2023 12:49:43 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AD42068AFE; Mon, 24 Jul 2023 21:48:44 +0200 (CEST)
Date:   Mon, 24 Jul 2023 21:48:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Burkov <boris@bur.io>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs: consolidate the error handling in
 run_delalloc_nocow
Message-ID: <20230724194844.GB30159@lst.de>
References: <20230724142243.5742-1-hch@lst.de> <20230724142243.5742-4-hch@lst.de> <20230724182737.GA587411@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724182737.GA587411@zen>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 24, 2023 at 11:27:37AM -0700, Boris Burkov wrote:
> > -		return -ENOMEM;
> > -	}
> > +	if (!path)
> > +		goto error;
> 
> nit: I think it's nicer to do ret = -ENOMEM here rather than relying on
> initializion. It makes it less likely for a different change to
> accidentally disrupt the implicit assumption that ret == -ENOMEM.

I kinda like the early initialization version, but I can live with
either variant.

