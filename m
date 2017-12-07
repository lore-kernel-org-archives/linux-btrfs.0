Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751904AbdLGTIA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 14:08:00 -0500
Date: Thu, 7 Dec 2017 20:06:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, ahferroin7@gmail.com
Subject: Re: [PATCH 0/9] Remaining part of mkfs --rootdir rework
Message-ID: <20171207190600.GH3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171129091604.2194-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 05:15:55PM +0800, Qu Wenruo wrote:
> Qu Wenruo (9):
>   btrfs-progs: mkfs: Cleanup temporary chunks before filling rootdir
>   btrfs-progs: mkfs: Don't use custom chunk allocator for rootdir
>   btrfs-progs: mkfs/rootdir: Use over-reserve method to make size
>     estimate easier
>   btrfs-progs: mkfs/rootdir: Shrink fs for rootdir option
>   btrfs-progs: mkfs: Separate shrink from rootdir
>   btrfs-progs: mkfs: Fix regression preventing --rootdir to create file
>   btrfs-progs: tests/mkfs: Introduce test case to check if mkfs rootdir
>     can create new file
>   btrfs-progs: mkfs: Use the whole file or block device to mkfs for
>     rootdir
>   btrfs-progs: tests/mkfs: Introduce test case to verify if mkfs.btrfs
>     rootdir shrink behaves correctly

Patches reviewed and merged. The basic test coverage is there, I'm CCing
Austin: we'd appreciate if you could also test it for your usecase.
Thanks.
