Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DCBC43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 980B62067D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfDYPMM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:12:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:39046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726842AbfDYPMM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 11:12:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31774AEE2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 15:12:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2CE33DA847; Thu, 25 Apr 2019 17:13:13 +0200 (CEST)
Date:   Thu, 25 Apr 2019 17:13:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: Allow error injection for
 tree-checker
Message-ID: <20190425151313.GJ20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190424072253.4979-1-wqu@suse.com>
 <20190424174507.GF20156@twin.jikos.cz>
 <143ea4d1-5014-5198-8a34-8d579bef5966@suse.de>
 <20190425141334.GI20156@twin.jikos.cz>
 <f4175d0f-bf0f-3a17-6ddf-603f9620f368@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4175d0f-bf0f-3a17-6ddf-603f9620f368@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 10:22:30PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/25 下午10:13, David Sterba wrote:
> > On Thu, Apr 25, 2019 at 08:30:38AM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2019/4/25 上午1:45, David Sterba wrote:
> >>> On Wed, Apr 24, 2019 at 03:22:53PM +0800, Qu Wenruo wrote:
> >>>> Allowing error injection for btrfs_check_leaf_full() and
> >>>> btrfs_check_node() is useful to test the failure path of btrfs write
> >>>> time tree check.
> >>>>
> >>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>>
> >>> Does not compile:
> >>>
> >>>   CC [M]  fs/btrfs/tests/extent-map-tests.o
> >>> In file included from fs/btrfs/tree-checker.c:18:
> >>> ./include/linux/error-injection.h:15:15: error: unknown type name ‘bool’
> >>>  static inline bool within_error_injection_list(unsigned long addr)
> >>>                ^~~~
> >>> ./include/linux/error-injection.h: In function ‘within_error_injection_list’:
> >>> ./include/linux/error-injection.h:17:9: error: ‘false’ undeclared (first use in this function)
> >>>   return false;
> >>>          ^~~~~
> >>> ./include/linux/error-injection.h:17:9: note: each undeclared identifier is reported only once for each function it appears in
> >>> make[1]: *** [scripts/Makefile.build:275: fs/btrfs/tree-checker.o] Error 1
> >>> make[1]: *** Waiting for unfinished jobs....
> >>> make: *** [Makefile:1737: fs/btrfs/] Error 2
> >>
> >> Compiles without problem here using 8.2.1 gcc.
> >>
> >> ...
> >>   CC [M]  fs/btrfs/check-integrity.o
> >>   CC [M]  fs/btrfs/ref-verify.o
> >>   CC [M]  fs/btrfs/tests/free-space-tests.o
> >>   CC [M]  fs/btrfs/tests/extent-buffer-tests.o
> >>   CC [M]  fs/btrfs/tests/btrfs-tests.o
> >>   CC [M]  fs/btrfs/tests/extent-io-tests.o
> >>   CC [M]  fs/btrfs/tests/inode-tests.o
> >>   CC [M]  fs/btrfs/tests/qgroup-tests.o
> >>   CC [M]  fs/btrfs/tests/free-space-tree-tests.o
> >>   CC [M]  fs/btrfs/tests/extent-map-tests.o
> >>   LD [M]  fs/btrfs/btrfs.o
> >>   Building modules, stage 2.
> >>   MODPOST 1 modules
> >>   CC      fs/btrfs/btrfs.mod.o
> >>   LD [M]  fs/btrfs/btrfs.ko
> >>
> >>>
> >>>
> >>> gcc is 8.3.1
> >>>
> >>
> >> Upgrading to gcc 8.3.0, still passes.
> >>
> >> Is that a regression in gcc 8.3.1?
> > 
> > I don't think it's caused by compiler but config options. And the build
> > bot sees the compilation failure too, so it's not specific to my setup:
> > 
> > https://lists.01.org/pipermail/kbuild-all/2019-April/060303.html
> > 
> 
> Got it reproduced, not sure why the config could affect this problem.
> 
> But the fix is always straightforward, include types for bool and stddef
> for true/false.

As this is only a minor compilation issue, I'll add the includes so we
don't have to wait on the proper fix to land and you can use the
injection.
