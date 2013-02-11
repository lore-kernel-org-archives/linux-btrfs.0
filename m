Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab3BKN1C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 08:27:02 -0500
Date: Mon, 11 Feb 2013 14:27:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Sjon Hortensius <Sjon@hortensius.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs 0.20rc1.1, linux 3.7.6 - new filesystem: failed to
 recover relocation
Message-ID: <20130211132700.GP12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAMqPLXVezXkqMPn3R56HTVkgPTN859fjukyr06dgtCFPme0Lug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMqPLXVezXkqMPn3R56HTVkgPTN859fjukyr06dgtCFPme0Lug@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 02:09:56PM +0100, Sjon Hortensius wrote:
> I have just completed installing an archlinux machine with 2 btrfs
> partitions, one works fine (the rootfs), the other one I cannot mount.
> Even after recreating the filesystem I still cannot mount it. I
> receive te following output in my dmesg:
> 
> [ 6526.037089] device fsid 74cc8eb8-f60a-4797-9ab3-0c8ac4fe847f devid
> 1 transid 3 /dev/vdb1
> [ 6526.037763] btrfs: disk space caching is enabled
> [ 6526.038415] btrfs: failed to recover relocation
> [ 6526.039716] btrfs: open_ctree failed

What was the size of the filesystem?

> btrfsck reports no errors. An image of this filesystem can be found
> here: http://home.react.nl/~sjon/bug-reports/btrfs/btrfs-failed-to-recover-relocation
> (29 KiB)

Restoring the image produces a 4MB file, which is kind of too small,
there's a patch for mkfs to prevent creating such a fs. I'll get to
adding it to progs integration soon.

david
