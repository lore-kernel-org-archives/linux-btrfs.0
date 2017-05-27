Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33585 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdE0U37 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 May 2017 16:29:59 -0400
Received: by mail-yw0-f195.google.com with SMTP id y64so2519265ywe.0
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 13:29:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c3d2a91c-6fea-d273-2d58-1f8ea700b942@mendix.com>
References: <CADzmB23Ytbp4eQcXZstFNM9W76Ug6DuyK-4rm_-VgOKzLsw1mQ@mail.gmail.com>
 <c3d2a91c-6fea-d273-2d58-1f8ea700b942@mendix.com>
From: Ivan P <chrnosphered@gmail.com>
Date: Sat, 27 May 2017 22:29:38 +0200
Message-ID: <CADzmB21E6btzsS9HQXk_AC+zVks1CHu=x8NVSnPQ+=+y4fgzPQ@mail.gmail.com>
Subject: Re: btrfs-tools/linux 4.11: btrfs-cleaner misbehaving
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 27, 2017 at 9:33 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> Hi,
>
> On 05/27/2017 08:53 PM, Ivan P wrote:
>>
>> for a while now, btrfs-cleaner has been molesting my system's btrfs partition,
>> as well as my CPU. The behavior is as following:
>>
>> After booting, nothing relevant is happening. After about 5-30 minutes,
>> a btrfs-cleaner process is spawned, which is constantly using one CPU core.
>> The btrfs-cleaner process never seems to finish (I've let it waste CPU cycles
>> for 9 hours) and also cannot be stopped or killed.
>>
>> Rebooting again usually resolves the issue for some time.
>> But on next boot, the issue usually reappears.
>>
>> I'm running linux 4.11.2, but the issue is also present on current LTS 4.9.29.
>> I am using newest btrfs-tools, as far as I can tell (4.11). The system is an
>> arch linux x64 installed on a Transcend 120GB mSATA drive.
>>
>> No other disks are present, but the root volume contains several subvolumes
>> (@arch<date> snapshots, @home, @data).
>>
>> The logs don't contain anything related to btrfs, beside the usual diag output
>> on mounting the root partition.
>>
>> I am mounting the btrfs partition with the following options:
>>
>> subvol=@arch_current,compress=lzo,ssd,noatime,autodefrag
>>
>> What information should I provide so we could debug this?
>
> What I usually do first in a similar situation is look at the output of
>
>   watch cat /proc/<pid>/stack
>
> where <pid> is the pid of the btrfs-cleaner thread.
>
> This might already give an idea what kind of things it's doing, by
> looking at the stack trace. When it's cleaning up a removed subvolume
> for example, there will be a similar function name in the stack somewhere.
>
> --
> Hans van Kranenburg

Thank you for the fast reply.

Most of the time, the stack is just 0xffffffffffffffff, even though
CPU load is generated.
These repeat all the time, but addresses stay the same:

[<ffffffffa0444f19>] get_alloc_profile+0xa9/0x1a0 [btrfs]
[<ffffffffa04450d2>] can_overcommit+0xc2/0x110 [btrfs]
[<ffffffffa044a21e>] btrfs_free_reserved_data_space_noquota+0x6e/0x100 [btrfs]
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa04451ae>] block_rsv_release_bytes+0x8e/0x2b0 [btrfs]
[<ffffffffa044a21e>] btrfs_free_reserved_data_space_noquota+0x6e/0x100 [btrfs]
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa04451ae>] block_rsv_release_bytes+0x8e/0x2b0 [btrfs]
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8162efcf>] retint_kernel+0x1b/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff

So far, these appeared only once or twice:

[<ffffffff8162efcf>] retint_kernel+0x1b/0x1d
[<ffffffff81316d66>] __radix_tree_lookup+0x76/0xf0
[<ffffffff81316e3d>] radix_tree_lookup+0xd/0x10
[<ffffffff8118121f>] __do_page_cache_readahead+0x10f/0x2f0
[<ffffffff81181593>] ondemand_readahead+0x193/0x2c0
[<ffffffff8118185e>] page_cache_sync_readahead+0x2e/0x50
[<ffffffffa04a23ab>] btrfs_defrag_file+0x9fb/0xf90 [btrfs]
[<ffffffffa047b66a>] btrfs_run_defrag_inodes+0x25a/0x350 [btrfs]
[<ffffffffa045cc67>] cleaner_kthread+0x147/0x180 [btrfs]
[<ffffffff810a04d8>] kthread+0x108/0x140
[<ffffffff8162e85c>] ret_from_fork+0x2c/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff81003016>] ___preempt_schedule+0x16/0x18
[<ffffffffa0487556>] __clear_extent_bit+0x2a6/0x3e0 [btrfs]
[<ffffffffa0487c57>] clear_extent_bit+0x17/0x20 [btrfs]
[<ffffffffa04a26fa>] btrfs_defrag_file+0xd4a/0xf90 [btrfs]
[<ffffffffa047b66a>] btrfs_run_defrag_inodes+0x25a/0x350 [btrfs]
[<ffffffffa045cc67>] cleaner_kthread+0x147/0x180 [btrfs]
[<ffffffff810a04d8>] kthread+0x108/0x140
[<ffffffff8162e85c>] ret_from_fork+0x2c/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8162efcf>] retint_kernel+0x1b/0x1d
[<ffffffff810ce28a>] __rcu_read_unlock+0x4a/0x60
[<ffffffff8118000b>] __set_page_dirty_nobuffers+0xdb/0x170
[<ffffffffa0468c1e>] btrfs_set_page_dirty+0xe/0x10 [btrfs]
[<ffffffff8117dd7b>] set_page_dirty+0x5b/0xb0
[<ffffffffa04a274e>] btrfs_defrag_file+0xd9e/0xf90 [btrfs]
[<ffffffffa047b66a>] btrfs_run_defrag_inodes+0x25a/0x350 [btrfs]
[<ffffffffa045cc67>] cleaner_kthread+0x147/0x180 [btrfs]
[<ffffffff810a04d8>] kthread+0x108/0x140
[<ffffffff8162e85c>] ret_from_fork+0x2c/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

Forgot to mention that I have tried running a scrub, but it neither
reported any errors nor solved the issue.

Regards,
Ivan
