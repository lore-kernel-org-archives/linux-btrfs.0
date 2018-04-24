Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:38830 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758136AbeDXOVY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 10:21:24 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <CA+EzBbC6TfWzsx9Uk8CXT4R89_5QD=tJEyg5wKw=wYVngrtNjg@mail.gmail.com>
References: <CA+EzBbC6TfWzsx9Uk8CXT4R89_5QD=tJEyg5wKw=wYVngrtNjg@mail.gmail.com>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Tue, 24 Apr 2018 09:20:38 -0500
Message-ID: <CAPaz=ELQpM1besaoWCXndZ5rZgPnL=gkaHpWDnBHxtdXDA8iMA@mail.gmail.com>
Subject: Re: Directory entry not persisted on a fsync
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Filipe Manana <fdmanana@kernel.org>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Any thoughts on this?

We completely understand you are all busy and might be traveling, so
we only need a simple ack from you: that when we fsync a directory in
btrfs, we can expect the contents to get persisted. We understand that
is not your highest priority item, and that you will fix it later.

The reason we email to the list is because there is no written set of
guarantees each file system provides. So working with the file-system
developers is the only way we can understand whether something is
intentional behavior or a bug.

It would help us investigate btrfs crash consistency better in the
future and possibly help us find bugs!

Thanks,
Vijay

On Fri, Apr 20, 2018 at 1:05 PM, Jayashree Mohan
<jayashree2912@gmail.com> wrote:
>
> Hi,
>
> We came across a scenario where inspite of fsync-ing the directory,
> the entry was not persisted - the file created under this directory
> was lost.
>
> Consider the following workload :
>
> 1. creat test/foo
> 2. mkdir test/A
> 3. creat test/A/foo
> 4. fsync test/A/foo
> 5. fsync test
> -----crash-----
>
> When we recover after the crash, the contents in the directory are as follows:
> dir test:
>     A
>
> dir test/A:
>     foo
>
> Notice that file foo that was created in step 1 above, is lost inspite
> of calling a fsync on its parent directory. On all other
> filesystems(ext4, xfs, and f2fs), we see file foo persisted in the
> test directory. We expect directory entries to be persisted when the
> directory inode is fsynced right? Losing file foo doesn't seem to be
> the right behavior.
>
>
> Thanks,
> Jayashree Mohan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
