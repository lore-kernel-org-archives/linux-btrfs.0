Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A09AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 20:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EB020831
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 20:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="RCWG1trL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05EB020831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbeKTGbK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 01:31:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:47072 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730417AbeKTGbJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 01:31:09 -0500
Received: by mail-pg1-f195.google.com with SMTP id w7so14285226pgp.13
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 12:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GAFe4yuWhUt73/OJdQhVAY/dGLhGCyJTJeIB9T4LyA4=;
        b=RCWG1trL4D8F4oCxl8DjOHLTfP4IsMpNbvCuUx/QwhH4Deo/ZO1yrr7MoJjI0Yo15r
         azSsrqs4tj1U9RU0MrzbMQRlJsjWY7rZ3A7rbRYShIao64mmLZu5wtfoeX09QvzAOk6o
         5d3D/0l+555ERLp0eXFY1T67QEb1yDLIVfPABf3w1V6avofie/mGzjLd7nyi2IswZQPK
         P6VqVnMjkdR22yiiEMITne2TMsVji8NTGCwekLXb+31p4ktvNF0uET+l88QEluTCgxPb
         ppGAr6u/eVjVcvex7nhChqVaMOGPJ7NkUeASaybkhoT+KncwzAMH3MEEwezWjTTeuhET
         c2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GAFe4yuWhUt73/OJdQhVAY/dGLhGCyJTJeIB9T4LyA4=;
        b=XzId1/IChYCGr2pVuTJu28earL17a4ywYZM9sGFLeUR04iLOASr9Ki7gZW8sHMP5XA
         /MEBfHvTSy/R1n00sda8B7BkuBTr8U7xLdFGil8YbYw9g5UlEovcsFXxjjQJaS/SRSyi
         P1T3gCObaA32/l/U+j140PQy1Gsta8hYPZnNp/HYODJEJ0zqWuLwJl1/UTjhGy/7c3Db
         fE6Pqxs8LKv5WoJ08OW9aY9ZdAGSF0SkL2GyiLezKEBpe7B0Mmbetje0U3QFZLYxchj5
         J/B+WrQleXN5FeQrVyM7xjkoCsFkba6xuw1r7GED+tisdYpV+BjGN8TdwSwFHCN69Yoh
         6O6A==
X-Gm-Message-State: AGRZ1gLmTqJVhieOEuuFVAUmMSfjpzCFr4HFbzeplyk5jldT7hRCi8QB
        v7ClwP+SdbnZPAhl397XUigqpA==
X-Google-Smtp-Source: AJdET5fzmCPdiajLOU1HCEfYg8yC8Tvaf05DJrI9xcuukx0oWAfRaHURnYYF/7C9hF2bGC0p6ed6UQ==
X-Received: by 2002:a63:e950:: with SMTP id q16mr21341226pgj.138.1542657956440;
        Mon, 19 Nov 2018 12:05:56 -0800 (PST)
Received: from vader ([198.134.98.50])
        by smtp.gmail.com with ESMTPSA id j197sm58827939pgc.76.2018.11.19.12.05.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Nov 2018 12:05:55 -0800 (PST)
Date:   Mon, 19 Nov 2018 12:05:54 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, Nick Terrell <terrelln@fb.com>,
        kernel-team@fb.com, Omar Sandoval <osandov@fb.com>,
        linux-btrfs@vger.kernel.org, Jennifer Liu <jenniferliu620@fb.com>
Subject: Re: [PATCH v2] btrfs: add zstd compression level support
Message-ID: <20181119200554.GB25682@vader>
References: <20181031181108.289340-1-terrelln@fb.com>
 <20181113003332.GV24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113003332.GV24115@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 13, 2018 at 01:33:32AM +0100, David Sterba wrote:
