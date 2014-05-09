Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbaEIUc3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 16:32:29 -0400
Date: Fri, 9 May 2014 13:32:27 -0700
From: Zach Brown <zab@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: fix inline compressed read err corruption
Message-ID: <20140509203227.GA23244@lenny.home.zabbo.net>
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
 <1399590979-15331-3-git-send-email-zab@redhat.com>
 <20140509135800.GC5988@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140509135800.GC5988@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 03:58:00PM +0200, David Sterba wrote:
> On Thu, May 08, 2014 at 07:16:19PM -0400, Zach Brown wrote:
> > uncompress_inline() is silently dropping an error from
> > btrfs_decompress() after testing it and zeroing the page that was
> > supposed to hold decompressed data.  This can silently turn compressed
> > inline data in to zeros if decompression fails due to corrupt compressed
> > data or memory allocation failure.
> > 
> > I have no idea why uncompress_inline() is zeroing the page for an error
> > from btrfs_decompress() but not for the earlier ENOMEM from kmalloc().
> > Can someone explain this?
> 
> I don't see a reason for that in the current code, nor in the code that
> introduced it. The changes that could have affected that are in the error
> handling, but even with that in mind, the silent error does not make
> sense.

Agreed.  I removed it and will send out a v2 of the series.

- z
