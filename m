Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:33800 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdHLEb7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 00:31:59 -0400
Received: by mail-ua0-f171.google.com with SMTP id q25so21851143uah.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Aug 2017 21:31:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243.49.228.123.163.1502505534.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com> <1243.49.228.123.163.1502505534.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 11 Aug 2017 22:31:57 -0600
Message-ID: <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 11, 2017 at 8:38 PM,  <siranee.ja@tpc.co.th> wrote:
> Hi Chris,
>
> I explain what I have done in the attached file.

That is way too long. And please don't attach files directed at me,
that's not appropriate. Just message the list normally, so it can be
searched by others down the road.

There is a problem with your rsync command, you really don't
understand what I was asking. The whole point of rsync is to compare
the origin and destination subvolumes to see if they are different
from each other. You ran the command on a single subvolume on a single
machine which is pointless.

On machine A:

$ rsync -avnc /mnt/snapshot6/ chris@192.168.1.116:/mnt/snapshot6/
chris@192.168.1.116's password:
sending incremental file list

sent 125 bytes  received 12 bytes  39.14 bytes/sec
total size is 30,686  speedup is 223.99 (DRY RUN)
[chris@f26h ~]$

Because no files are listed, all are confirmed to be identical. If
files are listed, there's a difference.



> Please suggest me what I should do next?

Check this. I wonder if you're running into this obscure bug where
maybe your read only snapshot is not yet synced before it's being
sent. Hence it *is* changing on origin machine, but not because of
other snapshots being deleted. I have no idea if your scripting
handles errors like the bogus stale NFS handle error, maybe it's
possible it happens but you're not seeing it? Anyway, you might try
just adding a single sync right after taking the snapshot, change
nothing else and see if the problem reproduces itself.

https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Initial_Bootstrapping

I'm pretty sure this is fixed in newer kernels, I haven't run into it
in a long time myself. But I don't know when it was fixed.



-- 
Chris Murphy
