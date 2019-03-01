Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB04BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE5120818
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389185AbfCAQsq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:48:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:33022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728285AbfCAQsp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Mar 2019 11:48:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10D54AE63
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Mar 2019 16:48:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2EF7EDA851; Fri,  1 Mar 2019 17:50:04 +0100 (CET)
Date:   Fri, 1 Mar 2019 17:50:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: Fix false alert about uninitialized
Message-ID: <20190301165003.GU31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190227054952.2811-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227054952.2811-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 01:49:52PM +0800, Qu Wenruo wrote:
> GCC 8.2.1 will report the following error:
> 
>   check/main.c: In function 'try_repair_inode':
>   check/main.c:2606:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
>     if (!ret) {
>        ^
>   check/main.c:2584:6: note: 'ret' was declared here
>     int ret;
>         ^~~
> 
> The offending code is in repair_mismatch_dir_hash():
> 
> 	int ret;
> 
> 	printf(
> 	"Deleting bad dir items with invalid hash for root %llu ino %llu\n",
> 		root->root_key.objectid, rec->ino);
> 	while (!list_empty(&rec->mismatch_dir_hash)) {
> 		/* do some repair */
> 	}
> 	if (!ret) { <<< Here
> 		/* do some fix */
> 	}
> 
> The truth is, to enter try_repair_inode(), we must have
> I_ERR_MISMATCH_DIR_HASH bit set for rec->errors.
> 
> And just after we set I_ERR_MISMATCH_DIR_HASH, we call
> add_mismatch_dir_hash() and handled its error correctly.
> 
> So it's impossible to to skip the while loop.
> 
> Fix it by initializing @ret to -EUCLEAN, so even we hit some impossible
> case, repair_mismatch_dir_hash() won't falsely consider the mismatch
> hash fixed.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
