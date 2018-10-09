Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450BDC64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13E8C214DA
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13E8C214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbeJIXgU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:36:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:54518 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbeJIXgU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 19:36:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5A50AE62;
        Tue,  9 Oct 2018 16:18:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B241ADAD2B; Tue,  9 Oct 2018 18:18:35 +0200 (CEST)
Date:   Tue, 9 Oct 2018 18:18:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix wrong dentries after fsync of file that got
 its parent replaced
Message-ID: <20181009161835.GL29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181009140529.21196-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009140529.21196-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 09, 2018 at 03:05:29PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In a scenario like the following:
> 
>   mkdir /mnt/A               # inode 258
>   mkdir /mnt/B               # inode 259
>   touch /mnt/B/bar           # inode 260
> 
>   sync
> 
>   mv /mnt/B/bar /mnt/A/bar
>   mv -T /mnt/A /mnt/B
>   fsync /mnt/B/bar
> 
>   <power fail>
> 
> After replaying the log we end up with file bar having 2 hard links, both
> with the name 'bar' and one in the directory with inode number 258 and the
> other in the directory with inode number 259. Also, we end up with the
> directory inode 259 still existing and with the directory inode 258 still
> named as 'A', instead of 'B'. In this scenario, file 'bar' should only
> have one hard link, located at directory inode 258, the directory inode
> 259 should not exist anymore and the name for directory inode 258 should
> be 'B'.
> 
> This incorrect behaviour happens because when attempting to log the old
> parents of an inode, we skip any parents that no longer exist. Fix this
> by forcing a full commit if an old parent no longer exists.
> 
> A test case for fstests follows soon.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks, queued for 4.20 with CC: stable 4.4+ .
