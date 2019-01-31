Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FF4C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 14:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 079AD218AC
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 14:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfAaOUq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 09:20:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:34828 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727237AbfAaOUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 09:20:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97845AF95;
        Thu, 31 Jan 2019 14:20:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 73082DA918; Thu, 31 Jan 2019 15:20:05 +0100 (CET)
Date:   Thu, 31 Jan 2019 15:20:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 03/12] btrfs: disk-io: Show the timing of corrupted
 tree block explicitly
Message-ID: <20190131142005.GE2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-4-wqu@suse.com>
 <20190130145719.GS2900@twin.jikos.cz>
 <2c22a5e9-41d0-d62a-ad88-5be3da59e441@suse.com>
 <0d1caf58-8015-2fdb-d75d-60870b13312c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d1caf58-8015-2fdb-d75d-60870b13312c@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 08:03:36AM +0800, Qu Wenruo wrote:
> On 2019/1/30 下午10:59, Nikolay Borisov wrote:
> > On 30.01.19 г. 16:57 ч., David Sterba wrote:
> >> On Fri, Jan 25, 2019 at 01:09:16PM +0800, Qu Wenruo wrote:
> >>> Just add one extra line to show when the corruption is detected.
> >>> Currently only read time detection is possible.
> >>>
> >>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> >>> ---
> >>>  fs/btrfs/disk-io.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>> index 794d5bb7fe33..426e9f450f70 100644
> >>> --- a/fs/btrfs/disk-io.c
> >>> +++ b/fs/btrfs/disk-io.c
> >>> @@ -658,6 +658,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
> >>>  
> >>>  	if (!ret)
> >>>  		set_extent_buffer_uptodate(eb);
> >>> +	else
> >>> +		btrfs_err(fs_info, "read time tree block corrupted detected");
> >>
> >> I'm not sure the 'read time' is clear enoug, my suggestion is to use
> >> 'post-read' (and pre-write analogicaly). What do you think?
> > 
> > 
> > How about "error during tree block reading" or "error reading treeblock"?
> 
> Nikolay's suggestion looks more straightforward to me.
> 
> +1 for his idea.
> 
> The 'post-read' still could confuse end-user IMHO.

The idea is to distinguish if the error was because the block can't be
read or because the data it contains are wrong.
