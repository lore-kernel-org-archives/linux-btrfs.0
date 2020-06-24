Return-Path: <SRS0=nWHZ=AF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5ADC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3760120706
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404356AbgFXPto (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 11:49:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:37650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404187AbgFXPto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jun 2020 11:49:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D282DAD09;
        Wed, 24 Jun 2020 15:49:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D0775DA79B; Wed, 24 Jun 2020 17:49:30 +0200 (CEST)
Date:   Wed, 24 Jun 2020 17:49:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Jiachen YANG <farseerfc@gmail.com>
Subject: Re: [PATCH 2/2] btrfs-progs: tests/convert: Add test case to make
 sure we won't allocate dev extents beyond device boundary
Message-ID: <20200624154930.GU27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Jiachen YANG <farseerfc@gmail.com>
References: <20200624115527.855816-1-wqu@suse.com>
 <20200624115527.855816-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624115527.855816-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 24, 2020 at 07:55:27PM +0800, Qu Wenruo wrote:
> Add a test case to check if the converted fs has device extent beyond
> boundary.
> 
> The disk layout of source ext4 fs needs some extents to make them
> allocated at the very end of the fs.
> The script is from the original reporter.
> 
> Also, since the existing convert tests always uses 512M as device size,
> which is not suitable for this test case, make it to grab the existing
> device size to co-operate with this test case.
> 
> Reported-by: Jiachen YANG <farseerfc@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/common.convert                         | 14 ++++++++-
>  tests/convert-tests/017-fs-near-full/test.sh | 30 ++++++++++++++++++++
>  2 files changed, 43 insertions(+), 1 deletion(-)
>  create mode 100755 tests/convert-tests/017-fs-near-full/test.sh
> 
> diff --git a/tests/common.convert b/tests/common.convert
> index f24ceb0d6a64..0c918387758d 100644
> --- a/tests/common.convert
> +++ b/tests/common.convert
> @@ -53,6 +53,16 @@ convert_test_preamble() {
>  	echo "creating test image with: $@" >> "$RESULTS"
>  }
>  
> +get_test_file_size() {
> +	local path="$1"
> +	local ret
> +
> +	ret=$(ls -l "$path" | cut -f5 -d\ )

Parsing ls output is quite fragile, and we have 'stat --format=%s'.
