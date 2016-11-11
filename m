Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756146AbcKKUqb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 15:46:31 -0500
Subject: Re: [PULL] Btrfs fixes for 4.9-rc5
To: David Sterba <dsterba@suse.com>
References: <cover.1478789584.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <7efb4535-dbd8-1c7c-c6f0-0dda234077e2@fb.com>
Date: Fri, 11 Nov 2016 15:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1478789584.git.dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/2016 10:00 AM, David Sterba wrote:
> Hi,
>
> two minor error handling fixes and one fix for balance sttus item that goes
> back to 4.4.
>
> The branch continues from my last pull that went to Linus' tree, so it would
> be a good idea to do the same as before. I've added a signed tag for branch.

Looking at this again before sending off:

btrfs: remove redundant check of btrfs_iget return value

Is really a cleanup and we should wait for the merge window.  Since this 
means rebasing the pull, I'm happy to send the others on Monday.

-chris

>
> ----------------------------------------------------------------
> The following changes since commit 9d1032cc49a8a1065e79ee323de66bcb4fdbd535:
>
>   btrfs: fix WARNING in btrfs_select_ref_head() (2016-10-24 18:20:29 +0200)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.9-rc5
>
> for you to fetch changes up to 3ed73b672c8707cab47ef0caf5d0c2a377ad70f2:
>
>   btrfs: Call kunmap if zlib_inflateInit2 fails (2016-11-07 18:07:03 +0100)
>
> ----------------------------------------------------------------
> Christophe JAILLET (1):
>       btrfs: remove redundant check of btrfs_iget return value
>
> David Sterba (1):
>       btrfs: store and load values of stripes_min/stripes_max in balance status item
>
> Nick Terrell (1):
>       btrfs: Call kunmap if zlib_inflateInit2 fails
>
>  fs/btrfs/ctree.h            | 4 ++++
>  fs/btrfs/free-space-cache.c | 2 --
>  fs/btrfs/zlib.c             | 1 +
>  3 files changed, 5 insertions(+), 2 deletions(-)
>
