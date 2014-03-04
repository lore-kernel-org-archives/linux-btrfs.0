Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62018 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168AbaCDO62 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 09:58:28 -0500
Message-ID: <5315EA04.5010303@fb.com>
Date: Tue, 4 Mar 2014 09:58:12 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mark Murawski <markm-lists@intellasoft.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: Task Hang
References: <5315E105.3000003@intellasoft.net>
In-Reply-To: <5315E105.3000003@intellasoft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/04/2014 09:19 AM, Mark Murawski wrote:
> I have btrfs as the fs for a backuppc box.  updatedb was running at
> the same time as a massive rsync.
> 
> Mar  4 08:31:00 office-backup kernel: INFO: task
> updatedb.mlocat:903 blocked for more than 120 seconds. Mar  4
> 08:31:00 office-backup kernel:      Not tainted 3.13.2 #3 Mar  4
> 08:31:00 office-backup kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message. Mar
> 4 08:31:00 office-backup kernel: updatedb.mlocat D
> 0000000000000000 0   903    899 0x00000000 Mar  4 08:31:00
> office-backup kernel: ffff88007cad6270 0000000000000086 
> ffff88007c0ee900 0000000000004000 Mar  4 08:31:00 office-backup
> kernel: ffff88005a705fd8 ffff88007cad6270 000000541a6be000
> ffff88007b9ac000 Mar  4 08:31:00 office-backup kernel:
> ffff88001ad2ef68 ffff880001f97000 ffff8800452d4480
> ffffffff812c3e5c Mar  4 08:31:00 office-backup kernel: Call Trace: 
> Mar  4 08:31:00 office-backup kernel: [<ffffffff812c3e5c>] ? 
> btrfs_map_bio+0x4ac/0x5a0 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff812b79c0>] ? repair_io_failure+0x210/0x210 Mar  4
> 08:31:00 office-backup kernel: [<ffffffff810d9a40>] ? 
> __lock_page+0x70/0x70 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff817b8177>] ? io_schedule+0x87/0xd0 Mar  4 08:31:00
> office-backup kernel: [<ffffffff810d9a49>] ? 
> sleep_on_page+0x9/0x10 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff817b8742>] ? __wait_on_bit+0x52/0x80 Mar  4 08:31:00
> office-backup kernel: [<ffffffff81294d21>] ? 
> btree_submit_bio_hook+0xe1/0x110 Mar  4 08:31:00 office-backup
> kernel: [<ffffffff810d9cc3>] ? wait_on_page_bit+0x73/0x80 Mar  4
> 08:31:00 office-backup kernel: [<ffffffff8109bdc0>] ? 
> wake_atomic_t_function+0x30/0x30 Mar  4 08:31:00 office-backup
> kernel: [<ffffffff812bb2ba>] ? 
> read_extent_buffer_pages+0x2aa/0x2e0 Mar  4 08:31:00 office-backup
> kernel: [<ffffffff810da355>] ? add_to_page_cache_lru+0x25/0x40 Mar
> 4 08:31:00 office-backup kernel: [<ffffffff81344b21>] ? 
> radix_tree_insert+0x91/0x250 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff81292a10>] ? verify_parent_transid+0x170/0x170 Mar  4
> 08:31:00 office-backup kernel: [<ffffffff812949a9>] ? 
> btree_read_extent_buffer_pages.constprop.126+0xa9/0x110 Mar  4
> 08:31:00 office-backup kernel: [<ffffffff81294f23>] ? 
> read_tree_block+0x33/0x60 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff812775dc>] ? read_block_for_search.isra.45+0x18c/0x3b0 
> Mar  4 08:31:00 office-backup kernel: [<ffffffff81276d47>] ? 
> comp_keys+0x27/0x30 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff81279c8c>] ? btrfs_search_slot+0x41c/0x920 Mar  4
> 08:31:00 office-backup kernel: [<ffffffff812b1641>] ? 
> btrfs_get_token_16+0x61/0xf0 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff812919f5>] ? btrfs_lookup_inode+0x25/0xa0 Mar  4 08:31:00
> office-backup kernel: [<ffffffff81113ef0>] ? 
> kmem_cache_alloc+0xc0/0xe0 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff812a6313>] ? btrfs_iget+0x103/0x520 Mar  4 08:31:00
> office-backup kernel: [<ffffffff8128eb1f>] ? 
> btrfs_lookup_dir_item+0x9f/0xd0 Mar  4 08:31:00 office-backup
> kernel: [<ffffffff812a843b>] ? btrfs_lookup_dentry+0x3db/0x4c0 Mar
> 4 08:31:00 office-backup kernel: [<ffffffff812a8529>] ? 
> btrfs_lookup+0x9/0x20 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff81120624>] ? lookup_real+0x14/0x50 Mar  4 08:31:00
> office-backup kernel: [<ffffffff811211f2>] ? 
> __lookup_hash+0x32/0x50 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff81121b38>] ? lookup_slow+0x48/0xc0 Mar  4 08:31:00
> office-backup kernel: [<ffffffff81123a91>] ? 
> path_lookupat+0x711/0x760 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff81123b0f>] ? filename_lookup+0x2f/0xd0 Mar  4 08:31:00
> office-backup kernel: [<ffffffff81121d77>] ? 
> getname_flags+0xb7/0x190 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff811269ee>] ? user_path_at_empty+0x5e/0xb0 Mar  4 08:31:00
> office-backup kernel: [<ffffffff8111bd6d>] ? 
> cp_new_stat+0x10d/0x120 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff8111bef1>] ? vfs_fstatat+0x41/0x90 Mar  4 08:31:00
> office-backup kernel: [<ffffffff8111c0c2>] ? 
> SyS_newlstat+0x12/0x30 Mar  4 08:31:00 office-backup kernel:
> [<ffffffff817bb7a2>] ? system_call_fastpath+0x16/0x1b Mar  4
> 08:55:01 office-backup kernel: INFO: task updatedb.mlocat:903 
> blocked for more than 120 seconds. Mar  4 08:55:01 office-backup
> kernel:      Not tainted 3.13.2 #3 Mar  4 08:55:01 office-backup
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message. Mar  4 08:55:01 office-backup kernel: updatedb.mlocat
> D 0000000000000000 0   903    899 0x00000000 Mar  4 08:55:01
> office-backup kernel: ffff88007cad6270 0000000000000086 
> ffff88007bb020d0 0000000000004000 Mar  4 08:55:01 office-backup
> kernel: ffff88005a705fd8 ffff88007cad6270 00000055b6aee000
> ffff88007b9ac000 Mar  4 08:55:01 office-backup kernel:
> ffff8800048282e8 ffff880076f80000 ffff8800272a09c0
> ffffffff812c3e5c Mar  4 08:55:01 office-backup kernel: Call Trace: 
> Mar  4 08:55:01 office-backup kernel: [<ffffffff812c3e5c>] ? 
> btrfs_map_bio+0x4ac/0x5a0 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff812b79c0>] ? repair_io_failure+0x210/0x210 Mar  4
> 08:55:01 office-backup kernel: [<ffffffff810d9a40>] ? 
> __lock_page+0x70/0x70 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff817b8177>] ? io_schedule+0x87/0xd0 Mar  4 08:55:01
> office-backup kernel: [<ffffffff810d9a49>] ? 
> sleep_on_page+0x9/0x10 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff817b8742>] ? __wait_on_bit+0x52/0x80 Mar  4 08:55:01
> office-backup kernel: [<ffffffff81294d21>] ? 
> btree_submit_bio_hook+0xe1/0x110 Mar  4 08:55:01 office-backup
> kernel: [<ffffffff810d9cc3>] ? wait_on_page_bit+0x73/0x80 Mar  4
> 08:55:01 office-backup kernel: [<ffffffff8109bdc0>] ? 
> wake_atomic_t_function+0x30/0x30 Mar  4 08:55:01 office-backup
> kernel: [<ffffffff812bb2ba>] ? 
> read_extent_buffer_pages+0x2aa/0x2e0 Mar  4 08:55:01 office-backup
> kernel: [<ffffffff810da355>] ? add_to_page_cache_lru+0x25/0x40 Mar
> 4 08:55:01 office-backup kernel: [<ffffffff81292a10>] ? 
> verify_parent_transid+0x170/0x170 Mar  4 08:55:01 office-backup
> kernel: [<ffffffff812949a9>] ? 
> btree_read_extent_buffer_pages.constprop.126+0xa9/0x110 Mar  4
> 08:55:01 office-backup kernel: [<ffffffff81294f23>] ? 
> read_tree_block+0x33/0x60 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff812775dc>] ? read_block_for_search.isra.45+0x18c/0x3b0 
> Mar  4 08:55:01 office-backup kernel: [<ffffffff81276d47>] ? 
> comp_keys+0x27/0x30 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff81279c8c>] ? btrfs_search_slot+0x41c/0x920 Mar  4
> 08:55:01 office-backup kernel: [<ffffffff812b1641>] ? 
> btrfs_get_token_16+0x61/0xf0 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff812919f5>] ? btrfs_lookup_inode+0x25/0xa0 Mar  4 08:55:01
> office-backup kernel: [<ffffffff81113ef0>] ? 
> kmem_cache_alloc+0xc0/0xe0 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff812a6313>] ? btrfs_iget+0x103/0x520 Mar  4 08:55:01
> office-backup kernel: [<ffffffff8128eb1f>] ? 
> btrfs_lookup_dir_item+0x9f/0xd0 Mar  4 08:55:01 office-backup
> kernel: [<ffffffff812a843b>] ? btrfs_lookup_dentry+0x3db/0x4c0 Mar
> 4 08:55:01 office-backup kernel: [<ffffffff812a8529>] ? 
> btrfs_lookup+0x9/0x20 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff81120624>] ? lookup_real+0x14/0x50 Mar  4 08:55:01
> office-backup kernel: [<ffffffff811211f2>] ? 
> __lookup_hash+0x32/0x50 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff81121b38>] ? lookup_slow+0x48/0xc0 Mar  4 08:55:01
> office-backup kernel: [<ffffffff81123a91>] ? 
> path_lookupat+0x711/0x760 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff81123b0f>] ? filename_lookup+0x2f/0xd0 Mar  4 08:55:01
> office-backup kernel: [<ffffffff81121d77>] ? 
> getname_flags+0xb7/0x190 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff811269ee>] ? user_path_at_empty+0x5e/0xb0 Mar  4 08:55:01
> office-backup kernel: [<ffffffff8111bd6d>] ? 
> cp_new_stat+0x10d/0x120 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff8111bef1>] ? vfs_fstatat+0x41/0x90 Mar  4 08:55:01
> office-backup kernel: [<ffffffff8111c0c2>] ? 
> SyS_newlstat+0x12/0x30 Mar  4 08:55:01 office-backup kernel:
> [<ffffffff817bb7a2>] ? system_call_fastpath+0x16/0x1b
> 

