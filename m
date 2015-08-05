Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbbHEQlS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 12:41:18 -0400
Date: Wed, 5 Aug 2015 18:40:57 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, robert.munteanu@gmail.com
Subject: Re: [PATCH 0/3] Fix for infinite loop on non-empty inode but with no
 file extent
Message-ID: <20150805164057.GC31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 04:03:11PM +0800, Qu Wenruo wrote:
> A bug reported by Robert Munteanu, which btrfsck infinite loops on an
> inode with discount file extent.
> 
> This patchset includes a fix in printing file extent hole, fix the
> infinite loop, and corresponding test case.
> 
> BTW, thanks Robert Munteanu a lot for its detailed debug report, makes
> it super fast to reproduce the error.
> 
> Qu Wenruo (3):
>   btrfs-progs: fsck: Print correct file hole
>   btrfs-progs: fsck: Fix a infinite loop on discount file extent repair
>   btrfs-progs: fsck-tests: Add test case for inode lost all its file    
>     extent

Applied, thank you both.
