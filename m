Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46154 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbbKMRdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 12:33:11 -0500
Date: Fri, 13 Nov 2015 12:33:02 -0500
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 0/2] Btrfs: fixes for an ENOSPC issue that left a fs
 unusable
Message-ID: <20151113173302.GB17545@ret.masoncoding.com>
References: <1447428032-1872-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1447428032-1872-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 13, 2015 at 03:20:30PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The following pair of changes fix an issue observed in a production
> environment where any file operations done by a package manager failed
> with ENOSPC. Forcing a commit of the current transaction (through "sync")
> didn't help, a balance operation with the filters -dusage=0 didn't help
> either and the issue persisted even after rebooting the machine. There
> were many data blocks groups that were unused, but they weren't getting
> deleted by the cleaner kthread because whenever it tried to start a
> transaction to delete a block group it got -ENOSPC error, which it silently
> ignores (as it does for any other error).
> 
> So these just make sure we fallback to use the global reserve, if -ENOSPC
> is encountered through the standard allocation path, to delete block groups
> as we do already for inode unlink operations. Another issue fixed is hitting
> a BUG_ON() when removing a block group due to -ENSPC failure when creating
> the orphan item for its free space cache inode. This second issue has
> been reported by a few users in the mailing list and bugzilla (for example
> at http://www.spinics.net/lists/linux-btrfs/msg46070.html).
> 
> These changes are also available at:
> http://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/log/?h=integration-4.4

I like both of these.  I'll queue for after rc1.

-chris
