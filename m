Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DF7C432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55AD921655
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441306AbfIXOZs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:25:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:38286 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389030AbfIXOZs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 10:25:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ADB29AD35;
        Tue, 24 Sep 2019 14:25:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 81A67DA835; Tue, 24 Sep 2019 16:26:07 +0200 (CEST)
Date:   Tue, 24 Sep 2019 16:26:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 12/12] btrfs-progs: add test-case for mkfs with
 xxhash64
Message-ID: <20190924142607.GS2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190903150046.14926-1-jthumshirn@suse.de>
 <20190903150046.14926-13-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903150046.14926-13-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 03, 2019 at 05:00:46PM +0200, Johannes Thumshirn wrote:
> Add test-cases for creating a file-system xxhash64 as checksumming
> algorithm.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  tests/mkfs-tests/001-basic-profiles/test.sh | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/mkfs-tests/001-basic-profiles/test.sh b/tests/mkfs-tests/001-basic-profiles/test.sh
> index 6e295274119d..3fa3c8ad42d1 100755
> --- a/tests/mkfs-tests/001-basic-profiles/test.sh
> +++ b/tests/mkfs-tests/001-basic-profiles/test.sh
> @@ -46,6 +46,8 @@ test_mkfs_single  -d  single  -m  dup
>  test_mkfs_single  -d  dup     -m  single
>  test_mkfs_single  -d  dup     -m  dup
>  test_mkfs_single  -d  dup     -m  dup     --mixed
> +test_mkfs_single  -C xxhash64
> +test_mkfs_single  -C xxhash

We'll want to do full test coverage with any of the checksum selected
externally, ie. ina similar way how the 'btrfs check --mode=lowmem' is
done

$ make TEST_ENABLE_OVERRIDE=true TEST_ARGS_CHECK=--mode=lowmem test-check

The support code in the testing sicripts is not there but can be copied
and adapted for mkfs.

A separate test that quickly enumerates over the supported mkfs hashes
would still make sense.
