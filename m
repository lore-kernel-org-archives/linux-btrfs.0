Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbbLCRtG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 12:49:06 -0500
Date: Thu, 3 Dec 2015 18:47:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
Message-ID: <20151203174714.GD31035@suse.cz>
Reply-To: dsterba@suse.cz
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz>
 <20151130163407.GA31035@twin.jikos.cz>
 <565CC820.9020706@oracle.com>
 <565CEEF1.80006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <565CEEF1.80006@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 01, 2015 at 08:50:57AM +0800, Qu Wenruo wrote:
> Btrfsck already gives quite good clue on the problem:
> 
> ERROR: chunk_root block unaligned: 4294967168
> ERROR: chunk_root block unaligned: 4294967168
> 
> Chunk root in superblock is not aligned, and the superblock is not valid.
> 
> It would be better to copy all these btrfs-progs enhancement to kernel.

We do have the alignment check in kernel, but it's in the early phase
where we don't know if nodesize is reliable and print only a warning.
