Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC2CC282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 18:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E232520685
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 18:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbfDXSHo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 14:07:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:37008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388464AbfDXRQi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 13:16:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76DEFACEC;
        Wed, 24 Apr 2019 17:16:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1C95ADA85E; Wed, 24 Apr 2019 19:17:37 +0200 (CEST)
Date:   Wed, 24 Apr 2019 19:17:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: improve performance on fsync of files with
 multiple hardlinks
Message-ID: <20190424171736.GB20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190417103106.30900-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417103106.30900-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 17, 2019 at 11:31:06AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit 41bd6067692382 ("Btrfs: fix fsync of files with multiple hard links
> in new directories") introduced a path that makes fsync fallback to a full
> transaction commit in order to avoid losing hard links and new ancestors
> of the fsynced inode. That path is triggered only when the inode has more
> than one hard link and either has a new hard link created in the current
> transaction or the inode was evicted and reloaded in the current
> transaction.
> 
> That path ends up getting triggered very often (hundreds of times) during
> the course of pgbench benchmarks, resulting in performance drops of about
> 20%.
> 
> This change restores the performance by not triggering the full transaction
> commit in those cases, and instead iterate the fs/subvolume tree in search
> of all possible new ancestors, for all hard links, to log them.
> 
> Reported-by: Zhao Yuhu <zyuhu@suse.com>
> Tested-by: James Wang <jnwang@suse.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
