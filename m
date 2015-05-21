Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbbEUPEX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 11:04:23 -0400
Date: Thu, 21 May 2015 17:04:22 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        lukas.lueg@gmail.com
Subject: Re: [PATCH] btrfs-progs: Enhance read_tree_block to avoid memory
 corruption.
Message-ID: <20150521150421.GT23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431572784-32124-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150521145249.GS23255@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150521145249.GS23255@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 04:52:49PM +0200, David Sterba wrote:
> The test 001-bad-file-extent-bytenr fails with this patch (and passes
> otherwise). Can you please have a look?

First check expectedly finds problems and fails, then repair is supposed
to fix it, but the final check still finds problems because of the
enhancements you've added:

# output from the final check:
checking extents
invalid nr_items: 0
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
root 5 inode 257 errors 1000, some csum missing
Checking filesystem on .../001-bad-file-extent-bytenr/default_case.img.restored
UUID: 17442351-31aa-45fa-9503-90fd48874c3e
cache and super generation don't match, space cache will be invalidated
found 1081346 bytes used err is 1
total csum bytes: 1024
total tree bytes: 24576
total fs tree bytes: 4096
total extent tree bytes: 4096
btree space waste bytes: 16507
file data blocks allocated: 1310720
 referenced 1310720
btrfs-progs v4.0.1-2-gb7cf7c5c181d
failed: .../btrfs check .../001-bad-file-extent-bytenr/default_case.img.restored

It's "invalid nr_items: 0", while in the unpatched test there's

Device extent[1, 29360128, 8388608] didn't find the relative chunk.
Device extent[1, 1111490560, 1073741824] didn't find the relative chunk.
Dev extent's total-byte(2185232384) is not equal to byte-used(1103101952) in dev[1, 216, 1]