When this happens again do

echo w > /proc/sysrq-trigger

and then capture dmesg.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFen4AAoJEANb+wAKly3Ba6IP/1msfu3BEPbr4WmX85WHcdL1
MM+WHuDKCgt8hJwqiGZP3qjv+smjzDMMBeyRToAlm2f7MA9shmgE4gvwb1nMQQoG
xfp7ZKPHAypRuYjiq1kmHanQf/vcv4iTCMba0PTBtg2VhMKxH9j9Cdp8/6nqrtRT
QpZXh/1n8MLNBuaYkQ+SXGwqMT3Cgt2zC+NI2YuMtWJNvKpoqsF2IoFCcB8Uy7uX
gG3zDeRyxJESVDMRGmzQOhNI+GW/vZ7EPSK8tjfqWwJJ0ilPhW+iAX7iqZPFr5iU
WhpuQabw75bOcmEp06sk7RXz6EdLhuyTk1zeSZHmgFd9eqaAanfx93mdIk2VM/yC
7kOXrjq4k0QYSEvj11acB5pRB4WBwmELRpWmBa9Gqg31JTj4uScmkI4Gau9TKpwN
qzx+xdNVdUE+W8vtdlvhL+UxEguqMrTLrvMS8wT2npgmylN9QT2jcVmeo+jdCm88
7XI2fP6sP2d7QHhkGpH9bTJouBpH8Rfb2Erow1B+q67DBIHT6x9/RApIiczldX3D
N6/vkbL4Ype8mp4oFUo5Tk0D9sTwAtxRoSDzYpD49u8AwLuloC42ielG85kctaBR
GUhRpEurGY/w0vNlRzJBmkZGvEpq6IWSJaRe9eiMivCh8wsGAGdSf2Jtgg9q4oMS
hMZI04MgEEfMs+6pwfeR
=7EiY
-----END PGP SIGNATURE-----
