Return-Path: <SRS0=k4qV=O4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A420C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 14:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9CAE21841
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 14:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbeLSOsi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 09:48:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:54436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728454AbeLSOsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 09:48:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 009B6AFD3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2018 14:48:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3E1FEDA88B; Wed, 19 Dec 2018 15:48:10 +0100 (CET)
Date:   Wed, 19 Dec 2018 15:48:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Make first argument of btrfs_run_delalloc_range
 directly an inode
Message-ID: <20181219144809.GV23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181219075020.18748-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219075020.18748-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 19, 2018 at 09:50:20AM +0200, Nikolay Borisov wrote:
> Since this function is no longer a callback there is no need to have
> its first argument obfuscated with a void *. Change it directly to a
> pointer to an inode. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> David, 
> 
> This little fixlet could be folded in
> 6907b1c2ac72 ("btrfs: Remove extent_io_ops::fill_delalloc") if it's not too 
> late. 

It is too late. The patch to fix is deep in the pull rquest branch, I'd
do such updates not less than a week before sending a pull request and
certainly not on the day I'm about to do so. Qeued for 4.22.
