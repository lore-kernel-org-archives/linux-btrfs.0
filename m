Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC7CC64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 19:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E93BA206B2
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 19:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="yZJ+l/A8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E93BA206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbeJCCFx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 22:05:53 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42665 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbeJCCFx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2018 22:05:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id f26-v6so291567pfn.9
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2018 12:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lcg9sYhl6YvdIlBSxP0SL+p4lT/VPZLPI1wHVHWeyp4=;
        b=yZJ+l/A8irRIzqigkQU/1LsUijPewjAreFoyt2d5VTI/VDAZcAzP/CyVc+r5BL+sEi
         IweKzACQjMB6xXZIRuc8nznCqVS6UnmTgEGqUo63v/nFyUn+vsFU7/AObQOvL9/CTibG
         5flQVDr19yGnTT5nEEn+Sez2us07m4eOInC/xStfK0qqqJfGbvnV9TTKp2ili/on7YP4
         qXyjPbGLXgaC96VWH5Pe7Fe1WVs/rgInmB8Fln4uaF+goZekWuO12h8HKpTyodGFSpFi
         WA6iDkB3lC0RbK6LUvOoZ1Ig/Uv0tIQHf7dSWTCkEKqBoTMMjnEwo+f8SLSJXmVqKkne
         6XSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lcg9sYhl6YvdIlBSxP0SL+p4lT/VPZLPI1wHVHWeyp4=;
        b=E8ST6f+lPu/HbMHcbgoY08PvkJQNucQsHEXPDa71WlqbeWaExyo0KOFdX+99WTW/LL
         yPL6QEbqY7eOsysLTI9nmKAXU/2ws0C1EhJmQU0r6GELO0zui5NrcLthqBZ6jKDJUou6
         mW+wemXcEI5gOvu5NUu29wSyYGxPNoBG9u+MBYjnejKoj3YwyU4oUNoibUXHzcqHYd6X
         gdw/Me+vVPEevq7rP0Xw7nPmo8h+EdaA43o4vRqeJLOlRexjrDPLu+sZODqrxrnnDjWb
         pnX7TaNtJKuORphd/Tk64IA9QTuu0vEUAE4tXfmQvqMZXjoZW1mxXz4oZiQefvlrOGlK
         m2Pw==
X-Gm-Message-State: ABuFfohhF9bLtmPgtT6IZdIsUYdoEP0+Qp6avGT0XRrQMg3rLqgjmfgw
        deRBLY4jLeOX15aVuUjkFuGoZTXrYKU=
X-Google-Smtp-Source: ACcGV62qMwkRU4lbtr6U/QFxSuz+TvxSnJ7PhOO7XJeotPyQNF4M+mWVhCzN03kwyTsDHokcdRY+4g==
X-Received: by 2002:a63:be4a:: with SMTP id g10-v6mr15681281pgo.378.1538508058542;
        Tue, 02 Oct 2018 12:20:58 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::5:4e24])
        by smtp.gmail.com with ESMTPSA id d7-v6sm29073810pfm.23.2018.10.02.12.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Oct 2018 12:20:58 -0700 (PDT)
Date:   Tue, 2 Oct 2018 12:20:57 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] btrfs-progs: Add support for freespace tree in
 btrfs_read_fs_root
Message-ID: <20181002192057.GA25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-2-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:12PM +0300, Nikolay Borisov wrote:
> For completeness sake add code to btrfs_read_fs_root so that it can
> handle the freespace tree.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  disk-io.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 2e6d56a36af9..14f0fd5c2f0c 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -668,6 +668,9 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
>  	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
>  		return fs_info->quota_enabled ? fs_info->quota_root :
>  				ERR_PTR(-ENOENT);
> +	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
> +        return fs_info->free_space_root ? fs_info->free_space_root :
> +                                                  ERR_PTR(-ENOENT);
>  
>  	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
>  	       location->offset != (u64)-1);
> -- 
> 2.7.4
> 
