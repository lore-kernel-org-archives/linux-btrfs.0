Return-Path: <SRS0=YdAF=T7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF466C04AB6
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 16:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5E742648F
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 16:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfEaQCU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 May 2019 12:02:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:50510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfEaQCU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 May 2019 12:02:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 66172B00B
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2019 16:02:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BCF95DA85E; Fri, 31 May 2019 18:03:12 +0200 (CEST)
Date:   Fri, 31 May 2019 18:03:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Introduce btrfs_io_geometry
Message-ID: <20190531160312.GL15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190531150115.21003-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531150115.21003-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 31, 2019 at 06:01:14PM +0300, Nikolay Borisov wrote:
> ---
>  fs/btrfs/volumes.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h |  2 +
>  2 files changed, 100 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 776f5c7ca7c5..b130f465ca6d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5907,6 +5907,104 @@ static bool need_full_stripe(enum btrfs_map_op op)
>  	return (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS);
>  }
>  
> +/*
> + * btrfs_io_geometry - calculates the geomery of a particular (address, len)
> + *		       tuple. This information is used to calculate how big a
> + *		       particular bio can get before it straddles a stripe.
> + *
> + * @fs_info - The omnipresent btrfs structure
> + * @logical - Address that we want to figure out the geometry of
> + * @len	    - The length of IO we are going to perform, starting at @logical
> + * @op      - Type of operation - Write or Read
> + * @io_geom - Pointer used to return values
> + *
> + * Returns < 0 in case a chunk for the given logical address cannot be found,
> + * usually shouldn't happen unless @logical is corrupted, 0 otherwise.
> + */
> +int btrfs_io_geometry(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
> +		      u64 logical, u64 len, struct btrfs_io_geometry *io_geom)

Where is struct btrfs_io_geometry defined?

And changelog and signed-off-by are missing.
