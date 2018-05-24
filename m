Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031084AbeEXRWN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 13:22:13 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C631AF03
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 17:22:12 +0000 (UTC)
Date: Thu, 24 May 2018 19:19:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/4] btrfs: lzo: Harden decompression callers to avoid
 kernel memory corruption.
Message-ID: <20180524171927.GI6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523082301.29874-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523082301.29874-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 04:22:57PM +0800, Qu Wenruo wrote:
> James Harvey reported pretty strange kernel misbehavior where after
> reading certain btrfs compressed data, kernel crash with unrelated
> calltrace.
> (https://bugzilla.kernel.org/show_bug.cgi?id=199707 and
>  https://www.spinics.net/lists/linux-btrfs/msg77971.html)
...
> Thanks for his comprehensive debug help, we located the problem to:
> 
> v3:
>   Fix comment error for inlined lzo compressed extent. (Still has
>   header), thanks David for pointing this out.
>   Add example ascii graph as an example.
>   Enhance inlined extent check, as header length must match with segment
>   header length + LZO_LEN * 2.
> 
> Qu Wenruo (4):
>   btrfs: compression: Add linux/sizes.h for compression.h
>   btrfs: lzo: Add comment about the how btrfs records its lzo compressed
>     data
>   btrfs: lzo: Add header length check to avoid slab out of bounds access
>   btrfs: lzo: Harden inline lzo compressed extent decompression

Thanks, added to misc-next. I left the wost compression estimate in the
local variable, only added a const to it. Zlib and zstd are using a
different compression container format but some of the check might apply
there too, I haven't looked closer.
