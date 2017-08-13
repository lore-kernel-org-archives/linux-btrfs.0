Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34360 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdHMEeV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 00:34:21 -0400
Received: by mail-ua0-f174.google.com with SMTP id q25so27253951uah.1
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Aug 2017 21:34:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318.49.228.122.75.1502595606.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail> <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail> <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
 <6341.49.228.122.75.1502590802.squirrel@mail> <CAJCQCtTNw0Y_yg_dyOjE7JPm4rRZ-WMnexh+4E4mRmQ8BFPAWQ@mail.gmail.com>
 <1318.49.228.122.75.1502595606.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 12 Aug 2017 22:34:19 -0600
Message-ID: <CAJCQCtTsFftee7Gt9WWWbQF_2_t3qGUk_7rP+efN_PRb8H-P8g@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 12, 2017 at 9:40 PM,  <siranee.ja@tpc.co.th> wrote:

> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830/
> root@192.168.45.166://var/lib/mariadb/mysql_201708090830/
> sending incremental file list
> ./
> ib_logfile1
> ibdata1
>
> sent 3779 bytes  received 25 bytes  507.20 bytes/sec
> total size is 718361496  speedup is 188843.72 (DRY RUN)


OK so I don't think this can be a sync related problem. That snapshot
has been committed to disk days ago. There's definitely something
wrong with the incremental send/receive, but it's unclear whether this
is a kernel bug (send side) or btrfs-progs (receive side), or if
there's any chance of file system corruption/confusion happening with
either of the two subvolumes on the origin or the subvolume (parent)
on the destination.

So that means you're really in the weeds on what to do next.

Try deleting mysql_201708090830/ snapshot on the destination. And
resend but this time do a full send of that snapshot, don't use -p. I
wonder if a full send, rather than incremental makes a difference.
Follow it up with the rsync command to compare origin and destination.



-- 
Chris Murphy
