Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53095 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933768AbcGKPB1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 11:01:27 -0400
Subject: Re: stat() on btrfs reports the st_blocks with delay (data loss in
 archivers)
To: <dsterba@suse.cz>, Pavel Raiskup <praiskup@redhat.com>,
        <linux-btrfs@vger.kernel.org>, bug-tar <bug-tar@gnu.org>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <20160711144119.GY13336@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <67a9457e-3925-e6b3-65db-ff30c6386678@fb.com>
Date: Mon, 11 Jul 2016 11:00:55 -0400
MIME-Version: 1.0
In-Reply-To: <20160711144119.GY13336@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2016 10:41 AM, David Sterba wrote:
> On Sat, Jul 02, 2016 at 09:18:07AM +0200, Pavel Raiskup wrote:
>> There are optimizations in archivers (tar, rsync, ...) that rely on up2date
>> st_blocks info.  For example, in GNU tar there is optimization check [1]
>> whether the 'st_size' reports more data than the 'st_blocks' can hold --> then
>> tar considers that file is sparse (and does additional steps).
>>
>> It looks like btrfs doesn't show correct value in 'st_blocks' until the data
>> are synced.  ATM, there happens that:
>>
>>     a) some "tool" creates sparse file
>>     b) that tool does not sync explicitly and exits ..
>>     c) tar is called immediately after that to archive the sparse file
>>     d) tar considers [2] the file is completely sparse (because st_blocks is
>>        zero) and archives no data.  Here comes data loss.
>>
>> Because we fixed 'btrfs' to report non-zero 'st_blocks' when the file data is
>> small and is in-lined (no real data blocks) -- I consider this is too bug in
>> btrfs worth fixing.
>>
>> [1] http://git.savannah.gnu.org/cgit/paxutils.git/tree/lib/system.h?id=ec72abd9dd63bbff4534ec77e97b1a6cadfc3cf8#n392
>> [2] http://git.savannah.gnu.org/cgit/tar.git/tree/src/sparse.c?id=ac065c57fdc1788a2769fb119ed0c8146e1b9dd6#n273
>>
>> Tested on kernel:
>> kernel-4.5.7-300.fc24.x86_64
>>
>> Originally reported here, reproducer available there:
>> https://bugzilla.redhat.com/show_bug.cgi?id=1352061
>
> The reproducer works for me here. So far I found:
>
> * the btrfs implementation of stat.st_blocks (btrfs_getattr) includes
>   the 'delayed allocated' bytes, so there is not a problem in principle
>   (https://urldefense.proofpoint.com/v2/url?u=http-3A__lxr.free-2Delectrons.com_source_fs_btrfs_inode.c-23L9372&d=CwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=Y07_PApD0zOC-eaM4Hq-oxAwNlktnY8bDo7LD2GbXRo&s=Is_ZqFiL7a4sVWAB1k1ZuAgbNMK-sZ1gcU7oLtyfKoY&e= )
>
> * calling fsync on the sparsefile will produce the expected result
>
> * a short delay between ./binary and 'stat' will also produce correct
>   result, 0.5 seconds worked for me -- so it IMO proves it's a race
>   between writing and reporting the data
>
> * I'm not yet sure where the delay between write and synced
>   'inode->delalloc_bytes' comes from
>
> * I think that st_blocks accounting can be wrong anyway, if the file is
>   mmap-ed and not msync-ed, I'm writing a reproducer for this case

On my test box running current linux git, things work fine if I run the 
reproducer once.  But if I leave it running in a loop long enough for 
writeback to kick in, I trigger it.

The reproducer has a loop in there where it is adding delalloc writes 
and truncating them away.  What should be happening is that we're 
leaving some delalloc bits set past EOF, which makes us skip bumping 
inode->delalloc_bytes during the new write.

I can kind of confirm this by changing the reproducer to stat directly 
after the write call.  Normally st_blocks is never zero.  But if I leave 
it running in a loop for 30 seconds or so, I eventually get st_block 
zero directly after the write().

If I change the C program to unlink the file on exit, running the binary 
over and over again works every time.

So, the real bug is that we're letting some delalloc stat hang around 
after the truncate, probably related to IO in progress.  We do already 
account for delalloc in what we return to stat, but there's a corner 
case involving truncate where we screw it up.

-chris
