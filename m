Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD93C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 21:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B30C7223DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 21:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B30C7223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbeKOHJ6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 02:09:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:39714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbeKOHJ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 02:09:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1215AC38
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 21:05:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E9321DACE4; Wed, 14 Nov 2018 22:04:49 +0100 (CET)
Date:   Wed, 14 Nov 2018 22:04:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/6] btrfs: remove unused variable tree in
 end_compressed_bio_write()
Message-ID: <20181114210449.GL24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <20181114133520.16069-6-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114133520.16069-6-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 02:35:19PM +0100, Johannes Thumshirn wrote:
> Commit 2922040236f9 (btrfs: Remove extent_io_ops::writepage_end_io_hook)
> removed the indirection to extent_io_ops::writepage_end_io_hook but didn't
> remove the tree variable which then became unused.
> 
> Remove 'tree' as well to silence the warning when -Wunused-but-set-variable
> is used to compile btrfs.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/compression.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index bde8d0487bbb..088570c5dfb8 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -229,7 +229,6 @@ static noinline void end_compressed_writeback(struct inode *inode,
>   */
>  static void end_compressed_bio_write(struct bio *bio)
>  {
> -	struct extent_io_tree *tree;
>  	struct compressed_bio *cb = bio->bi_private;
>  	struct inode *inode;
>  	struct page *page;
> @@ -248,7 +247,6 @@ static void end_compressed_bio_write(struct bio *bio)
>  	 * call back into the FS and do all the end_io operations
>  	 */
>  	inode = cb->inode;
> -	tree = &BTRFS_I(inode)->io_tree;

The fix has been folded to the original patch already, same the other
one removing 'tree'. If you used linux-next to run the build, then it's
probably lagging behind the development branches that are synced to
kernel.org after some testing. The devel repos are either
git://github.com/kdave/btrfs-devel or
git://gitlab.com/kdave/btrfs-devel, branch misc-next.
