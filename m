Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1732C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF35220879
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfCYQLl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:11:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:40520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfCYQLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 12:11:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A326AFCC
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 16:11:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D4EDDA825; Mon, 25 Mar 2019 17:12:52 +0100 (CET)
Date:   Mon, 25 Mar 2019 17:12:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 06/12] btrfs: Introduce new bits for device allocation
 tree
Message-ID: <20190325161251.GH10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190325123132.27835-1-nborisov@suse.com>
 <20190325123132.27835-7-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325123132.27835-7-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 02:31:26PM +0200, Nikolay Borisov wrote:
> Rather than hijacking the existing defines let's just define new bits,
> with more descriptive names. Instead of using yet more (currently at 18)
> bits for the new flags, use the fact those flags will be specific to
> the device allocation tree so define them using existing EXTENT_* flags.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/disk-io.c   | 2 +-
>  fs/btrfs/extent_io.h | 4 ++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 80f0787eb278..81183694f8ea 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4055,8 +4055,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  		btrfsic_unmount(fs_info->fs_devices);
>  #endif
>  
> -	btrfs_close_devices(fs_info->fs_devices);
>  	btrfs_mapping_tree_free(&fs_info->mapping_tree);
> +	btrfs_close_devices(fs_info->fs_devices);

Have you squashed this change to the wrong commit? In v2 there was a
separate patch but mentioning the following one ("replace pending/pinned
chunks lists with io tree"). I'm going to drop this hunk and use the
separate patch as it makes it more clear.
