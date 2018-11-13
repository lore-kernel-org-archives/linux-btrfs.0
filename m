Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE777C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 00:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9587822506
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 00:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9587822506
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbeKMJ5K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 04:57:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:36938 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbeKMJ5K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 04:57:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE97FAE46;
        Tue, 13 Nov 2018 00:01:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4DE95DAFAE; Tue, 13 Nov 2018 01:01:26 +0100 (CET)
Date:   Tue, 13 Nov 2018 01:01:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, Omar Sandoval <osandov@fb.com>,
        linux-btrfs@vger.kernel.org, Jennifer Liu <jenniferliu620@fb.com>
Subject: Re: [PATCH v2] btrfs: add zstd compression level support
Message-ID: <20181113000126.GU24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nick Terrell <terrelln@fb.com>,
        kernel-team@fb.com, Omar Sandoval <osandov@fb.com>,
        linux-btrfs@vger.kernel.org, Jennifer Liu <jenniferliu620@fb.com>
References: <20181031181108.289340-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031181108.289340-1-terrelln@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 11:11:08AM -0700, Nick Terrell wrote:
> From: Jennifer Liu <jenniferliu620@fb.com>
> 
> Adds zstd compression level support to btrfs. Zstd requires
> different amounts of memory for each level, so the design had
> to be modified to allow set_level() to allocate memory. We
> preallocate one workspace of the maximum size to guarantee
> forward progress. This feature is expected to be useful for
> read-mostly filesystems, or when creating images.
> 
> Benchmarks run in qemu on Intel x86 with a single core.
> The benchmark measures the time to copy the Silesia corpus [0] to
> a btrfs filesystem 10 times, then read it back.
> 
> The two important things to note are:
> - The decompression speed and memory remains constant.
>   The memory required to decompress is the same as level 1.
> - The compression speed and ratio will vary based on the source.
> 
> Level	Ratio	Compression	Decompression	Compression Memory
> 1    	2.59 	153 MB/s   	112 MB/s     	0.8 MB
> 2    	2.67 	136 MB/s   	113 MB/s     	1.0 MB
> 3    	2.72 	106 MB/s   	115 MB/s     	1.3 MB
> 4    	2.78 	86  MB/s   	109 MB/s     	0.9 MB
> 5    	2.83 	69  MB/s   	109 MB/s     	1.4 MB
> 6    	2.89 	53  MB/s   	110 MB/s     	1.5 MB
> 7    	2.91 	40  MB/s   	112 MB/s     	1.4 MB
> 8    	2.92 	34  MB/s   	110 MB/s     	1.8 MB
> 9    	2.93 	27  MB/s   	109 MB/s     	1.8 MB
> 10   	2.94 	22  MB/s   	109 MB/s     	1.8 MB
> 11   	2.95 	17  MB/s   	114 MB/s     	1.8 MB
> 12   	2.95 	13  MB/s   	113 MB/s     	1.8 MB
> 13   	2.95 	10  MB/s   	111 MB/s     	2.3 MB
> 14   	2.99 	7   MB/s   	110 MB/s     	2.6 MB
> 15   	3.03 	6   MB/s   	110 MB/s     	2.6 MB
> 
> [0] http://sun.aei.polsl.pl/~sdeor/index.php?page=silesia
> 
> Signed-off-by: Jennifer Liu <jenniferliu620@fb.com>
> Signed-off-by: Nick Terrell <terrelln@fb.com>
> Reviewed-by: Omar Sandoval <osandov@fb.com>

Please split the patch to a series where each patch does one logical
thing.
