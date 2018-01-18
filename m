Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35083 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756517AbeAROTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:19:36 -0500
Date: Thu, 18 Jan 2018 15:17:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: fix space leak after fallocate and zero range
 operations
Message-ID: <20180118141725.GI13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180118113431.12744-1-fdmanana@kernel.org>
 <3bbe79f2-1e33-0745-fd10-aaa1eba98cd0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3bbe79f2-1e33-0745-fd10-aaa1eba98cd0@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 18, 2018 at 01:45:20PM +0200, Nikolay Borisov wrote:
> >  [95795.015577] R10: 00000000000006b4 R11: 0000000000000246 R12: 00007fa6791bae64
> >  [95795.016569] R13: 0000000000000000 R14: 0000563386706210 R15: 00007ffccf0ab160
> >  [95795.017662] Code: 00 00 00 4c 8b a3 98 25 00 00 49 83 bc 24 60 ff ff ff 00 75 16 49 83 bc 24 68 ff ff ff 00 75 0b 49 83 bc 24 70 ff ff ff 00 74 16 <0f> ff 49 8d b4 24 18 ff ff ff 31 c9 31 d2 48 89 df e8 93 7a ff
> >  [95795.020538] ---[ end trace e95877675c6ec00d ]---
> >  [95795.021259] BTRFS info (device sdi): space_info 4 has 1072775168 free, is not full
> >  [95795.022390] BTRFS info (device sdi): space_info total=1073741824, used=114688, pinned=0, reserved=0, may_use=786432, readonly=65536
> > 
> > Fix this by ensuring the zero range operation does not call
> > btrfs_truncate_block() if the corresponding extent is an unwritten one
> > (it's pointless anyway, since reading from an unwritten extent yields
> > zeroes).
> > 
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> This fixes the leaks me and Josef has seen so:
> 
> Tested-by: Nikolay Borisov <nborisov@suse.com>

Thanks.

Added to current misc-next (that's going to be added to 4.16 queue after
I let it pass through fstests).
