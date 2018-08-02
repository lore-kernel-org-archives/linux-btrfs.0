Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbeHBV2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 17:28:38 -0400
Date: Thu, 2 Aug 2018 21:36:01 +0200
From: David Sterba <dsterba@suse.cz>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs-progs: check: Remove the ability to rebuild
 root overwritting existing tree blocks
Message-ID: <20180802193601.GU3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180705073731.18459-1-wqu@suse.com>
 <20180705073731.18459-2-wqu@suse.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A856B640@G08CNEXMBPEKD03.g08.fujitsu.local>
 <2a81613c-fdad-f7c9-7d12-bab4a67f8353@gmx.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A278D1@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A278D1@G08CNEXMBPEKD02.g08.fujitsu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2018 at 01:53:24AM +0000, Gu, Jinxiang wrote:
> > >> Subject: [PATCH 1/4] btrfs-progs: check: Remove the ability to rebuild root overwritting existing tree blocks
> > >>
> > >> We have function btrfs_fsck_reinit_root() to reinit csum or extent tree.
> > >
> > > Nit：
> > > or fs/file tree
> > 
> > Nope, btrfs check is only capable of reinit csum or extent tree.
> Sorry, not fs/file tree. But DATA RELOC TREE.
> Call stack is reset_balance -> btrfs_fsck_reinit_root, and the root is get by
> btrfs_read_fs_root(fs_info, &key), which key is
> (BTRFS_DATA_RELOC_TREE_OBJECTID, BTRFS_ROOT_ITEM_KEY , (u64)-1)

So, it's correct that the data reloc tree is reinitialized, but this is
part of extent tree reset and there's no separate commandline option for
it. I understand the changelog as a reference to --init-csum-tree and
--init-extent-tree .
