Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbeIKRwZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 13:52:25 -0400
Date: Tue, 11 Sep 2018 16:52:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Tucker Boniface <tucker@boniface.tech>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: btrfs-convert: unable to find block group for 0
Message-ID: <20180911145258.GE2997@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>
 <e92c69e8-1145-263f-dce1-f8a55dc15193@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <e92c69e8-1145-263f-dce1-f8a55dc15193@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 08:07:52AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/8/28 上午6:33, Tucker Boniface wrote:
> > Hello, I am trying to convert an ext4 partition to btrfs using
> > btrfs-convert. I am running Arch Linux with kernel 4.18.5 and
> > btrfs-progs 4.17.1. The full error is inline below.
> > 
> > -> # btrfs-convert /dev/sda1
> > create btrfs filesystem:
> >     blocksize: 4096
> >     nodesize:  16384
> >     features:  extref, skinny-metadata (default)
> > creating ext2 image file
> > Unable to find block group for 0
> > Unable to find block group for 0
> > Unable to find block group for 0
> > extent-tree.c:2743: alloc_tree_block: BUG_ON `ret` triggered, value -28
> 
> This means ENOSPC.
> Your ext* doesn't have enough free space to contain btrfs' metadata.

Can we do something better than a crash? The BUG_ON is in
alloc_tree_block, there's only one caller btrfs_alloc_free_block that
handles errors, so it should be straightforward to fix.
