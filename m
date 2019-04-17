Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63936C282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33FF720835
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732886AbfDQQtz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:49:55 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:60590 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfDQQtz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 12:49:55 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1hGnkp-0005mT-J2; Wed, 17 Apr 2019 18:49:47 +0200
Date:   Wed, 17 Apr 2019 18:49:47 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de,
        darrick.wong@oracle.com, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org
Subject: Re: [PATCH v3 00/18] btrfs dax support
Message-ID: <20190417164947.GA17089@angband.pl>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 11:41:36AM -0500, Goldwyn Rodrigues wrote:
> This patch set adds support for dax on the BTRFS filesystem.
> In order to support for CoW for btrfs, there were changes which had to be
> made to the dax handling. The important one is copying blocks into the
> same dax device before using them which is performed by iomap
> type IOMAP_DAX_COW.

I'm afraid that PMDK's testsuite nearly instantly makes this patchset
explode in different ways.

It'd probably be a waste of your time to require a round-trip to report such
fails and re-test.  As PMDK is probably the biggest userspace component, and
exercises DAX paths in interesting ways, I guess it'd be best if you ran its
testsuite locally until it no longer kills the kernel.


Quick start:

git clone https://github.com/pmem/pmdk
deps: libndctl-dev[el], libdaxctl-dev[el]; rest are mostly optional
(full deps for Fedora:
https://github.com/pmem/pmdk/blob/master/utils/docker/images/Dockerfile.fedora-28
SuSE's should be similar)

cp src/test/testconfig.sh{.example,}
-- then edit, you'd want:
PMEM_FS_DIR=/mnt/pmem      # where you have the dax filesystem on
KEEP_GOING=y               # to see more than one broken test

make
make test    # to build tests
make check   # to build and run all tests
cd src/test && ./RUNTESTS a_single_test

Obviously, PMDK's tests may fail due to some difference of behaviour between
ext4, xfs, and your btrfs implementation -- that'll require some
cooperation.  But crashing the kernel is something where the blame is quite
obvious.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
