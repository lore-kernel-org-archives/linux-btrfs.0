Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3B4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 084D320657
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388563AbfAOR6m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:58:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:58860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfAOR6m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:58:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2B97AF52;
        Tue, 15 Jan 2019 17:58:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 20DDBDA83D; Tue, 15 Jan 2019 18:58:12 +0100 (CET)
Date:   Tue, 15 Jan 2019 18:58:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Proposal for more detail in scrub doc
Message-ID: <20190115175811.GN2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        linux-btrfs@vger.kernel.org
References: <20181127141437.24744-1-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127141437.24744-1-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 03:14:37PM +0100, Andrea Gelmini wrote:
> Wise words from Qu:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg82557.html
> ---
>  Documentation/btrfs-scrub.asciidoc | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
> index 4c49269..1fc085c 100644
> --- a/Documentation/btrfs-scrub.asciidoc
> +++ b/Documentation/btrfs-scrub.asciidoc
> @@ -16,7 +16,8 @@ and metadata blocks from all devices and verify checksums. Automatically repair
>  corrupted blocks if there's a correct copy available.
>  
>  NOTE: Scrub is not a filesystem checker (fsck) and does not verify nor repair
> -structural damage in the filesystem.
> +structural damage in the filesystem. It only checks csum of data and tree blocks,
> +it doesn't ensure the content of tree blocks are OK.

Thanks for the suggestion, I've enhanced the note in the docs so it
fills in the details you've been missing.
