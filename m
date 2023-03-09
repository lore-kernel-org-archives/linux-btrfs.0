Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96B7C64EC4
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Mar 2023 15:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjCIPWU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 10:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjCIPWL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Mar 2023 10:22:11 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721DAEFF4D
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Mar 2023 07:22:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CF39E68AA6; Thu,  9 Mar 2023 16:22:07 +0100 (CET)
Date:   Thu, 9 Mar 2023 16:22:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 12/20] btrfs: simplify extent buffer writing
Message-ID: <20230309152207.GE17952@lst.de>
References: <20230309090526.332550-1-hch@lst.de> <20230309090526.332550-13-hch@lst.de> <e3f3a52f-8656-24f9-f8ed-a13c2dcffeb0@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3f3a52f-8656-24f9-f8ed-a13c2dcffeb0@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 09, 2023 at 02:00:32PM +0000, Johannes Thumshirn wrote:
> Looks good,
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> Looking at the resulting code, I hope one of the subsequent
> patches is merging write_one_subpage_eb() and write_one_eb()
> as they're getting quite similar.

The final patch will do that.
