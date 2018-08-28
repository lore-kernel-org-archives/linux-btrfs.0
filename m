Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33620 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbeH2A3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 20:29:16 -0400
Received: by mail-vk0-f66.google.com with SMTP id w187-v6so1477537vkw.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 13:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
 <CAL3q7H7XVCnA=rtK5ws3WpjxSGYft4br-vVtBr9buBvJwFKBJQ@mail.gmail.com>
In-Reply-To: <CAL3q7H7XVCnA=rtK5ws3WpjxSGYft4br-vVtBr9buBvJwFKBJQ@mail.gmail.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Tue, 28 Aug 2018 15:35:43 -0500
Message-ID: <CA+EzBbCOh9VQC5spBbx81hReqax35kqPYgQmPobF2C8nRbDxCg@mail.gmail.com>
Subject: Re: Strange behavior (possible bugs) in btrfs
To: fdmanana@gmail.com
Cc: Vijay Chidambaram <vvijay03@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Soujanya Ponnapalli <soujanyap95@gmail.com>,
        Ashlie Martinez <ashmrtn@utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

This is to follow up the status of crash consistency bugs we reported
on btrfs. We see that there has been a patch(not in the kernel yet)
(https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg77875.html)
that resolves one of the reported bugs. However, the other bugs we
reported still exist on the latest kernel (4.19-rc1), even with the
submitted patch. Here is the list of other inconsistencies we
reported, along with the workload to reproduce them :
https://www.spinics.net/lists/linux-btrfs/msg77219.html

We just wanted to ensure that resolving these are on your to-do list.
Additionally, if there are more patches queued to address these
issues, please let us know.

Thanks,
Jayashree Mohan

Thanks,
Jayashree Mohan



On Fri, May 11, 2018 at 10:45 AM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Mon, Apr 30, 2018 at 5:04 PM, Vijay Chidambaram <vvijay03@gmail.com> wrote:
> > Hi,
> >
> > We found two more cases where the btrfs behavior is a little strange.
> > In one case, an fsync-ed file goes missing after a crash. In the
> > other, a renamed file shows up in both directories after a crash.
> >
> > Workload 1:
> >
> > mkdir A
> > mkdir B
> > mkdir A/C
> > creat B/foo
> > fsync B/foo
> > link B/foo A/C/foo
> > fsync A
> > -- crash --
> >
> > Expected state after recovery:
> > B B/foo A A/C exist
> >
> > What we find:
> > Only B B/foo exist
> >
> > A is lost even after explicit fsync to A.
> >
> > Workload 2:
> >
> > mkdir A
> > mkdir A/C
> > rename A/C B
> > touch B/bar
> > fsync B/bar
> > rename B/bar A/bar
> > rename A B (replacing B with A at this point)
> > fsync B/bar
> > -- crash --
> >
> > Expected contents after recovery:
> > A/bar
> >
> > What we find after recovery:
> > A/bar
> > B/bar
> >
> > We think this breaks rename's atomicity guarantee. bar should be
> > present in either A or B, but now it is present in both.
>
> I'll take a look at these, and all the other potential issues you
> reported in other threads, next week and let you know.
> Thanks.
>
> >
> > Thanks,
> > Vijay
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> “Whether you think you can, or you think you can't — you're right.”
