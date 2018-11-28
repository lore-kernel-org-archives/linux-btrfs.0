Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91DFC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D9D204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:37:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="vMWwFNBr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70D9D204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeK1Lh3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:37:29 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35315 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeK1Lh3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:37:29 -0500
Received: by mail-io1-f68.google.com with SMTP id u19so18581578ioc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rfWOjbrYR6zYEAtB6rW2Z0NxpAtxckVNrh3p1VZ/j2w=;
        b=vMWwFNBrFvz4uhSmqtIEzLEw/I4dWuApc8uHrlWgXc9KK7oASB0hF8zB/5oiUe5bn2
         CgYK4Xfl1RSqOhg2N3PUH9nvDX7JS9VKIK1cqLtUq3FfF1daEDlJAU92bwTyjIPBq2m/
         K74f4R5gfxME+W7G6U1uBZKXAUJS1NJlKmX8SbWea51YjGGcIh2jquVq58esRjdrsZ/G
         9bxpx+gdNBVcY48Tiaq+TnO+bdyzvjR3oHKIqUl0mvu9E0lkjYfsGxTMzpHUdA/KdoI/
         yiQ9iJzq60HtAwOzz58/pQ/eOIG/jDIBuTAcNnKpBR+/JIpicYFI0+bVNwN7jmLZmlqZ
         51EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rfWOjbrYR6zYEAtB6rW2Z0NxpAtxckVNrh3p1VZ/j2w=;
        b=Wf3akw6/y2T3mAPT18iCWwwREjayc8AcsArvLJjc4WcIQWvt6c2UcDoq/R4fEvPPqK
         bOgPYSW6NJ/qGfmEheG3xcpyju1axxHK6lEj+KvryiaehBeFc+QXGOfrsEFoWwpWV2Tx
         YDZPjTiVa9oYGATaXwIdsZIPl+fJc2Xwd0xQVDhGXA5ZnmYzKmKjAWXO55jmcvoWAyi4
         oHnCbmFW2jwyfLoxkbNE5z6WXDkdGTHkSduxbnrsSBdp/lg/PB/ODy9hOl12y0WX5Trl
         HbPIkn8DQz2e5YKasaiT0ADnNHVDz90W+24mNNpo7g/DMYM2d7wkNZT7r9RaVy/oCAZD
         vK0Q==
X-Gm-Message-State: AA+aEWadG0OhqjFnPbH8Q72xSFUjdx0Fy8jhumgV+acwvPJ1OofdfczA
        5x0K7iVK9SDN1O7QkqaP2ZzI+uy2yAI=
X-Google-Smtp-Source: AFSGD/WM5sCz4oNem9ycERzMT4yRbj8Npxv3At0TkZHUxh4TGUhReFk9MkTjAu7N5Y4fdc01Fv3DiA==
X-Received: by 2002:a5e:c107:: with SMTP id v7mr7607133iol.155.1543365468447;
        Tue, 27 Nov 2018 16:37:48 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id e16sm2002158iob.43.2018.11.27.16.37.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:37:47 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:37:46 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/9] btrfs: switch BTRFS_ORDERED_* to enums
Message-ID: <20181128003746.GP846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <15902ae1f53ef52d36fb4371fa2ec3428ca7158a.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15902ae1f53ef52d36fb4371fa2ec3428ca7158a.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:57PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> ordered extent flags.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ordered-data.h | 45 +++++++++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index b10e6765d88f..fb9a161f0215 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -37,26 +37,31 @@ struct btrfs_ordered_sum {
>   * rbtree, just before waking any waiters.  It is used to indicate the
>   * IO is done and any metadata is inserted into the tree.
>   */
> -#define BTRFS_ORDERED_IO_DONE 0 /* set when all the pages are written */
> -
> -#define BTRFS_ORDERED_COMPLETE 1 /* set when removed from the tree */
> -
> -#define BTRFS_ORDERED_NOCOW 2 /* set when we want to write in place */
> -
> -#define BTRFS_ORDERED_COMPRESSED 3 /* writing a zlib compressed extent */
> -
> -#define BTRFS_ORDERED_PREALLOC 4 /* set when writing to preallocated extent */
> -
> -#define BTRFS_ORDERED_DIRECT 5 /* set when we're doing DIO with this extent */
> -
> -#define BTRFS_ORDERED_IOERR 6 /* We had an io error when writing this out */
> -
> -#define BTRFS_ORDERED_UPDATED_ISIZE 7 /* indicates whether this ordered extent
> -				       * has done its due diligence in updating
> -				       * the isize. */
> -#define BTRFS_ORDERED_TRUNCATED 8 /* Set when we have to truncate an extent */
> -
> -#define BTRFS_ORDERED_REGULAR 10 /* Regular IO for COW */
> +enum {
> +	/* set when all the pages are written */
> +	BTRFS_ORDERED_IO_DONE,
> +	/* set when removed from the tree */
> +	BTRFS_ORDERED_COMPLETE,
> +	/* set when we want to write in place */
> +	BTRFS_ORDERED_NOCOW,
> +	/* writing a zlib compressed extent */
> +	BTRFS_ORDERED_COMPRESSED,
> +	/* set when writing to preallocated extent */
> +	BTRFS_ORDERED_PREALLOC,
> +	/* set when we're doing DIO with this extent */
> +	BTRFS_ORDERED_DIRECT,
> +	/* We had an io error when writing this out */
> +	BTRFS_ORDERED_IOERR,
> +	/*
> +	 * indicates whether this ordered extent has done its due diligence in
> +	 * updating the isize
> +	 */
> +	BTRFS_ORDERED_UPDATED_ISIZE,
> +	/* Set when we have to truncate an extent */
> +	BTRFS_ORDERED_TRUNCATED,
> +	/* Regular IO for COW */
> +	BTRFS_ORDERED_REGULAR,
> +};
>  
>  struct btrfs_ordered_extent {
>  	/* logical offset in the file */
> -- 
> 2.19.1
> 
