Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbcFAMLn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 08:11:43 -0400
Date: Wed, 1 Jun 2016 14:11:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, steve.capper@linaro.org, chandan@mykolab.com,
        jbacik@fb.com, dsterba@suse.com, chandan@linux.vnet.ibm.com,
        feifeixu.sh@gmail.com
Subject: Re: [PATCH V2 0/8] Btrfs: self-tests: Support non-4k page size
Message-ID: <20160601121104.GU29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 07:18:22PM +0800, Feifei Xu wrote:
> Btrfs self-test module assumed that both sectorsize and PAGE_SIZE are 4K.
> Thus many self-tests fail on non-4K page size systems, like ppc64. This
> patchset enables self-tests to be executed on non-4k page size systems.
> 
> This patchset enables us to easily add support for possible sectorsizes and
> nodesizes (e.g. for future subpage-blocksize support).
> 
> This patchset also fixes the following bugs in self-tests:
>  1) Fix integer overflow when calculating bytes_per_bitmap
>  2) Fix infinite loop when searching for free space
>  3) Fix extent test_bitmaps fail on 64k sectorsize system
>  4) Fix extent buffer bitmap test fail on big-endian system
> 
> Also use macros instead of constants add add missing newline
> when print strings in self-tests codes.

The whole patchset looks good to me, the fixes IMO qualify for 4.7 so
I'll add it to for-next. I don't have a 64k page machine to do testing,
so I'd apprecaite some external testing.
