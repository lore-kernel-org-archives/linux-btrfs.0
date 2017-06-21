Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753019AbdFUQUy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 12:20:54 -0400
Subject: Re: btrfs_wait_ordered_roots warning triggered
To: Dave Jones <davej@codemonkey.org.uk>
References: <20170621151632.dsipxge7zdklbink@codemonkey.org.uk>
CC: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <afa1575f-c035-0d8f-741d-25856b9d4f7e@fb.com>
Date: Wed, 21 Jun 2017 11:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <20170621151632.dsipxge7zdklbink@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2017 11:16 AM, Dave Jones wrote:
> WARNING: CPU: 2 PID: 7153 at fs/btrfs/ordered-data.c:753 btrfs_wait_ordered_roots+0x1a3/0x220
> CPU: 2 PID: 7153 Comm: kworker/u8:7 Not tainted 4.12.0-rc6-think+ #4
> Workqueue: events_unbound btrfs_async_reclaim_metadata_space
> task: ffff8804f08d5380 task.stack: ffffc9000895c000
> RIP: 0010:btrfs_wait_ordered_roots+0x1a3/0x220
> RSP: 0018:ffffc9000895fc70 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 00000000f7efdfb1 RCX: 00000000000025c3
> RDX: ffff880507c0cde0 RSI: 0000000000000000 RDI: 0000000000000002
> RBP: ffffc9000895fce8 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffc9000895fbd8 R11: ffff8804f08d5380 R12: ffff8804f4930008
> R13: 0000000000000001 R14: ffff8804f36f0000 R15: ffff8804f4930850
> FS:  0000000000000000(0000) GS:ffff880507c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd40c4a1bf2 CR3: 000000013995e000 CR4: 00000000001406e0
> DR0: 00007f17be890000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Call Trace:
>  flush_space+0x285/0x6e0
>  btrfs_async_reclaim_metadata_space+0xd7/0x420
>  process_one_work+0x24d/0x680
>  worker_thread+0x4e/0x3b0
>  kthread+0x117/0x150
>  ? process_one_work+0x680/0x680
>  ? kthread_create_on_node+0x70/0x70
>  ret_from_fork+0x27/0x40

Thanks Dave, which trinity command line triggered this?

-chris
