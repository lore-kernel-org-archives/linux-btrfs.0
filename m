Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE0CC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 22:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 295402147A
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548802261;
	bh=t74ythkHaPEfDQr6kBkrw9aIN/r/JpkyyZkAWrsmwKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=niiTNXhttzm6ssyjLqE1Goz4y7dxTh5M5RUpEN/w1NEq3vobgVtkc3zsaiay/gnMW
	 NPS1WpWQjA7QZw++sNY9h4LGwBG1q7jbOYQKUKGH1BmTO9Ao1PZp1mYE7x7sWSvJPV
	 Ak+X6u1qVzvoDDCx6X8BUxSRdgReXZOxsg5iZfX4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbfA2Wuz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 17:50:55 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34929 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbfA2Wuz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 17:50:55 -0500
Received: by mail-yb1-f194.google.com with SMTP id 64so4458725ybs.2;
        Tue, 29 Jan 2019 14:50:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Bt5uAXlGEh+xbxNa64Wd7TBVok43VzmctHEcR2md1oo=;
        b=AYgQnxy4MN1Fx4mVIC87F+8CwJSP14bQqx6y3ypiJJFPDX+g3FMMFn7jUlUqMwUoUB
         zL8CWe5TqCcEGP7BEi9N6lfb7HAUyvwtzmfxe7luin3JvjJJ4xMcc6REXmUZpmIqXMTE
         vvmdSXNB8deW+ZWlMmbGLR+qNpUVAmAzSfkjtuC8xtyBrmso8pVF4S41fgDH6aRUPkne
         FzMnr8kkZtWVjgOInnMbdSlp25YtK6ihU5U2IZvqEynCktmtf13ks0CQ1uZg7Wj3x6pQ
         k7NO+Xk8yyaqYqyHRe5teQPebvgl8eoP00gEHOxpvkd8gCkgkzlYllkh/BC+itj2JIjP
         cMpw==
X-Gm-Message-State: AHQUAubU3jpJ9LNf0MBR+JR1h82knm9MqTVMs8dzA2Dvqd01IOL17g8f
        ygRegU9jIY1Sjbo3kt6G/RQ=
X-Google-Smtp-Source: AHgI3IaEOqVjWMMRL8m90yY3y3dxAWqRxFZP4/AqU/+S+n1j43cGFebFlAoR8ZzdeDSf58AoFT6s5A==
X-Received: by 2002:a25:d2cb:: with SMTP id j194mr11170654ybg.516.1548802253831;
        Tue, 29 Jan 2019 14:50:53 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::5:f5f4])
        by smtp.gmail.com with ESMTPSA id s35sm42704056ywa.19.2019.01.29.14.50.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 14:50:52 -0800 (PST)
Date:   Tue, 29 Jan 2019 17:50:50 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH 11/11] btrfs: add zstd compression level support
Message-ID: <20190129225050.GB87266@dennisz-mbp.dhcp.thefacebook.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-12-dennis@kernel.org>
 <c92b0233-5406-42a8-4444-a5ab503f726f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c92b0233-5406-42a8-4444-a5ab503f726f@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 29, 2019 at 09:25:54AM +0200, Nikolay Borisov wrote:
