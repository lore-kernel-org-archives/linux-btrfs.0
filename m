Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdKUP1n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 10:27:43 -0500
Date: Tue, 21 Nov 2017 16:25:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        lakshmipathi.g@gmail.com
Subject: Re: [PATCH 1/2] btrfs: Fix wild memory access in compression level
 parser
Message-ID: <20171121152547.GN3553@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171106024319.32584-1-wqu@suse.com>
 <20171115151103.GN28899@twin.jikos.cz>
 <825b7a24-7cf6-1c0d-fc96-544cf0830fdc@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <825b7a24-7cf6-1c0d-fc96-544cf0830fdc@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 08:49:47AM +0800, Qu Wenruo wrote:
> > But we never set the level to 0 at the point the compression actually
> > happens. See zlib.c:zlib_set_level, if level is 0 then the level
> > passed to zlib is 3. Z_DEFAULT_COMPRESSION is upstream zlib level 6,
> > which is slower, we need zlib to stay in the real-time numbers.
> 
> Right, I missed that.
> 
> So should I still use 0, or use separate macro like
> BTRFS_DEFAULT_ZLIB_LEVEL?

BTRFS_DEFAULT_ZLIB_LEVEL would be better, as this would address
https://patchwork.kernel.org/patch/10021441/
