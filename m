Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B47C433FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Mar 2022 06:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241931AbiCWGFS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 02:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240947AbiCWGFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Mar 2022 02:05:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1F26E8D9;
        Tue, 22 Mar 2022 23:03:45 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A5DA268AFE; Wed, 23 Mar 2022 07:03:42 +0100 (CET)
Date:   Wed, 23 Mar 2022 07:03:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/40] btrfs: fix direct I/O read repair for split bios
Message-ID: <20220323060342.GA24302@lst.de>
References: <20220322155606.1267165-1-hch@lst.de> <20220322155606.1267165-3-hch@lst.de> <dd6a7675-71b5-b127-2012-9a5801d188fb@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6a7675-71b5-b127-2012-9a5801d188fb@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 23, 2022 at 07:59:15AM +0800, Qu Wenruo wrote:
> Personally speaking, I really hate to add DIO specific value into btrfs_bio.
>
> Hopes we can later turn that btrfs_bio::file_offset into some union for
> other usages.

Agreed.  There is two venues we could explore:

 - ceative use of unions.  Especially with some of my later patches
   adding more fields to struct btrfs_bio this could become possible.
 - adding a btrfs_dio_bio that contains a btrfs_bio.  By the end of
   this series another field (repair_refs) is added, and iter is only
   used for direct I/O, so this might be worthwhile.  But then again
   I think we could eventually kill off iter as well.

So we should eventually do something, but for a non-invasive fix
like this just adding the field for now seems like the most safe
approach.
