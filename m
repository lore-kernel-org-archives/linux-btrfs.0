Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543F0C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 09:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15CEE20877
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 09:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15CEE20877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbeIYPdR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 11:33:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:58592 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727617AbeIYPdR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 11:33:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D1F0AD49;
        Tue, 25 Sep 2018 09:26:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 947FBDAE2F; Tue, 25 Sep 2018 11:26:37 +0200 (CEST)
Date:   Tue, 25 Sep 2018 11:26:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: get rid of btrfs_symlink_aops
Message-ID: <20180925092637.GC3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>
References: <0794275791ff92b445d78d3dd08c67a30a347bbb.1537827364.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0794275791ff92b445d78d3dd08c67a30a347bbb.1537827364.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 24, 2018 at 03:16:55PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The only aops we define for symlinks are identical to the aops for
> regular files. This has been the case since symlink support was added in
> commit 2b8d99a723a3 ("Btrfs: symlinks and hard links"). As far as I can
> tell, there wasn't a good reason to have separate aops then, and there
> isn't now, so let's just do what most other filesystems do and reuse the
> same structure.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Can we also reuse btrfs_inode_operations for
btrfs_special_inode_operations ? The only difference is the fiemap
operation, so if the special files must not implement that callback,
this could be decided inside that.
