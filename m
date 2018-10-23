Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561E9C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 15:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 254DB20671
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 15:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 254DB20671
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbeJWXYd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 19:24:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:55570 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbeJWXYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 19:24:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E84AEB056
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 15:00:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5BB6EDABAA; Tue, 23 Oct 2018 17:00:37 +0200 (CEST)
Date:   Tue, 23 Oct 2018 17:00:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/10] Freespace tree repair support v2
Message-ID: <20181023150036.GR16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:11PM +0300, Nikolay Borisov wrote:
> Here is the v2 of the freespace tree repair support patches. Version 1 can be 
> found at [0]. For background on the series please refer to the initial cover 
> letter. This time round a number of changes have been incorporated based on 
> feedback from Omar. Namely: 
> 
> 1. Added 2 new patches, patches 3 and 4,  which refactor the userspace
> impelementation of various bit manipulation functions. This was required to
> implement the bitmap conversion code from kernel space. 
> 
> 2. Extended patch 5 to include the bitmap conversion code, now userspace 
> handles the case of fragmented fst. 
> 
> 3. Re-ordered patches 6 and 7 so that we first hook into the extent 
> alloc/dealloc sequence (patch 6) and finally enable support for fst in patch 7.
> 
> 4. Updated the FST test (patch 9) to work with the new bitmap conversion code 
> since it changed the layout of the expected freespace tree. Now the test 
> passes again. Also removed an unused function. 
> 
> 5. Added patch 10 which fixes a similar bug to e444c7bfa65f ("btrfs-progs:
> check: Fix wrong error message in case of corrupted extent")
> 
> Following the updates, I rerun all misc/fsck-tests and no failures were 
> observed. 
> 
> More feedback and suggestions are always welcomed.
> 
> [0] https://lore.kernel.org/linux-btrfs/1529060762-4372-1-git-send-email-nborisov@suse.com/
> 
> 
> Nikolay Borisov (10):
>   btrfs-progs: Add support for freespace tree in btrfs_read_fs_root
>   btrfs-progs: Add extent buffer bitmap manipulation infrastructure
>   btrfs-progs: Replace homegrown bitops related functions with kernel
>     counterparts
>   btrfs-progs: Implement find_*_bit_le operations
>   btrfs-progs: Pull free space tree related code from kernel
>   btrfs-progs: Hook FST code in extent (de)alloc
>   btrfs-progs: Add freespace tree as compat_ro supported feature
>   btrfs-progs: check: Add support for freespace tree fixing
>   btrfs-progs: tests: Test for FST corruption detection/repair
>   btrfs-progs: check: Fix wrong error message in case of corrupted
>     bitmap

As there's been sufficient review, I'm adding it to devel and schedule
it for the next major release. There were some fixups needed but not in
the functionality itself. If you have futher updates, plase send them as
separate patches. Thanks.
