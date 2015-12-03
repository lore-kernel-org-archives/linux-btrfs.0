Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbbLCSBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 13:01:41 -0500
Date: Thu, 3 Dec 2015 18:59:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
Message-ID: <20151203175948.GE31035@suse.cz>
Reply-To: dsterba@suse.cz
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz>
 <20151130163407.GA31035@twin.jikos.cz>
 <565CC820.9020706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <565CC820.9020706@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 11:05:20PM +0100, Vegard Nossum wrote:
> With your patch and a new image, I run into a second issue (which is 
> probably unrelated):

Yes, it's unrelated. As pointed out by Qu, the alignment is wrong and
more strict checks should catch it.

> Should I start a new thread? I've attached the new image. Thanks,

Yes please, the bugs from fuzzers are usually hitting random bugs.
