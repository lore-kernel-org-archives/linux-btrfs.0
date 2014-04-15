Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50160 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbaDOO5j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:57:39 -0400
Message-ID: <534D479E.3070200@fb.com>
Date: Tue, 15 Apr 2014 10:52:14 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaox@cn.fujitsu.com>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
References: <cover.1397572052.git.dsterba@suse.cz> <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
In-Reply-To: <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/15/2014 10:41 AM, David Sterba wrote:
> The patch "Btrfs: fix protection between send and root deletion"
> (18f687d538449373c37c) does not actually prevent to delete the snapshot
> and just takes care during background cleaning, but this seems rather
> user unfriendly, this patch implements the idea presented in
>
> http://www.spinics.net/lists/linux-btrfs/msg30813.html
>
> - add an internal root_item flag to denote a dead root
> - check if the send_in_progress is set and refuse to delete, otherwise
>    set the flag and proceed
> - check the flag in send similar to the btrfs_root_readonly checks, for
>    all involved roots
>
> The root lookup in send via btrfs_read_fs_root_no_name will check if the
> root is really dead or not. If it is, ENOENT, aborted send. If it's
> alive, it's protected by send_in_progress, send can continue.

I'm worried about the use case where we have:

   * periodic automated snapshots
   * periodic automated deletion of old snapshots
   * periodic send for backup

The automated deletion doesn't want to error out if send is in progress, 
it just wants the deletion to happen in the background.

-chris
