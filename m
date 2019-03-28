Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590EFC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BE14217F9
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfC1OsM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:48:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:39098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725849AbfC1OsM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:48:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DE603ABD2;
        Thu, 28 Mar 2019 14:48:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 14C4BDA8D8; Thu, 28 Mar 2019 15:49:23 +0100 (CET)
Date:   Thu, 28 Mar 2019 15:49:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190328144922.GL29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-2-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This sets S_DAX in inode->i_flags, which can be used with
> IS_DAX().

I haven't followed the dax developments recently, IIRC the mount option
'dax' was meant to be a temporary solution. I don't know if this has
stuck, or is discouraged to be added to new code. The replacement is the
per-inode xflag.

> The dax option is restricted to non multi-device mounts.
> dax interacts with the device directly instead of using bio, so
> all bio-hooks which we use for multi-device cannot be performed
> here. While regular read/writes could be manipulated with
> RAID0/1, mmap() is still an issue.
> 
> Auto-setting free space tree, because dealing with free space
> inode (specifically readpages) is a nightmare.
> Auto-setting nodatasum because we don't get callback for writing
> checksums after mmap()s.

As discussed before, mandating free-space-tree for dax is ok and even
more that it does not complicate the space cache v1 code.

> Store the dax_device in fs_info which will be used in iomap code.
> Question: Since we have only one dax device, I thought fs_info is
> the best place. However, should it moved to btrfs_device?

At this point it's probably ok to store it in fs_info as the
multi-device support does not exist. If this changes, then the device is
the right place.

As Adam mentioned, support for the 'single' profile would be nice. It's
the simplest profile that over multiple devices only splits the logical
address space (of btrfs) into more chunks. However I don't know if the
dax side does require something that makes this impossible to coexist.
