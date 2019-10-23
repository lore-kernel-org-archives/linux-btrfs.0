Return-Path: <SRS0=avBk=YQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31097CA9EBB
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 12:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10E2B214B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 12:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405296AbfJWMWM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:22:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:57030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbfJWMWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Oct 2019 08:22:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43C58B3C1;
        Wed, 23 Oct 2019 12:22:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 53C63DA734; Wed, 23 Oct 2019 14:22:22 +0200 (CEST)
Date:   Wed, 23 Oct 2019 14:22:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        ashnell@suse.de
Subject: Re: [PATCH] btrfs-progs: build: add missing symbols from volumes.o
 to libbtrfs
Message-ID: <20191023122222.GB3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        ashnell@suse.de
References: <20191023080226.10826-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023080226.10826-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 23, 2019 at 10:02:26AM +0200, Johannes Thumshirn wrote:
> When using snapper a user reports that some symbols from volumes.[ch] are
> missing from libbtrfs, eg. write_raid56_with_parity().

With this patch on top of master:

$ make library-test
    [TEST PREP]  library-test
/usr/lib64/gcc/x86_64-suse-linux/9/../../../../x86_64-suse-linux/bin/ld: /labs/dsterba/gits/btrfs-progs/libbtrfs.so: undefined reference to `write_raid56_with_parity'
/usr/lib64/gcc/x86_64-suse-linux/9/../../../../x86_64-suse-linux/bin/ld: /labs/dsterba/gits/btrfs-progs/libbtrfs.so: undefined reference to `btrfs_map_block'
/usr/lib64/gcc/x86_64-suse-linux/9/../../../../x86_64-suse-linux/bin/ld: /labs/dsterba/gits/btrfs-progs/libbtrfs.so: undefined reference to `total_memory'
collect2: error: ld returned 1 exit status
make: *** [Makefile:621: library-test] Error 1
