Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:43691 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbeEKPp1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 11:45:27 -0400
Received: by mail-ua0-f193.google.com with SMTP id d4-v6so3888038ual.10
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 08:45:27 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
References: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 11 May 2018 16:45:26 +0100
Message-ID: <CAL3q7H7XVCnA=rtK5ws3WpjxSGYft4br-vVtBr9buBvJwFKBJQ@mail.gmail.com>
Subject: Re: Strange behavior (possible bugs) in btrfs
To: Vijay Chidambaram <vvijay03@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Soujanya Ponnapalli <soujanyap95@gmail.com>,
        Jayashree Mohan <jayashree2912@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 5:04 PM, Vijay Chidambaram <vvijay03@gmail.com> wrote:
> Hi,
>
> We found two more cases where the btrfs behavior is a little strange.
> In one case, an fsync-ed file goes missing after a crash. In the
> other, a renamed file shows up in both directories after a crash.
>
> Workload 1:
>
> mkdir A
> mkdir B
> mkdir A/C
> creat B/foo
> fsync B/foo
> link B/foo A/C/foo
> fsync A
> -- crash --
>
> Expected state after recovery:
> B B/foo A A/C exist
>
> What we find:
> Only B B/foo exist
>
> A is lost even after explicit fsync to A.
>
> Workload 2:
>
> mkdir A
> mkdir A/C
> rename A/C B
> touch B/bar
> fsync B/bar
> rename B/bar A/bar
> rename A B (replacing B with A at this point)
> fsync B/bar
> -- crash --
>
> Expected contents after recovery:
> A/bar
>
> What we find after recovery:
> A/bar
> B/bar
>
> We think this breaks rename's atomicity guarantee. bar should be
> present in either A or B, but now it is present in both.

I'll take a look at these, and all the other potential issues you
reported in other threads, next week and let you know.
Thanks.

>
> Thanks,
> Vijay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
