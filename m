Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33522 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbaDGPZ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 11:25:59 -0400
Message-ID: <5342C382.8000709@fb.com>
Date: Mon, 7 Apr 2014 11:25:54 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/2014 11:20 AM, Filipe David Borba Manana wrote:
> This new send flag makes send calculate first the amount of new file data (in bytes)
> the send root has relatively to the parent root, or for the case of a non-incremental
> send, the total amount of file data we will send through the send stream. In other words,
> it computes the sum of the lengths of all write and clone operations that will be sent
> through the send stream.
>
> This data size value is sent in a new command, named BTRFS_SEND_C_TOTAL_DATA_SIZE, that
> immediately follows a BTRFS_SEND_C_SUBVOL or BTRFS_SEND_C_SNAPSHOT command, and precedes
> any command that changes a file or the filesystem hierarchy. Upon receiving a write or
> clone command, the receiving end can increment a counter by the data length of that
> command and therefore report progress by comparing the counter's value with the data size
> value received in the BTRFS_SEND_C_TOTAL_DATA_SIZE command.
>
> The approach is simple, before the normal operation of send, do a scan in the file system
> tree for new inodes and file extent items, just like in send's normal operation, and keep
> incrementing a counter with new inodes' size and the size of file extents that are going
> to be written or cloned. This is actually a simpler and more lightweight tree scan/processing
> than the one we do when sending the changes, as it doesn't process inode references nor does
> any lookups in the extent tree for example.
>
> After modifying btrfs-progs to understand this new command and report progress, here's an
> example (the -o flag tells btrfs send to pass the new flag to the kernel's send ioctl):
>
>      $ btrfs send -o /mnt/sdd/base | btrfs receive /mnt/sdc
>      At subvol /mnt/sdd/base
>      At subvol base
>      About to receive 9211507211 bytes
>      Subvolume/snapshot /mnt/sdc//base, progress  24.73%, 2278015008 bytes received (9211507211 total bytes)
>
>      $ btrfs send -o -p /mnt/sdd/base /mnt/sdd/incr | btrfs receive /mnt/sdc
>      At subvol /mnt/sdd/incr
>      At snapshot incr
>      About to receive 9211747739 bytes
>      Subvolume/snapshot /mnt/sdc//incr, progress  63.42%, 5843024211 bytes received (9211747739 total bytes)
>

So if we are going to add a new command we want to rev the 
btrfs_stream_header->version so that the old receive command doesn't 
blow up.  Also if we're going to rev the version we want to go ahead and 
add an FALLOCATE and PUNCH command as well so we can stop this silly 
sending zero's stuff and just send down PREALLOC extents as fallocate 
and new holes as a punch command.  Then we only have to rev the version 
once for a bunch of new commands.  Thanks,

Josef

