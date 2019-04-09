Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6B4C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 00:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF5520857
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 00:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDIAGy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 20:06:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:36278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbfDIAGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 20:06:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD4D3ABB1;
        Tue,  9 Apr 2019 00:06:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 90A92DA88B; Tue,  9 Apr 2019 02:07:59 +0200 (CEST)
Date:   Tue, 9 Apr 2019 02:07:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: send, improve clone range
Message-ID: <20190409000759.GG29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org
References: <1553853807-25293-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553853807-25293-1-git-send-email-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 29, 2019 at 06:03:27PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> Improve clone_range two use scenarios.
> 
> 1. Remove the limit of inode size when find clone inodes
> We can do partial clone, so there is no need to limit the
> size of the candidate inode.
> When clone a range, we clone the legal range only by bytenr,
> offset, len, inode size.
> 
> 2. In the scenarios of rewrite or clone_range, data_offset
> rarely matches exactly, so the chance of a clone is missed.
> 
> e.g.
>     1. Write a 1M file
>         dd if=/dev/zero of=1M bs=1M count=1
> 
>     2. Clone 1M file
>        cp --reflink 1M clone
> 
>     3. Rewrite 4k on the clone file
>        dd if=/dev/zero of=clone bs=4k count=1 conv=notrunc
> 
>     The disk layout is as follows:
>     item 16 key (257 EXTENT_DATA 0) itemoff 15353 itemsize 53
> 	extent data disk byte 1103101952 nr 1048576
> 	extent data offset 0 nr 1048576 ram 1048576
> 	extent compression(none)
>     ...
>     item 22 key (258 EXTENT_DATA 0) itemoff 14959 itemsize 53
> 	extent data disk byte 1104150528 nr 4096
> 	extent data offset 0 nr 4096 ram 4096
> 	extent compression(none)
>     item 23 key (258 EXTENT_DATA 4096) itemoff 14906 itemsize 53
> 	extent data disk byte 1103101952 nr 1048576
> 	extent data offset 4096 nr 1044480 ram 1048576
> 	extent compression(none)
> 
> When send, inode 258 file offset 4096~1048576 (item 23) has a
> chance to clone_range, but because data_offset does not match
> inode 257 (item 16), it causes missed clone and can only transfer
> actual data.
> 
> Improve the problem by judging whether the current data_offset
> has overlap with the file extent item, and if so, adjusting
> offset and extent_len so that we can clone correctly.
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>

Added to misc-next, thanks.
