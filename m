Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAFEC433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 May 2022 16:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351652AbiETQ0M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 May 2022 12:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351574AbiETQZx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 May 2022 12:25:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1CD101F7
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2022 09:25:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3582B68AFE; Fri, 20 May 2022 18:25:48 +0200 (CEST)
Date:   Fri, 20 May 2022 18:25:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/15] btrfs: quit early if the fs has no RAID56
 support for raid56 related checks
Message-ID: <20220520162547.GB25490@lst.de>
References: <20220517145039.3202184-1-hch@lst.de> <20220517145039.3202184-3-hch@lst.de> <3c8da817-963c-224b-f99e-faeacb1e2ce2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c8da817-963c-224b-f99e-faeacb1e2ce2@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 20, 2022 at 11:47:31AM +0300, Nikolay Borisov wrote:
> This seems rather unrelated to the rest of the series so it can go 
> independently and ideally should have been a separate patch of its own.

As far as I can tell it just speeds up functions used here, so yes.

Qu, do you want to send this out separately?
