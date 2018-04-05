Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35827 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbeDESp4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 14:45:56 -0400
Received: by mail-it0-f50.google.com with SMTP id v194-v6so5409581itb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Apr 2018 11:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180405161106.GH2635@twin.jikos.cz>
References: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com> <20180405161106.GH2635@twin.jikos.cz>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Thu, 5 Apr 2018 11:45:55 -0700
Message-ID: <CANQeFDD1GVHB-epwAnA8wRHbiZt4BOT+eSPRk762xw5vbfj5MQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: clean up resources during umount after trans is aborted
To: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 5, 2018 at 9:11 AM, David Sterba <dsterba@suse.cz> wrote:
> On Sat, Mar 31, 2018 at 06:11:56AM +0800, Liu Bo wrote:
>> Currently if some fatal errors occur, like all IO get -EIO, resources
>> would be cleaned up when
>> a) transaction is being committed or
>> b) BTRFS_FS_STATE_ERROR is set
>>
>> However, in some rare cases, resources may be left alone after transaction
>> gets aborted and umount may run into some ASSERT(), e.g.
>> ASSERT(list_empty(&block_group->dirty_list));
>>
>> For case a), in btrfs_commit_transaciton(), there're several places at the
>> beginning where we just call btrfs_end_transaction() without cleaning up
>> resources.  For case b), it is possible that the trans handle doesn't have
>> any dirty stuff, then only trans hanlde is marked as aborted while
>> BTRFS_FS_STATE_ERROR is not set, so resources remain in memory.
>>
>> This makes btrfs also check BTRFS_FS_STATE_TRANS_ABORTED to make sure that
>> all resources won't stay in memory after umount.
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>
> Is it possible that the following stactrace could be caused by the
> missing check? It roughly matches what you describe (ie. close_ctree and
> unreleased resources). This is from generic/475, that does some error
> injection:
>
> [16991.455178] WARNING: CPU: 6 PID: 23518 at fs/btrfs/extent-tree.c:9896 btrfs_free_block_groups+0x2c8/0x420 [btrfs]
>

Hmm...I don't think so, while running 475, the one I got pretty stable is
ASSERT(list_empty(&block_group->dirty_list));

And I did see this warning a few times, but I thought that was due to
the new flag (ZERO) of fallocate for which we had fixes from Filipe,
not sure if they've been merged?

Anyway, let me double check.

thanks,
liubo

> [16991.621105]  close_ctree+0x114/0x2d0 [btrfs]
> [16991.625482]  generic_shutdown_super+0x6c/0x120
> [16991.630025]  kill_anon_super+0xe/0x20
> [16991.633820]  btrfs_kill_super+0x13/0x100 [btrfs]
> [16991.638550]  deactivate_locked_super+0x3f/0x70
> [16991.643332]  cleanup_mnt+0x3b/0x70
> [16991.646889]  task_work_run+0x89/0xa0
> [16991.650565]  exit_to_usermode_loop+0x79/0xa3
> [16991.654985]  do_syscall_64+0xe9/0x110
> [16991.658841]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
