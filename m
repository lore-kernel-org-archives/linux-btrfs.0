Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaEIN6B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 09:58:01 -0400
Date: Fri, 9 May 2014 15:58:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: fix inline compressed read err corruption
Message-ID: <20140509135800.GC5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
 <1399590979-15331-3-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399590979-15331-3-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 07:16:19PM -0400, Zach Brown wrote:
> uncompress_inline() is silently dropping an error from
> btrfs_decompress() after testing it and zeroing the page that was
> supposed to hold decompressed data.  This can silently turn compressed
> inline data in to zeros if decompression fails due to corrupt compressed
> data or memory allocation failure.
> 
> I have no idea why uncompress_inline() is zeroing the page for an error
> from btrfs_decompress() but not for the earlier ENOMEM from kmalloc().
> Can someone explain this?

I don't see a reason for that in the current code, nor in the code that
introduced it. The changes that could have affected that are in the error
handling, but even with that in mind, the silent error does not make
sense.

> Signed-off-by: Zach Brown <zab@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

And future ACK if you're going to kill the memset.
