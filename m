Return-Path: <SRS0=7yWS=DU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EBBC433E7
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1632525215
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbgJMPya (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 11:54:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:33148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgJMPy3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Oct 2020 11:54:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1F99EAC6D;
        Tue, 13 Oct 2020 15:54:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 54B36DA7C3; Tue, 13 Oct 2020 17:53:01 +0200 (CEST)
Date:   Tue, 13 Oct 2020 17:53:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v8 03/41] btrfs: Get zone information of zoned block
 devices
Message-ID: <20201013155301.GE6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
References: <cover.1601572459.git.naohiro.aota@wdc.com>
 <dd872ec3ab449a3a97c7a3843aafe15b10154a3f.1601574234.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd872ec3ab449a3a97c7a3843aafe15b10154a3f.1601574234.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 02, 2020 at 03:36:10AM +0900, Naohiro Aota wrote:
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -16,6 +16,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
>  btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
>  btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
>  btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
> +btrfs-$(CONFIG_BLK_DEV_ZONED) += zoned.o

As this is conditionally built in, it should be also added to the string
printed by btrfs_print_mod_info and we want the actual status so

#ifdef CONFIG_BLK_DEV_ZONED
	", zoned=yes"
#else
	", zoned=no"
#endif
