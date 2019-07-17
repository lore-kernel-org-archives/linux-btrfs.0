Return-Path: <SRS0=CHLg=VO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A21AC76186
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jul 2019 14:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFED720818
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jul 2019 14:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfGQOJx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jul 2019 10:09:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:44578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726081AbfGQOJx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jul 2019 10:09:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 68015B14D;
        Wed, 17 Jul 2019 14:09:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 46D5ADA8E1; Wed, 17 Jul 2019 16:10:29 +0200 (CEST)
Date:   Wed, 17 Jul 2019 16:10:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH -next] btrfs: Select LIBCRC32C again
Message-ID: <20190717141029.GE20977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Guenter Roeck <linux@roeck-us.net>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.com>
References: <1562593403-19545-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562593403-19545-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 08, 2019 at 06:43:23AM -0700, Guenter Roeck wrote:
> With CONFIG_BTRFS_FS=y and CONFIG_CRYPTO_CRC32C=m, we get:
> 
> fs/btrfs/super.o: In function `btrfs_mount_root':
> fs/btrfs/super.c:1557: undefined reference to `crc32c_impl'
> fs/btrfs/super.o: In function `btrfs_print_mod_info':
> fs/btrfs/super.c:2348: undefined reference to `crc32c_impl'
> fs/btrfs/extent-tree.o: In function `btrfs_crc32c':
> fs/btrfs/ctree.h:2609: undefined reference to `crc32c'
> fs/btrfs/ctree.h:2609: undefined reference to `crc32c'
> fs/btrfs/ctree.h:2609: undefined reference to `crc32c'
> fs/btrfs/dir-item.o: In function `btrfs_name_hash':
> fs/btrfs/ctree.h:2619: undefined reference to `crc32c'
> fs/btrfs/ctree.h:2619: undefined reference to `crc32c'
> 
> and more.
> 
> Note that the comment in the offending commit "The module dependency on
> crc32c is preserved via MODULE_SOFTDEP("pre: crc32c"), which was previously
> provided by LIBCRC32C config option doing the same." is wrong, since it
> permits CONFIG_BTRFS_FS=y in combination with CONFIG_CRYPTO_CRC32C=m.
> 
> Cc: David Sterba <dsterba@suse.com>
> Fixes: d5178578bcd4 ("btrfs: directly call into crypto framework for checksumming")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

We already got another fix that is scheduled for post rc1 pull request.