> On Wed, Oct 31, 2018 at 11:11:08AM -0700, Nick Terrell wrote:
> > From: Jennifer Liu <jenniferliu620@fb.com>
> > 
> > Adds zstd compression level support to btrfs. Zstd requires
> > different amounts of memory for each level, so the design had
> > to be modified to allow set_level() to allocate memory. We
> > preallocate one workspace of the maximum size to guarantee
> > forward progress. This feature is expected to be useful for
> > read-mostly filesystems, or when creating images.
> > 
> > Benchmarks run in qemu on Intel x86 with a single core.
> > The benchmark measures the time to copy the Silesia corpus [0] to
> > a btrfs filesystem 10 times, then read it back.
> > 
> > The two important things to note are:
> > - The decompression speed and memory remains constant.
> >   The memory required to decompress is the same as level 1.
> > - The compression speed and ratio will vary based on the source.
> > 
> > Level	Ratio	Compression	Decompression	Compression Memory
> > 1    	2.59 	153 MB/s   	112 MB/s     	0.8 MB
> > 2    	2.67 	136 MB/s   	113 MB/s     	1.0 MB
> > 3    	2.72 	106 MB/s   	115 MB/s     	1.3 MB
> > 4    	2.78 	86  MB/s   	109 MB/s     	0.9 MB
> > 5    	2.83 	69  MB/s   	109 MB/s     	1.4 MB
> > 6    	2.89 	53  MB/s   	110 MB/s     	1.5 MB
> > 7    	2.91 	40  MB/s   	112 MB/s     	1.4 MB
> > 8    	2.92 	34  MB/s   	110 MB/s     	1.8 MB
> > 9    	2.93 	27  MB/s   	109 MB/s     	1.8 MB
> > 10   	2.94 	22  MB/s   	109 MB/s     	1.8 MB
> > 11   	2.95 	17  MB/s   	114 MB/s     	1.8 MB
> > 12   	2.95 	13  MB/s   	113 MB/s     	1.8 MB
> > 13   	2.95 	10  MB/s   	111 MB/s     	2.3 MB
> > 14   	2.99 	7   MB/s   	110 MB/s     	2.6 MB
> > 15   	3.03 	6   MB/s   	110 MB/s     	2.6 MB
> > 
> > [0] http://sun.aei.polsl.pl/~sdeor/index.php?page=silesia
> > 
> > Signed-off-by: Jennifer Liu <jenniferliu620@fb.com>
> > Signed-off-by: Nick Terrell <terrelln@fb.com>
> > Reviewed-by: Omar Sandoval <osandov@fb.com>
> > ---
> > v1 -> v2:
> > - Don't reflow the unchanged line.
> > 

[snip]

> > -static struct list_head *zstd_alloc_workspace(void)
> > +static bool zstd_set_level(struct list_head *ws, unsigned int level)
> > +{
> > +	struct workspace *workspace = list_entry(ws, struct workspace, list);
> > +	ZSTD_parameters params;
> > +	int size;
> > +
> > +	if (level > BTRFS_ZSTD_MAX_LEVEL)
> > +		level = BTRFS_ZSTD_MAX_LEVEL;
> > +
> > +	if (level == 0)
> > +		level = BTRFS_ZSTD_DEFAULT_LEVEL;
> > +
> > +	params = ZSTD_getParams(level, ZSTD_BTRFS_MAX_INPUT, 0);
> > +	size = max_t(size_t,
> > +			ZSTD_CStreamWorkspaceBound(params.cParams),
> > +			ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
> > +	if (size > workspace->size) {
> > +		if (!zstd_reallocate_mem(workspace, size))
> 
> This can allocate memory and this can appen on the writeout path, ie.
> one of the reasons for that might be that system needs more memory.
> 
> By the table above, the size can be up to 2.6MiB, which is a lot in
> terms of kernel memory as there must be either contiguous unmapped
> memory, the virtual mappings must be created. Both are scarce resource
> or should be treated as such.
> 
> Given that there's no logic that would try to minimize the usage for
> workspaces, this can allocate many workspaces of that size.
> 
> Currently the workspace allocations have been moved to the early module
> loading phase so that they don't happen later and we don't have to
> allocate memory nor handle the failures. Your patch brings that back.

Even before this patch, we may try to allocate a workspace. See
__find_workspace():

https://github.com/kdave/btrfs-devel/blob/fd0f5617a8a2ee92dd461d01cf9c5c37363ccc8d/fs/btrfs/compression.c#L897

We already limit it to one per CPU, and only allocate when needed.
Anything greater than that has to wait. Maybe we should improve that to
also include a limit on the total amount of memory allocated? That would
be more flexible than your approach below of making the > default case
special, and I like it more than Timofey's idea of falling back to a
lower level.

> The solution I'm currently thinking about can make the levels work but
> would be limited in throughput as a trade-off for the memory
> consumption.
> 
> - preallocate one workspace for level 15 per mounted filesystem, using
>   get_free_pages_exact or kvmalloc
> 
> - preallocate workspaces for the default level, the number same as for
>   lzo/zlib
> 
> - add logic to select the zstd:15 workspace last for other compressors,
>   ie. make it almost exclusive for zstd levels > default
> 
> Further refinement could allocate the workspaces on-demand and free if
> not used. Allocation failures would still be handled gracefully at the
> cost of waiting for the remainig worspaces, at least one would be always
> available.
