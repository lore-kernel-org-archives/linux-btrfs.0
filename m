Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C345C43334
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 Jun 2022 04:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiF3EXG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 00:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiF3EXD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Jun 2022 00:23:03 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC06377C5
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2022 21:23:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B804168AA6; Thu, 30 Jun 2022 06:23:00 +0200 (CEST)
Date:   Thu, 30 Jun 2022 06:23:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Burkov <boris@bur.io>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: pass a btrfs_bio to btrfs_repair_one_sector
Message-ID: <20220630042300.GB4901@lst.de>
References: <20220623055338.3833616-1-hch@lst.de> <20220623055338.3833616-3-hch@lst.de> <Yrzj+8lk6aHaLjsD@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrzj+8lk6aHaLjsD@zen>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 29, 2022 at 04:44:59PM -0700, Boris Burkov wrote:
> On Thu, Jun 23, 2022 at 07:53:36AM +0200, Christoph Hellwig wrote:
> > Pass the btrfs_bio instead of the plain bio to btrfs_repair_one_sector,
> > an remove the start and failed_mirror arguments in favor of deriving
> > them from the btrfs_bio.  For this to work ensure that the file_offset
> > field is also initialized for buffered I/O.
> nit: the field in volumes.h has a comment "for direct I/O" which we
> should get rid of now.

Indeed.
