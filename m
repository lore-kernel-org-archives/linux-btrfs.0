Return-Path: <SRS0=txhb=62=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C71C2D0F8
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 May 2020 23:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675BD20740
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 May 2020 23:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbgELXE0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:04:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:38044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731291AbgELXE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 May 2020 19:04:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2AF7BAD4F;
        Tue, 12 May 2020 23:04:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E96EBDA70B; Wed, 13 May 2020 01:03:33 +0200 (CEST)
Date:   Wed, 13 May 2020 01:03:33 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Johannes.Thumshirn@wdc.com
Subject: Re: Bug 5.7-rc: root leak, eb leak
Message-ID: <20200512230333.GH18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Johannes.Thumshirn@wdc.com
References: <5e955017351005f2cc4c0210f401935203de8496c56cb76f53547d435f502803.dsterba@suse.com>
 <a1b2a3320c72e9bcd355caf93cc72fc093807c67e63be0fd59a5fbc1a3a6587f.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1b2a3320c72e9bcd355caf93cc72fc093807c67e63be0fd59a5fbc1a3a6587f.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 12, 2020 at 04:14:23PM +0200, David Sterba wrote:
> Root an eb leak.
> 
> Johannes bisected the problem, the first bad commit is one of
> 
> 0e996e7fcf2e3a "btrfs: move ino_cache_inode dropping out of btrfs_free_fs_root"

Unlikely as inode_cache mount option is not used neither by the tests
nor by my testing setup.

> 3fd6372758d91d "btrfs: make the extent buffer leak check per fs info"

Unlikely as it's just moving extent buffer leak detector around.

> 8c38938c7bb096 "btrfs: move the root freeing stuff into btrfs_put_root"

That's most likely the cause.

> Reproduced on btrfs/028,

Johannes, do you have logs from the test?

> [failed, exit status 1][ 7084.791281] BTRFS info (device vdb): at unmount delalloc count 1994752

delalloc leak at umount

> [ 7085.109816] BTRFS error (device vdb): leaked root 18446744073709551607-0 refcount 1

18446744073709551607 == -9, which is BTRFS_DATA_RELOC_TREE_OBJECTID

So some post-reloc cleanup is maybe missing, the test btrfs/028 does
relocation and btrfs/125 as well.
