Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39673 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753684AbcICUF5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Sep 2016 16:05:57 -0400
Subject: Re: [PATCH v2] Btrfs: fix file/data loss caused by fsync after rename
 and new inode
To: <fdmanana@kernel.org>
References: <1459330710-3181-1-git-send-email-fdmanana@kernel.org>
 <1459377441-3609-1-git-send-email-fdmanana@kernel.org>
 <20160818150345.GA24208@clm-mbp.thefacebook.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <c0436515-a21d-1bc0-7064-1e82e86862b3@fb.com>
Date: Sat, 3 Sep 2016 16:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <20160818150345.GA24208@clm-mbp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2016 11:03 AM, Chris Mason wrote:
> On Wed, Mar 30, 2016 at 11:37:21PM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> If we rename an inode A (be it a file or a directory), create a new
>> inode B with the old name of inode A and under the same parent directory,
>> fsync inode B and then power fail, at log tree replay time we end up
>> removing inode A completely. If inode A is a directory then all its files
>> are gone too.
>
> I bisected a crash with dbench down to this patch.  The reproduction was:
>
> mkfs.btrfs -m single -f /dev/vdb
> mount /dev/vdb /btrfs
> cd /btrfs
> mkdir clients
> for x in `seq 0 100` ; do btrfs subvol create clients/client$x ; done
> sync
> dbench 100
>
> In other words, run dbench with a subvol per dbench thread.  It crashes
> immediately, most often with an invalid access in copy_from_user during
> file_write.  The pattern of crashes and location just show general
> memory corruption and the actual stack trace wasn't very useful.
>
> With this patch reverted the runs last much much longer, but we still
> hit a crash eventually.  It's not clear to me if this is two different
> bugs or if Filipe's patch just makes the corruption much easier to hit.
> I'm still digging through it all, but here's a common backtrace with
> this patch reverted:
>

Lots of debugging later, we're leaving btrfs_log_ctx structures from the 
stack in lists without taking them out before btrfs_sync_file() or 
btrfs_sync_log() exit.  I'm still figuring out all of the corner cases 
where it happens, but at least things are starting to make sense again.

I should have a patch out the door on Tuesday.

-chris
