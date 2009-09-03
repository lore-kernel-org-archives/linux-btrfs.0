From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: BUG? a suspected race bug at cleaner_kthread()
Date: Thu, 3 Sep 2009 11:21:18 +0800
Message-ID: <3d0408630909022021o52398945l65c89ec722df9790@mail.gmail.com>
References: <2014bcab0909021817o4dfa14f2g2634501878e085ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2014bcab0909021817o4dfa14f2g2634501878e085ff@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/9/3 =ED=99=8D=EC=8B=A0 shin hong <hongshin@gmail.com>:
> Hello. I am reporting a suspected race bug at cleaner_kthread()
> in btrfs/disk-io.c of Linux 2.6.30.4.
>
> I hope this report is helpful. Please examine the report and
> please let me know your opinion.
>
> clear_ktherad() is spawned as a thread by open_ctree().
>
> The function is finished if kthread_should_stop() or
> root->fs_info->closing becomes non-zero.
>
> If clear_kthread() is finished before other thread invoke
> kthread_stop() for clear_kthread(),
> the caller of kthread_stop() might have problem (waiting indefinitely=
).
>
> It seems that close_ctree() set fs_info->closing
> and then kthread_stop(root->fs_info->cleaner_kthread)
> so that it might result this type of error.
>

You are right. Would you please send a patch.

Note: there is similar bug in transaction_kthread.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
