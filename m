Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37123 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753877AbdHUQu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 12:50:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26717ABF3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 16:50:27 +0000 (UTC)
Date: Mon, 21 Aug 2017 18:49:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove broken memory barrier
Message-ID: <20170821164903.GP2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1501601156-19585-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501601156-19585-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 01, 2017 at 06:25:56PM +0300, Nikolay Borisov wrote:
> Commit 38851cc19adb ("Btrfs: implement unlocked dio write") implemented
> unlocked dio write, allowing multiple dio writers to write to non-overlapping,
> and non-eof-extending regions. In doing so it also introduced a broken memory
> barrier. It is broken due to 2 things:
> 
> 1. Memory barriers _MUST_ always be paired, this is clearly not the case here
> 
> 2. Checkpatch actually produces a warning if a memory barrier is introduced that
> doesn't have a comment explaining how it's being paired.

Specifically for inode::i_dio_count that's wrapped inside
inode_dio_begin, there is no explicit barrier semantics attached, so
removing is fine as the atomic is used in common the waiter/wakeup pattern.

Reviewed-by: David Sterba <dsterba@suse.com>
