Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258ADC433F5
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Apr 2022 16:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiDHQnD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Apr 2022 12:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiDHQnC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2022 12:43:02 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A097120B8
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Apr 2022 09:40:58 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 25FA168AFE; Fri,  8 Apr 2022 18:40:55 +0200 (CEST)
Date:   Fri, 8 Apr 2022 18:40:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fixes for handling of split direct I/O bios
Message-ID: <20220408164054.GA31302@lst.de>
References: <20220324160628.1572613-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324160628.1572613-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David,

do you plan to pick these up?

On Thu, Mar 24, 2022 at 05:06:26PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series fixes two problems in the direct I/O code where the
> file_offset field in the dio_private structure is used in a context where
> we really need the file_offset for the given low-level bios and not for
> the bio submitted by the iomap direct I/O as recorded in the dio_private
> structure.  To do so we need a new file_offset in the btrfs_dio
> structure.
> 
> Found by code inspection as part of my bio cleanups.
> 
> Diffstat:
>  extent_io.c |    1 +
>  inode.c     |   18 ++++++++----------
>  volumes.h   |    3 +++
>  3 files changed, 12 insertions(+), 10 deletions(-)
---end quoted text---
