Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab3LKTE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 14:04:57 -0500
Date: Wed, 11 Dec 2013 20:04:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Pascal Germroth <pascal@ensieve.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: clone syscall fails for bedup-deduplicated files
Message-ID: <20131211190454.GC6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1A5C61DD-175B-4220-BAB5-E5714810501B@ensieve.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1A5C61DD-175B-4220-BAB5-E5714810501B@ensieve.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 07, 2013 at 10:31:30PM +0100, Pascal Germroth wrote:
> Running a 3.8 kernel I've been using bedup to deduplicate some files,
> for example two identical 500MB files A & B now share data chunks.
> Running a 3.11 kernel, I wanted to clone some more files, but those
> previously deduplicated by bedup don't work, for example: `cp
> --reflink A C`:
> 
> open("A", O_WRONLY|O_TRUNC) = 4
> fstat(4, {st_mode=S_IFREG|0775, st_size=0, ...}) = 0
> ioctl(4, BTRFS_IOC_CLONE, 0x3) = -1 EINVAL (Invalid argument)

This can fail eg when the files have different status wrt checksums,
when one of the files is nocow or created under nodatasum mount (there's
no way to create nodatasum file otherwise, unlike nodatacow).

Look at lsattr output if the files have the C attribute.

david
