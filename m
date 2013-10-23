Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:40317 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3JWNf5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 09:35:57 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so294145bkh.26
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 06:35:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAOcd+r1t-O0V17Pk4ZUy8O-LAnp6a1sqA__RKjWdj8g4JEDT4g@mail.gmail.com>
References: <1376935725-27427-1-git-send-email-fdmanana@gmail.com>
	<1376956371-6764-1-git-send-email-fdmanana@gmail.com>
	<CAOcd+r1t-O0V17Pk4ZUy8O-LAnp6a1sqA__RKjWdj8g4JEDT4g@mail.gmail.com>
Date: Wed, 23 Oct 2013 14:35:55 +0100
Message-ID: <CAL3q7H7Zvp+P1Cg_wj3usfaH550vYen2yg_poy7yBo+r8265xw@mail.gmail.com>
Subject: Re: [PATCH v6] Btrfs: fix memory leak of orphan block rsv
From: Filipe David Manana <fdmanana@gmail.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 23, 2013 at 2:33 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> Hi Filipe,
>
>
> On Tue, Aug 20, 2013 at 2:52 AM, Filipe David Borba Manana
> <fdmanana@gmail.com> wrote:
>>
>> This issue is simple to reproduce and observe if kmemleak is enabled.
>> Two simple ways to reproduce it:
>>
>> ** 1
>>
>> $ mkfs.btrfs -f /dev/loop0
>> $ mount /dev/loop0 /mnt/btrfs
>> $ btrfs balance start /mnt/btrfs
>> $ umount /mnt/btrfs
>>
>> ** 2
>>
>> $ mkfs.btrfs -f /dev/loop0
>> $ mount /dev/loop0 /mnt/btrfs
>> $ touch /mnt/btrfs/foobar
>> $ rm -f /mnt/btrfs/foobar
>> $ umount /mnt/btrfs
>
>
> I tried the second repro script on kernel 3.8.13, and kmemleak does
> not report a leak (even if I force the kmemleak scan). I did not try
> the balance-repro script, though. Am I missing something?

Maybe it's not an issue on 3.8.13 and older releases.
This was on btrfs-next from August 19.

thanks for testing

>
> Thanks,
> Alex.
>
>
>>
>>
>> After a while, kmemleak reports the leak:
>>
>> $ cat /sys/kernel/debug/kmemleak
>> unreferenced object 0xffff880402b13e00 (size 128):
>>   comm "btrfs", pid 19621, jiffies 4341648183 (age 70057.844s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 fc c6 b1 04 88 ff ff 04 00 04 00 ad 4e ad de  .............N..
>>   backtrace:
>>     [<ffffffff817275a6>] kmemleak_alloc+0x26/0x50
>>     [<ffffffff8117832b>] kmem_cache_alloc_trace+0xeb/0x1d0
>>     [<ffffffffa04db499>] btrfs_alloc_block_rsv+0x39/0x70 [btrfs]
>>     [<ffffffffa04f8bad>] btrfs_orphan_add+0x13d/0x1b0 [btrfs]
>>     [<ffffffffa04e2b13>] btrfs_remove_block_group+0x143/0x500 [btrfs]
>>     [<ffffffffa0518158>] btrfs_relocate_chunk.isra.63+0x618/0x790 [btrfs]
>>     [<ffffffffa051bc27>] btrfs_balance+0x8f7/0xe90 [btrfs]
>>     [<ffffffffa05240a0>] btrfs_ioctl_balance+0x250/0x550 [btrfs]
>>     [<ffffffffa05269ca>] btrfs_ioctl+0xdfa/0x25f0 [btrfs]
>>     [<ffffffff8119c936>] do_vfs_ioctl+0x96/0x570
>>     [<ffffffff8119cea1>] SyS_ioctl+0x91/0xb0
>>     [<ffffffff81750242>] system_call_fastpath+0x16/0x1b
>>     [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> This affects btrfs-next, revision be8e3cd00d7293dd177e3f8a4a1645ce09ca3acb
>> (Btrfs: separate out tests into their own directory).
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>
>> V2: removed atomic_t member in struct btrfs_block_rsv, as suggested by
>>     Josef Bacik, and use instead the condition reserved == 0 to decide
>>     when to free the block.
>> V3: simplified patch, just kfree() (and not btrfs_free_block_rsv) the
>>     root's orphan_block_rsv when free'ing the root. Thanks Josef for
>>     the suggestion.
>> V4: use btrfs_free_block_rsv() instead of kfree(). The error I was getting
>>     in xfstests when using btrfs_free_block_rsv() was unrelated, Josef just
>>     pointed it to me (separate issue).
>> V5: move the free call below the iput() call, so that btrfs_evict_node()
>>     can process the orphan_block_rsv first to do some needed cleanup before
>>     we free it.
>> V6: free the root's orphan_block_rsv in close_ctree() too. After a balance
>>     the orphan_block_rsv of the tree of tree roots was being leaked, because
>>     free_fs_root() is only called for filesystem trees.
>>
>>  fs/btrfs/disk-io.c |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 3b12c26..5d17163 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3430,6 +3430,8 @@ static void free_fs_root(struct btrfs_root *root)
>>  {
>>         iput(root->cache_inode);
>>         WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
>> +       btrfs_free_block_rsv(root, root->orphan_block_rsv);
>> +       root->orphan_block_rsv = NULL;
>>         if (root->anon_dev)
>>                 free_anon_bdev(root->anon_dev);
>>         free_extent_buffer(root->node);
>> @@ -3582,6 +3584,9 @@ int close_ctree(struct btrfs_root *root)
>>
>>         btrfs_free_stripe_hash_table(fs_info);
>>
>> +       btrfs_free_block_rsv(root, root->orphan_block_rsv);
>> +       root->orphan_block_rsv = NULL;
>> +
>>         return 0;
>>  }
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
