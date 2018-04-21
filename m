Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36347 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753077AbeDURX7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Apr 2018 13:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+EzBbC6TfWzsx9Uk8CXT4R89_5QD=tJEyg5wKw=wYVngrtNjg@mail.gmail.com>
References: <CA+EzBbC6TfWzsx9Uk8CXT4R89_5QD=tJEyg5wKw=wYVngrtNjg@mail.gmail.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Sat, 21 Apr 2018 12:23:58 -0500
Message-ID: <CA+EzBbAqPjSEkJBgs7PYrwbcxvF4pr35ZsidJqpLaRyHSbscNw@mail.gmail.com>
Subject: Re: Directory entry not persisted on a fsync
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Filipe Manana <fdmanana@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

A gentle reminder on the above behavior on btrfs : Even on fsync-ing
the directory, its entries are not persisted. Could you let us know
your thoughts on this?

Thanks,
Jayashree Mohan



On Fri, Apr 20, 2018 at 1:05 PM, Jayashree Mohan
<jayashree2912@gmail.com> wrote:
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
