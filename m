Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:33340 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbeDMNBJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 09:01:09 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Fri, 13 Apr 2018 07:57:07 -0500
Message-ID: <CAPaz=E+b3-qO-G6ur0bGnocOwo+E8MhXwNSRVmQ7WuF1Pw=HMQ@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Amir,

Thanks for the reply!

On Fri, Apr 13, 2018 at 12:52 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Not a bug.
>
> From man 2 fsync:
>
> "Calling  fsync() does not necessarily ensure that the entry in the
>  directory containing the file has also reached disk.  For that an
>  explicit fsync() on a file descriptor for the directory is also needed."

Are we understanding this right:

ext4 and xfs fsync the parent directory if a sym link file is
fsync-ed. But btrfs does not. Is this what we are seeing?

I agree that fsync of a file does not mean fsync of its directory
entry, but it seems odd to do it for regular files and not for sym
links. We do not see this behavior if we use a regular file instead of
a sym link file.

> There is a reason why this behavior is not being reproduces in
> ext4/xfs, but you should be able to reproduce a similar issue
> like this:
>
>
> 1. symlink (foo, bar.tmp)
> 2. open bar.tmp
> 3. fsync bar.tmp
> 4. rename(bar.tmp, bar)
> 5. fsync bar
> ----crash here----

I'm guessing xfs/ext4 detect the symlink-fsync pattern and fsync the
parent dir in our workload, but would miss it because of the rename in
the workload you provided?

Thanks,
Vijay Chidambaram
http://www.cs.utexas.edu/~vijay/
