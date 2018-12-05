Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67363C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 21:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 336662082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 21:37:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 336662082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbeLEVhd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 16:37:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:35882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727701AbeLEVhd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:37:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B919CAD52
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 21:37:30 +0000 (UTC)
Subject: Re: [PATCH 00/10] btrfs: Support for DAX devices
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
References: <20181205122835.19290-1-rgoldwyn@suse.de>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <6a5b4bb8-896f-14c8-fc71-71b7122dd836@suse.com>
Date:   Wed, 5 Dec 2018 16:37:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/5/18 7:28 AM, Goldwyn Rodrigues wrote:
> This is a support for DAX in btrfs. I understand there have been
> previous attempts at it. However, I wanted to make sure copy-on-write
> (COW) works on dax as well.
> 
> Before I present this to the FS folks I wanted to run this through the
> btrfs. Even though I wish, I cannot get it correct the first time
> around :/.. Here are some questions for which I need suggestions:
> 
> Questions:
> 1. I have been unable to do checksumming for DAX devices. While
> checksumming can be done for reads and writes, it is a problem when mmap
> is involved because btrfs kernel module does not get back control after
> an mmap() writes. Any ideas are appreciated, or we would have to set
> nodatasum when dax is enabled.

Yep.  It has to be nodatasum, at least within the confines of datasum 
today.  DAX mmap writes are essentially in the same situation as with 
direct i/o when another thread modifies the buffer being submitted. 
Except rather than it being a race, it happens every time.  An 
alternative here could be to add the ability to mark a crc as unreliable 
and then go back and update them once the last DAX mmap reference is 
dropped on a range.  There's no reason to make this a requirement of the 
initial implementation, though.

> 2. Currently, a user can continue writing on "old" extents of an mmaped file
> after a snapshot has been created. How can we enforce writes to be directed
> to new extents after snapshots have been created? Do we keep a list of
> all mmap()s, and re-mmap them after a snapshot?

It's the second question that's the hard part.  As Adam describes later, 
setting each pfn read-only will ensure page faults cause the remapping.

The high level idea that Jan Kara and I came up with in our conversation 
at Labs conf is pretty expensive.  We'd need to set a flag that pauses 
new page faults, set the WP bit on affected ranges, do the snapshot, 
commit, clear the flag, and wake up the waiting threads.  Neither of us 
had any concrete idea of how well that would perform and it still 
depends on finding a good way to resolve all open mmap ranges on a 
subvolume.  Perhaps using the address_space->private_list anchored on 
each root would work.

-Jeff

> Tested by creating a pmem device in RAM with "memmap=2G!4G" kernel
> command line parameter.
> 
> 
> [PATCH 01/10] btrfs: create a mount option for dax
> [PATCH 02/10] btrfs: basic dax read
> [PATCH 03/10] btrfs: dax: read zeros from holes
> [PATCH 04/10] Rename __endio_write_update_ordered() to
> [PATCH 05/10] btrfs: Carve out btrfs_get_extent_map_write() out of
> [PATCH 06/10] btrfs: dax write support
> [PATCH 07/10] dax: export functions for use with btrfs
> [PATCH 08/10] btrfs: dax add read mmap path
> [PATCH 09/10] btrfs: dax support for cow_page/mmap_private and shared
> [PATCH 10/10] btrfs: dax mmap write
> 
>   fs/btrfs/Makefile   |    1
>   fs/btrfs/ctree.h    |   17 ++
>   fs/btrfs/dax.c      |  303 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>   fs/btrfs/file.c     |   29 ++++
>   fs/btrfs/inode.c    |   54 +++++----
>   fs/btrfs/ioctl.c    |    5
>   fs/btrfs/super.c    |   15 ++
>   fs/dax.c            |   35 ++++--
>   include/linux/dax.h |   16 ++
>   9 files changed, 430 insertions(+), 45 deletions(-)
> 
> 

-- 
Jeff Mahoney
SUSE Labs

