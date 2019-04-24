Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF040C282E1
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 17:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD5A12064A
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 17:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403960AbfDXRoG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 13:44:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:43036 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391749AbfDXRoE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 13:44:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3065BAD18
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 17:44:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D933EDA85E; Wed, 24 Apr 2019 19:45:07 +0200 (CEST)
Date:   Wed, 24 Apr 2019 19:45:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: Allow error injection for
 tree-checker
Message-ID: <20190424174507.GF20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190424072253.4979-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190424072253.4979-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 03:22:53PM +0800, Qu Wenruo wrote:
> Allowing error injection for btrfs_check_leaf_full() and
> btrfs_check_node() is useful to test the failure path of btrfs write
> time tree check.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Does not compile:

  CC [M]  fs/btrfs/tests/extent-map-tests.o
In file included from fs/btrfs/tree-checker.c:18:
./include/linux/error-injection.h:15:15: error: unknown type name ‘bool’
 static inline bool within_error_injection_list(unsigned long addr)
               ^~~~
./include/linux/error-injection.h: In function ‘within_error_injection_list’:
./include/linux/error-injection.h:17:9: error: ‘false’ undeclared (first use in this function)
  return false;
         ^~~~~
./include/linux/error-injection.h:17:9: note: each undeclared identifier is reported only once for each function it appears in
make[1]: *** [scripts/Makefile.build:275: fs/btrfs/tree-checker.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1737: fs/btrfs/] Error 2


gcc is 8.3.1
