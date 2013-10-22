Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.154.112.97] ([195.154.112.97]:56320 "EHLO hall.aurel32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab3JVT2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 15:28:16 -0400
Date: Tue, 22 Oct 2013 20:55:24 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v7 00/13] Online(inband) data deduplication
Message-ID: <20131022185524.GA30512@ohm.rr44.fr>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Oct 14, 2013 at 12:59:42PM +0800, Liu Bo wrote:
> Data deduplication is a specialized data compression technique for eliminating
> duplicate copies of repeating data.[1]
> 
> This patch set is also related to "Content based storage" in project ideas[2].
> 
> PATCH 1 is a hang fix with deduplication on, but it's also useful without
> dedup in practice use.
> 
> PATCH 2 and 3 are targetting delayed refs' scalability problems, which are
> uncovered by the dedup feature.
> 
> PATCH 4 is a speed-up improvement, which is about dedup and quota.
> 
> PATCH 5-8 is the preparation for dedup implementation.
> 
> PATCH 9 shows how we implement dedup feature.
> 
> PATCH 10 fixes a backref walking bug with dedup.
> 
> PATCH 11 fixes a free space bug of dedup extents on error handling.
> 
> PATCH 12 fixes a race bug on dedup writes.
> 
> PATCH 13 adds the ioctl to control dedup feature.
> 
> And there is also a btrfs-progs patch(PATCH 14) which involves all details of
> how to control dedup feature.
> 
> I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
> mount and scratch_mount.
> 
> TODO:
> * a bit-to-bit comparison callback.
> 
> All comments are welcome!
> 

Thanks for this new patchset. I have tested it on top of kernel 3.12-rc6
and it worked correctly, although I haven't used it on production
servers given the bit-to-bit comparison callback isn't implemented yet.

I have a few comments on the ioctl to control the dedup feature.
Basically it is used to enable the deduplication, to switch it on or off
and to select the blocksize. Couldn't it be implemented as a mount
option instead like for the other btrfs features? The dedup tree would
be created the first time the mount option is activated, and the on/off
would be controlled by the presence of the dedup mount flag. The
blocksize could be specified with the value appended to the dedup
option, for example dedup=8192.

-- 
Aurelien Jarno                          GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net