> 
> 
> On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> > Zstd compression requires different amounts of memory for each level of
> > compression. The prior patches implemented indirection to allow for each
> > compression type to manage their workspaces independently. This patch
> > uses this indirection to implement compression level support for zstd.
> > 
> > As mentioned above, a requirement that differs zstd from zlib is that
> > higher levels of compression require more memory. To manage this, each
> > compression level has its own queue of workspaces. A global LRU is used
> > to help with reclaim. To guarantee forward progress, a max level
> > workspace is preallocated and hidden from the LRU.
> > 
> > When getting a workspace, it uses a bitmap to identify the levels that
> > are populated and scans up. If it finds a workspace that is greater than
> > it, it uses it, but does not update the last_used time and the
> > corresponding place in the LRU. This provides a mechanism to decrease
> > memory utilization as we only keep around workspaces that are sized
> > appropriately for the in use compression levels.
> > 
> > By knowing which compression levels have available workspaces, we can
> > recycle rather than always create new workspaces as well as take
> > advantage of the preallocated max level for forward progress. If we hit
> > memory pressure, we sleep on the max level workspace. We continue to
> > rescan in case we can use a smaller workspace, but eventually should be
> > able to obtain the max level workspace or allocate one again should
> > memory pressure subside. The memory requirement for decompression is the
> > same as level 1, and therefore can use any of available workspace.
> > 
> > The number of workspaces is bound by an upper limit of the workqueue's
> > limit which currently is 2 (percpu limit). Second, a reclaim timer is
> > used to free inactive/improperly sized workspaces. The reclaim timer is
> > set to 67s to avoid colliding with transaction commit (every 30s) and
> > attempts to reclaim any unused workspace older than 45s.
> > 
> > Repeating the experiment from v2 [1], the Silesia corpus was copied to a
> > btrfs filesystem 10 times and then read back after dropping the caches.
> > The btrfs filesystem was on an SSD.
> > 
> > Level   Ratio   Compression (MB/s)  Decompression (MB/s)
> > 1       2.658        438.47                910.51
> > 2       2.744        364.86                886.55
> > 3       2.801        336.33                828.41
> > 4       2.858        286.71                886.55
> > 5       2.916        212.77                556.84
> > 6       2.363        119.82                990.85
> > 7       3.000        154.06                849.30
> > 8       3.011        159.54                875.03
> > 9       3.025        100.51                940.15
> > 10      3.033        118.97                616.26
> > 11      3.036         94.19                802.11
> > 12      3.037         73.45                931.49
> > 13      3.041         55.17                835.26
> > 14      3.087         44.70                716.78
> > 15      3.126         37.30                878.84
> > 
> > [1] https://lore.kernel.org/linux-btrfs/20181031181108.289340-1-terrelln@fb.com/
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> > Cc: Nick Terrell <terrelln@fb.com>
> > Cc: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/btrfs/super.c |   6 +-
> >  fs/btrfs/zstd.c  | 229 +++++++++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 226 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index b28dff207383..0ecc513cb56c 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -544,9 +544,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
> >  				btrfs_clear_opt(info->mount_opt, NODATASUM);
> >  				btrfs_set_fs_incompat(info, COMPRESS_LZO);
> >  				no_compress = 0;
> > -			} else if (strcmp(args[0].from, "zstd") == 0) {
> > +			} else if (strncmp(args[0].from, "zstd", 4) == 0) {
> >  				compress_type = "zstd";
> >  				info->compress_type = BTRFS_COMPRESS_ZSTD;
> > +				info->compress_level =
> > +					btrfs_compress_str2level(
> > +							 BTRFS_COMPRESS_ZSTD,
> > +							 args[0].from + 4);
> >  				btrfs_set_opt(info->mount_opt, COMPRESS);
> >  				btrfs_clear_opt(info->mount_opt, NODATACOW);
> >  				btrfs_clear_opt(info->mount_opt, NODATASUM);
> > diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> > index a951d4fe77f7..ce9b466c197f 100644
> > --- a/fs/btrfs/zstd.c
> > +++ b/fs/btrfs/zstd.c
> > @@ -6,20 +6,27 @@
> >   */
> >  
> >  #include <linux/bio.h>
> > +#include <linux/bitmap.h>
> >  #include <linux/err.h>
> >  #include <linux/init.h>
> >  #include <linux/kernel.h>
> >  #include <linux/mm.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/refcount.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> >  #include <linux/zstd.h>
> >  #include "compression.h"
> > +#include "ctree.h"
> >  
> >  #define ZSTD_BTRFS_MAX_WINDOWLOG 17
> >  #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
> >  #define ZSTD_BTRFS_DEFAULT_LEVEL 3
> > +#define ZSTD_BTRFS_MAX_LEVEL 15
> > +#define ZSTD_BTRFS_RECLAIM_NS (45 * NSEC_PER_SEC)
> > +/* 67s to avoid clashing with transaction commit (every 30s) */
> > +#define ZSTD_BTRFS_RECLAIM_JIFFIES (67 * HZ)
> 
> This is valid provided that transaction commit time is not overriden by
> Opt_commit_interval. If it is such a problem to not clash with trans
> commit maybe this should be calculated upon mount?
> 

Because the workspace managers are initialized once and shared,
different mounts can have different Opt_commit_interval settings. I
don't think it's particularly problematic to clash with trans commit,
it's kind of nice to have the offset to in the majority of cases not run
into this.

Thanks,
Dennis
