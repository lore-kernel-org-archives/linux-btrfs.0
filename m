Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8477AC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 18:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 389F321470
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 18:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ISmKRONt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 389F321470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbeJEBYk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 21:24:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44386 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbeJEBYj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 21:24:39 -0400
Received: by mail-pf1-f196.google.com with SMTP id r9-v6so3638706pff.11
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2018 11:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yeFRComBmgfFvfnHT65+RHTV9gHkgd7Rwk6AGSYc7Ro=;
        b=ISmKRONtBurIGO2LtMMPwR4HBxOrc1LtBCM/SBWedLqaFB/nXPuDvhebTTUuf0+TYQ
         44Wfdqw1gS0tiAJzxtPgw3FqM7TKDNrGHgRXFLQeKtAs6VHj1GxSm7KkqO6jxhTMHMK8
         2saOntxTumiartt2KwGzEIr0ZmatLkRm6Osyl7Z9R+IeDVVdw5bJPn4qNBvvxDURCIfo
         3OJP8jDYHyRhqW6cXft4DXZjt0bbPD8ODFA8Zh8W3tDt6eexbDcZqYzo4j0NjPWvJ8NM
         IfzBr/bvKAm8H/o+gIApzVzGHwCYrerNp/IGlUqsS2Rsu50Uwt2vnaCu3hp95djUbjmm
         kiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yeFRComBmgfFvfnHT65+RHTV9gHkgd7Rwk6AGSYc7Ro=;
        b=IXh8XN0sJM0abF3Fi78Uotv0qQFKJRH7f/KfdZAiZXM2Rw2EZ30SZ/iD9qTjCDVPDE
         fbtw9mwLUZfIKOLlJFzUv9o0W/MgzW6KjUN6ROPb+6oag0nKQ9NcNboEhhNkGtv4EfyA
         U8EJbm3nrJKTZ77zRDF25G3d7udgSvdiOr/JeB5hoOLQbcUY/fCB9JhQk1wGqsZqCNgn
         gnuEQ0EQanp3tb2UpwWZ7KfWz7sA/jSuSFDh8WNaBqAhqEwn+ZySrXgPMl9JVQf+OZYL
         iWJe0Qb5KEWvuuC2Wde7l+gEHtQPbMHk8EVFEBP4xAdY5tp/KdoFnfPHxg+BHFPfaJuk
         9fqA==
X-Gm-Message-State: ABuFfojDhMY8VHavEdSzPymp8MVLqrXd7xX8sACpsptRasW93z8XwWbv
        HRg+ZEL6pAbKEM8kN5VU5X2M1Q==
X-Google-Smtp-Source: ACcGV629yQspAA1yd3imRPfj5PIwOeYm+zPVOXTIpZBkeZjGE+lSvQHMtVnEfVq2rZ1lDvP+nnIE8w==
X-Received: by 2002:a63:904a:: with SMTP id a71-v6mr7044872pge.264.1538677810444;
        Thu, 04 Oct 2018 11:30:10 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::7:7e9a])
        by smtp.gmail.com with ESMTPSA id u9-v6sm12649948pfi.104.2018.10.04.11.30.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 11:30:09 -0700 (PDT)
Date:   Thu, 4 Oct 2018 11:30:08 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/10] btrfs-progs: Add freespace tree as compat_ro
 supported feature
Message-ID: <20181004183008.GF25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-8-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-8-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:18PM +0300, Nikolay Borisov wrote:
> The RO_FREE_SPACE_TREE(_VALID) flags are required in order to be able
> to open an FST filesystem in repair mode. Add them to
> BTRFS_FEATURE_COMPAT_RO_SUPP.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  ctree.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/ctree.h b/ctree.h
> index a6d6c3decd87..3c396e7d293d 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -497,7 +497,9 @@ struct btrfs_super_block {
>   * added here until read-write support for the free space tree is implemented in
>   * btrfs-progs.
>   */

This comment should go away.

> -#define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
> +#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
> +	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
> +	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)
>  
>  #define BTRFS_FEATURE_INCOMPAT_SUPP			\
>  	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\

To repeat my question from before, did you test whether we can properly
change the filesystem with, e.g., btrfstune or btrfs fi label? Given
that some critical code was missing in the free space tree code, I'd be
surprised if it worked correctly.
