From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: BUG? a suspected race bug at cleaner_kthread()
Date: Thu, 3 Sep 2009 10:17:44 +0900
Message-ID: <2014bcab0909021817o4dfa14f2g2634501878e085ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I am reporting a suspected race bug at cleaner_kthread()
in btrfs/disk-io.c of Linux 2.6.30.4.

I hope this report is helpful. Please examine the report and
please let me know your opinion.

clear_ktherad() is spawned as a thread by open_ctree().

The function is finished if kthread_should_stop() or
root->fs_info->closing becomes non-zero.

If clear_kthread() is finished before other thread invoke
kthread_stop() for clear_kthread(),
the caller of kthread_stop() might have problem (waiting indefinitely).

It seems that close_ctree() set fs_info->closing
and then kthread_stop(root->fs_info->cleaner_kthread)
so that it might result this type of error.

Thank you

Sincerely
Shin Hong
