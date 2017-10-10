Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932075AbdJJQYN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 12:24:13 -0400
Date: Tue, 10 Oct 2017 18:22:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] Btrfs: clear_dirty only on pages only in compression
 range
Message-ID: <20171010162228.GQ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
 <20171003150604.19596-3-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171003150604.19596-3-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 06:06:02PM +0300, Timofey Titovets wrote:
> We need to call extent_range_clear_dirty_for_io()
> on compression range to prevent application from changing
> page content, while pages compressing.
> 
> but "(end - start)" can be much (up to 1024 times) bigger
> then compression range (BTRFS_MAX_UNCOMPRESSED), so optimize that
> by calculating compression range for
> that loop iteration, and flip bits only on that range

I'm not sure this is safe to do. Compress_file_range gets the whole
range [start,end] from async_cow_start, and other parts of code might
rely on the status of the whole range, ie. not partially redirtied.
