Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:33452 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdHMTb6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 15:31:58 -0400
Received: by mail-ua0-f177.google.com with SMTP id 80so30468613uas.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 12:31:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7251.49.228.115.25.1502621355.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail> <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail> <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
 <6341.49.228.122.75.1502590802.squirrel@mail> <CAJCQCtTNw0Y_yg_dyOjE7JPm4rRZ-WMnexh+4E4mRmQ8BFPAWQ@mail.gmail.com>
 <1318.49.228.122.75.1502595606.squirrel@mail> <CAJCQCtTsFftee7Gt9WWWbQF_2_t3qGUk_7rP+efN_PRb8H-P8g@mail.gmail.com>
 <7251.49.228.115.25.1502621355.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 13 Aug 2017 13:31:56 -0600
Message-ID: <CAJCQCtQ24iT-q3mDBxLj92UosDJGDchFYiJKAVL7xk8rLNOeCg@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 13, 2017 at 4:49 AM,  <siranee.ja@tpc.co.th> wrote:

> [root@backuplogC7 ~]# btrfs send /var/lib/mariadb/mysql_201708090830 | ssh
> 192.168.45.166 btrfs receive /var/lib/mariadb
> At subvol /var/lib/mariadb/mysql_201708090830
> At subvol mysql_201708090830
> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830/
> root@192.168.45.166:/var/lib/mariadb/mysql_201708090830/
> sending incremental file list
> ./
>
> sent 3773 bytes  received 19 bytes  842.67 bytes/sec
> total size is 718361496  speedup is 189441.32 (DRY RUN)


OK so the full send is sane. That suggests the file systems on both
sides are OK, and that the problem is related strictly to incremental
send/receive. It suggests that in a critical way either an origin
parent or its copy on the destination are not identical. Why will be
hard to figure out, and I'm not even sure it's worth it.

Right now you basically have a work around: a known good full send,
you can start doing incremental send/receive again using this full
send/receive snapshot as the parent (with -p).

Where confusion can happen is if you have to restore a snapshot, I
think you must commit to a whole new canonical tree with the reverse
send/receive being a full one, NOT incremental. I'm asserting this, I
do not know if it is true, I don't know if the tools should prevent
reverse incremental send/receive, but the very idea of reversing an
incremental send receive to me just seems logically problematic. Any
time you reverse the send/receive direction it must be full. I think.

I did once get into trouble with this myself, having to do a restore
from backup, to a new file system. I then took a rw snapshot of it,
and made that the canonical live modify subvolume. I then ro
snapshotted it, and tried to do an incremental send *back* to backup
and it failed with an error I don't remember but I think it was later
send/receive versions than 4.4 where there's some extract sanity
checking to prevent this. And I was able to work around it with -c
(clone) option. Anyway, I got sufficiently confused myself after all
of that, that I pretty much gave up on such a strategy, blew away all
the ro snapshots on both sides, and started from scratch with a new
full send, and then resumed the incrementals unidirectionally. And
anytime they are reversed I assume it must be a full send.

Anyway, I think it's perilous to reverse directions while also trying
to do incremental send/receive without a lot of testing to thoroughly
understand what's going on. And I basically got to fuck this, not
worth the complexity.

-- 
Chris Murphy
