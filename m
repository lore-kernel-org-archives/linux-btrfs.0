Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:35077 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdHMTu4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 15:50:56 -0400
Received: by mail-ua0-f180.google.com with SMTP id d29so30425599uai.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 12:50:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7255.49.228.115.25.1502621539.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail> <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail> <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
 <6341.49.228.122.75.1502590802.squirrel@mail> <CAJCQCtTNw0Y_yg_dyOjE7JPm4rRZ-WMnexh+4E4mRmQ8BFPAWQ@mail.gmail.com>
 <1318.49.228.122.75.1502595606.squirrel@mail> <f63baa3e-c955-ef5e-fe51-ef9d835bcae6@gmail.com>
 <7255.49.228.115.25.1502621539.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 13 Aug 2017 13:50:54 -0600
Message-ID: <CAJCQCtSQWt51877J42bxF=4i66_axarS9JoKLYC4ub_teSyRww@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: A L <crimsoncottage@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 13, 2017 at 4:52 AM,  <siranee.ja@tpc.co.th> wrote:
> Hi "A L",
>
> [root@backuplogC7 ~]# btrfs sub show /var/lib/mariadb/mysql
> /var/lib/mariadb/mysql
>         Name:                   mysql
>         UUID:                   92f319c5-e132-3249-9b13-d39ee77a2b44
>         Parent UUID:            -
>         Received UUID:          3ad0334a-4063-654c-add6-b1cbcdeaa639
>         Creation time:          2017-06-21 13:27:41 +0700
>         Subvolume ID:           257
>         Generation:             539
>         Gen at creation:        9
>         Parent ID:              5
>         Top level ID:           5
>         Flags:                  -
>         Snapshot(s):
>                                 mysql_201708060830
>                                 mysql_201708070830
>                                 mysql_201708080830
>                                 mysql_201708090830
>                                 mysql_201708100830
>                                 mysql_201708110830
>                                 mysql_201708120830
>                                 mysql_201708130830
>
> yes I think it has Received UUID because I restored the source from snapshot
> mysql_201708040830 for prove that the local snapshot was work.
>
> How to clear the Received UUID ?
> What to do next?


I'm using btrfs-progs 4.12, and I just did a btrfs send/receive from
file system A to B; and then on B I took a rw snapshot of the ro
snapshot. The ro snapshot has Received UUID, but the rw snapshot made
from it does not have Received UUID. So now I'm confused how you have
a rw snapshot with Received UUID set.


Did you ever use 'btrfs property set' to change a ro snapshot to rw?
That's the only way I can think it's possible. The only other thing is
maybe the behavior has changed since btrfs-progs 4.4.

It is possible this behavior has changed since btrfs-progs 4.4. The
changelogs shows there are improvements in send/receive in particular
4.8.3 and 4.8.4, but also others. I have no idea which are related.
But anyway, this is one of the reasons why the expert users on this
almost always say use something newer because it's just too hard to
remember, even with changelogs, what's fixed and where.

My suggestion is to investigate moving to kernel 4.9 series; and it
should be safe to move to btrfs-progs 4.12 now. Any new features in
4.12 that can't be supported with an older kernel should fail
gracefully.

No matter what, you must have separate backups. You can't depend
exclusively on one backup, no matter the method. It's fine to use
send/receive for backup1. But backup2 should be a conventional backup,
e.g. XFS with rsync. Basically this is a game of risk and the more
independent backups you have, the more failure cases (especially user
error) you can recover from, at the expense of some complexity.



-- 
Chris Murphy
