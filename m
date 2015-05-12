Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776AbbELPUA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 11:20:00 -0400
Date: Tue, 12 May 2015 17:19:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, marc@merlins.org
Subject: Re: [PATCH] fstests: test for btrfs send with compressed file extents
Message-ID: <20150512151958.GC23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430750059-4833-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430750059-4833-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 04, 2015 at 03:34:19PM +0100, Filipe Manana wrote:
> Test that an incremental send issues valid clone operations for
> compressed file extents.
> 
> For some compressed extents, namely those referred by a file extent item
> with a non-zero data offset, btrfs could issue a clone operation in the
> send stream with an offset and length pair that were not entirely
> contained in the source file's range, causing the receiving side to get
> -EINVAL errors from the clone ioctl when attempting to perform the clone
> operations.
> 
> This issue was fixed by the following linux kernel btrfs patch:
> 
>   Btrfs: incremental send, fix clone operations for compressed extents
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
Tested-by: David Sterba <dsterba@suse.cz>
