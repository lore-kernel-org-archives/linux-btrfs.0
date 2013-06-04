Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:56452 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3FDQXU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 12:23:20 -0400
Received: by mail-we0-f176.google.com with SMTP id t56so408389wes.35
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Jun 2013 09:23:19 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Jun 2013 19:23:18 +0300
Message-ID: <CAOcd+r1Z665=5E-8Z_70tQoPDAv2A8MFdfgHQgv10jq6K-faSw@mail.gmail.com>
Subject: wait_block_group_cache_progress() waits forever in case of drive failure
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings all,
when testing drive failures, I occasionally hit the following hang:

# Block group is being cached-in by caching_thread()
# caching_thread() experiences an error, e.g., in btrfs_search_slot,
because of drive failure:
	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
	if (ret < 0)
		goto err;

# caching thread exits:
err:
	btrfs_free_path(path);
	up_read(&fs_info->extent_commit_sem);

	free_excluded_extents(extent_root, block_group);

	mutex_unlock(&caching_ctl->mutex);
out:
	wake_up(&caching_ctl->wait);

	put_caching_control(caching_ctl);
	btrfs_put_block_group(block_group);

However, wait_block_group_cache_progress() is still stuck in a stack like this:
[<ffffffff816ec509>] schedule+0x29/0x70
[<ffffffffa044bd42>] wait_block_group_cache_progress+0xe2/0x110 [btrfs]
[<ffffffff8107fc10>] ? add_wait_queue+0x60/0x60
[<ffffffff8107fc10>] ? add_wait_queue+0x60/0x60
[<ffffffffa04568d6>] find_free_extent+0x306/0xb90 [btrfs]
[<ffffffffa04462ee>] ? btrfs_search_slot+0x2fe/0x820 [btrfs]
[<ffffffffa0457200>] btrfs_reserve_extent+0xa0/0x1b0 [btrfs]
...
because of:
	wait_event(caching_ctl->wait, block_group_cache_done(cache) ||
		   (cache->free_space_ctl->free_space >= num_bytes));

But cache->cached never becomes BTRFS_CACHE_FINISHED, and
cache->free_space_ctl->free_space will also not grow enough, so the
wait never finishes.
At this point, the system totally hangs.

Same problem can happen with wait_block_group_cache_done().

I am thinking: can we add additional condition, like:
	wait_event(caching_ctl->wait,
                       test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state) ||
                       block_group_cache_done(cache) ||
                       (cache->free_space_ctl->free_space >= num_bytes));

So that when transaction aborts, FS is marked as "bad", and then all
these waits will complete, so that the user can unmount?

Or some other way to fix this problem?

Thanks,
Alex.

P.S: should I open a bugzilla for this?
