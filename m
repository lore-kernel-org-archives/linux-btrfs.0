Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF59C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 15:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68CED2081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 15:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68CED2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbeK2C6q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 21:58:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:47126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728217AbeK2C6q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 21:58:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0846BABE2;
        Wed, 28 Nov 2018 15:56:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 92B2FDAC7F; Wed, 28 Nov 2018 16:56:20 +0100 (CET)
Date:   Wed, 28 Nov 2018 16:56:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix typos
Message-ID: <20181128155619.GS2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        linux-btrfs@vger.kernel.org
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128110513.6079-1-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 12:05:13PM +0100, Andrea Gelmini wrote:
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
> 
> Stupid fixes. Made on 4.20-rc4, and ported on linux-next (next-20181128).

Thanks, such patches are accepted once in a while when the amount of new
typo fixes becomes noticeable.

>  fs/btrfs/backref.c         |  4 ++--
>  fs/btrfs/check-integrity.c |  2 +-
>  fs/btrfs/compression.c     |  4 ++--
>  fs/btrfs/ctree.c           |  4 ++--
>  fs/btrfs/dev-replace.c     |  2 +-
>  fs/btrfs/disk-io.c         |  4 ++--
>  fs/btrfs/extent-tree.c     | 28 ++++++++++++++--------------
>  fs/btrfs/extent_io.c       |  4 ++--
>  fs/btrfs/extent_io.h       |  2 +-
>  fs/btrfs/extent_map.c      |  2 +-
>  fs/btrfs/file.c            |  6 +++---
>  fs/btrfs/free-space-tree.c |  2 +-
>  fs/btrfs/inode.c           | 10 +++++-----
>  fs/btrfs/ioctl.c           |  4 ++--
>  fs/btrfs/lzo.c             |  2 +-
>  fs/btrfs/qgroup.c          | 14 +++++++-------
>  fs/btrfs/qgroup.h          |  4 ++--
>  fs/btrfs/raid56.c          |  2 +-
>  fs/btrfs/ref-verify.c      |  6 +++---
>  fs/btrfs/relocation.c      |  2 +-
>  fs/btrfs/scrub.c           |  2 +-
>  fs/btrfs/send.c            |  4 ++--
>  fs/btrfs/super.c           |  8 ++++----
>  fs/btrfs/transaction.c     |  4 ++--
>  fs/btrfs/tree-checker.c    |  6 +++---
>  fs/btrfs/tree-log.c        |  4 ++--
>  fs/btrfs/volumes.c         |  8 ++++----
>  27 files changed, 72 insertions(+), 72 deletions(-)

Approves.

> @@ -1010,14 +1010,14 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
>   *
>   * - multiple snapshots, subvolumes, or different generations in one subvol
>   * - different files inside a single subvolume
> - * - different offsets inside a file (bookend extents in file.c)
> + * - different offsets inside a file (booked extents in file.c)
>   *
>   * The extent ref structure for the implicit back refs has fields for:
>   *
>   * - Objectid of the subvolume root
>   * - objectid of the file holding the reference
>   * - original offset in the file
> - * - how many bookend extents
> + * - how many booked extents

Please note that 'bookend' is not a typo here. The meaning used for
btrfs is close to 2a or 2b in https://www.merriam-webster.com/dictionary/bookend

and refers to the mechanism how blocks are shared by extents and
lengthier explanation would show why snapshots are so cheap (I really
tried to write a tl;dr version, but nope).
