Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F101CC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 15:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE8CC21855
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 15:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfDEPsn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 11:48:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:41368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726291AbfDEPsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 11:48:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E8F4B164
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2019 15:48:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EE1DCDA847; Fri,  5 Apr 2019 17:49:46 +0200 (CEST)
Date:   Fri, 5 Apr 2019 17:49:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Fixup and optimization for write time tree checker
Message-ID: <20190405154945.GX29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404034708.3399-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404034708.3399-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 11:47:06AM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/tree_checker_testing
> 
> Which is based on misc-next, with the following commit as HEAD:
> commit 56d46f96de92ec69963acb7b1d9aed83d2a56a7b (david/misc-next-with-write-checks, david/misc-next)
> Author: Nikolay Borisov <nborisov@suse.com>
> Date:   Wed Mar 27 14:24:18 2019 +0200
> 
>     btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit
> 
> These two patches changes the behavior of write time tree-checker, where
> the initial patches didn't check the content of the leaf, leaving memory
> bit flipping possible to sneak in.
> 
> This patchset also introduces a new optimization, where original empty
> leaf owner check can be pretty expensive and cause false alerts for
> write time tree checker.
> With this new optimization, write time tree checker can reuse the
> existing btrfs_check_leaf_full().

This on top of misc-next throws 6 'write time' errors:

btrfs/101               [14:00:24][ 3963.736352] run fstests btrfs/101 at 2019-04-05 14:00:24
[ 3970.417649] BTRFS error (device vdc): block=2446344192 write time tree block corruption detected

btrfs/151               [14:06:52][ 4351.133395] run fstests btrfs/151 at 2019-04-05 14:06:52
[ 4351.659771] BTRFS error (device vdb): block=570572800 write time tree block corruption detected

btrfs/164               [14:07:19][ 4378.349990] run fstests btrfs/164 at 2019-04-05 14:07:19
[ 4380.645918] BTRFS error (device vdb): block=2479882240 write time tree block corruption detected

btrfs/176               [14:07:39][ 4398.493736] run fstests btrfs/176 at 2019-04-05 14:07:39
[ 4399.186203] BTRFS error (device vdb): block=22036480 write time tree block corruption detected
[ 4399.302700] BTRFS error (device vdb): block=1372585984 write time tree block corruption detected

btrfs/184               [14:10:13][ 4552.496289] run fstests btrfs/184 at 2019-04-05 14:10:13
[ 4553.292780] BTRFS error (device vdb): block=4602216448 write time tree block corruption detected

Have you seen the errors during your testing?
