Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33232 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752568AbdHDMJi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 08:09:38 -0400
Received: by mail-oi0-f65.google.com with SMTP id e124so1340107oig.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Aug 2017 05:09:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804145401.78e50990@job>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
 <20170804060007.blgcu5khfo4juwfe@angband.pl> <CANT5p=qvu9tCf73+_PuAj9Ryy69p3JjAyHFY_pAA9eUsTz_ELA@mail.gmail.com>
 <20170804072229.4h534hr54ne3d764@angband.pl> <CANT5p=r9gMUu1F8Vkgs6=O1UBfBLn=96XAZBzB6OsHnSQw0C5A@mail.gmail.com>
 <20170804145401.78e50990@job>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 4 Aug 2017 17:39:36 +0530
Message-ID: <CANT5p=rpTpO8svMzkbtQEb0_CK=OjS5gr55nNdyTjFbbeOAGrA@mail.gmail.com>
Subject: Re: Power down tests...
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks guys. I've enabled that option now. Let's see how it goes.
One general question regarding the stability of btrfs in kernel
version 4.4. Is this okay for power off test cases? Or are there many
important fixes in newer kernels?

On Fri, Aug 4, 2017 at 5:24 PM, Dmitrii Tcvetkov <demfloro@demfloro.ru> wrote:
> On Fri, 4 Aug 2017 13:19:39 +0530
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
>> Oh ok. I read this in the man page and assumed that it's on by
>> default: flushoncommit, noflushoncommit
>>            (default: on)
>>
>>            This option forces any data dirtied by a write in a prior
>> transaction to commit as part of the current commit. This makes the
>> committed state a fully consistent view of the file system from the
>>            application’s perspective (i.e., it includes all completed
>> file system operations). This was previously the behavior only when a
>> snapshot was created.
>>
>>            Disabling flushing may improve performance but is not
>> crash-safe.
>>
>>
>> Maybe this needs a correction?
>
> In 4.12 btrfs-progs man pages it's already updated.
>
> $ man 5 btrfs
> ...
>        flushoncommit, noflushoncommit
>            (default: off)
>
>            This option forces any data dirtied by a write in a prior
>            transaction to commit as part of the current commit,
>            effectively a full filesystem sync.
>
>            This makes the committed state a fully consistent view of
>            the file system from the application’s perspective (i.e., it
>            includes all completed file system operations). This was
>            previously the behavior only when a snapshot was created.
>
>            When off, the filesystem is consistent but buffered writes
>            may last more than one transaction commit.
>
>



-- 
-Shyam
