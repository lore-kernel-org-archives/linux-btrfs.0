Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbcBXMiS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 07:38:18 -0500
Date: Wed, 24 Feb 2016 13:38:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/5] btrfs-find-root enhancement for chunk tree corrupted
 fs
Message-ID: <20160224123806.GC23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2016 at 02:59:52PM +0800, Qu Wenruo wrote:
> Before this patchset, btrfs-find-root needs valid chunk tree from the
> fs.
> However for chunk root corrupted case, btrfs-find-root is of no use due
> to above limitation.
> 
> This patchset will allow open_ctree_fs_info() to return a fs_info
> without any valid tree root, but system chunk map from superblock only.
> And modify btrfs-find-root along with some infrastructure to do chunk
> root search.
> 
> Also fix an old bug where btrfs-find-root will always skip the first
> chunk, with its corresponding regression test.
> 
> This also provides the basis for later "btrfsck --chunk-root" and faster
> chunk-recovery enhancement.
> 
> Qu Wenruo (5):
>   btrfs: volume: Fix a bug causing btrfs-find-root to skip first chunk
>   btrfs: Allow open_ctree to return fs_info even chunk tree is corrupted
>   btrfs: Add support for tree block operations on fs_info without roots.
>   btrfs: find-root: Allow btrfs-find-root to search chunk root even
>     chunk     root is corrupted
>   btrfs: misc-test: Add regression test for find-root gives empty result

All applied, with minor adjustments. I'm not going to point them out
in the mails, please make a diff against your branch to see.
