Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53480 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbHYF2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 01:28:25 -0400
Date: Mon, 24 Aug 2015 22:28:20 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, dsterba@suse.com, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Message-ID: <20150825052820.GC20179@merlins.org>
References: <55CB71E5.1070302@fb.com>
 <20150812171912.GL29259@merlins.org>
 <55D1406C.9040607@cn.fujitsu.com>
 <20150817144904.GT29259@merlins.org>
 <20150822143746.GG5602@merlins.org>
 <55DA6F06.7030605@cn.fujitsu.com>
 <20150824042800.GJ5602@merlins.org>
 <55DAA77E.10105@cn.fujitsu.com>
 <20150824141013.GM5602@merlins.org>
 <55DBD814.4000801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55DBD814.4000801@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 10:51:00AM +0800, Qu Wenruo wrote:
> Patches sent and CCed to you.
> 
> Please try the two patches and see what's new.
> This time, I think the output will be much larger.

Indeed.

However the bad news is that gen 39538 is the highest.
Should I force btrfsck to work with an older generation, or do we throw the towel and stop bothering
trying to rescue this FS longer (it's a backup FS, so I have no data I need to recover on it, I just curious
on how it managed to corrupt itself when all I did was a weekly backup to it via btrfs send/receive.

myth:~# sort  -rn -k +4  /var/spool/out  |head -20
Well block 29523968(gen: 39538 level: 1) seems good, and it matches superblock
Well block 29687808(gen: 39537 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 93749248(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 60669952(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 30474240(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 29540352(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 150880256(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 150568960(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 150552576(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 150519808(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 150503424(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 141410304(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 136347648(gen: 39536 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 7312195813376(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 7312194404352(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 7312086122496(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 7312079536128(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 7311940960256(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 7311866003456(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 7311839477760(gen: 39535 level: 1) seems good, but generation/level doesn't match, want gen: 39538 level: 1

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
