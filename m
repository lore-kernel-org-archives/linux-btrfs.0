Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59839 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbcENA4k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 20:56:40 -0400
Date: Fri, 13 May 2016 20:56:34 -0400
From: Chris Mason <clm@fb.com>
To: Eric Biggers <ebiggers3@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING at fs/btrfs/inode.c:9261 btrfs_destroy_inode()
Message-ID: <20160514005634.GB93143@clm-mbp.thefacebook.com>
References: <20160510231920.GA938@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160510231920.GA938@zzz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 06:19:20PM -0500, Eric Biggers wrote:
> Hello,
> 
> The following warning has been triggering for me since about v4.6-rc3:
> 
> 	WARN_ON(BTRFS_I(inode)->csum_bytes);
> 
> On one machine the warning has occurred 657 times since v4.6-rc5.  On another it
> has occurred 3 times since v4.6-rc3.  Both are now on v4.6-rc7, where I have
> still observed the warning.  The warnings occur in groups, and do_unlinkat() and
> evict() are always in the call stack.
> 
> Is this a known issue?  Here is the first occurrence:

Finally tracked this down today, it's a bug in how we deal with page
faults in the middle of a write.  We're testing the fix here and I'll
have a patch on Monday.

Strictly speaking this is a regression in one of Chandan's setup patches
for PAGE_SIZE > sectorsize, but the code was much much too subtle to blame
him.  It should be possible to trigger with a non-aligned multi-page
write, I'm trying to nail down a reliable test program so we don't make
the same mistake again.

-chris
