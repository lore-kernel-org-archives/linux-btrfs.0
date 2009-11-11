From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: BUG? a possible race due to the absence of memory barrier
Date: Thu, 12 Nov 2009 00:07:05 +0900
Message-ID: <2014bcab0911110707i3f2e8782i772603a9b899e353@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I am reporting possible data race
due to the the absence of memory barriers.

I reported a similar issue. Although the previous one turns out to be safe,
please examine this issue and let me know your opinion.

In btrfs_init_new_device(), a btrfs_device object is allocated and initialized
and then links to &root->fs_info->fs_devcies->alloc_list.

It seems that a memory barrier is necessary
between the initialization and the linking to the list.

If these two operations are re-ordered so that executed opposite orders,
it may result data race where uninitialized values are read by other threads.

For btrfs_init_new_device(), i think __btfs_alloc_chunk() is a suspected
to be possible to contribute data race by concurrent execution.

Thank you

Sincerely
Shin Hong
