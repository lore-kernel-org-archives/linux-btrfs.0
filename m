Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:37677 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdHMC7Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 22:59:16 -0400
Received: by mail-ua0-f170.google.com with SMTP id f9so26909637uaf.4
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Aug 2017 19:59:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6341.49.228.122.75.1502590802.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail> <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail> <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
 <6341.49.228.122.75.1502590802.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 12 Aug 2017 20:59:14 -0600
Message-ID: <CAJCQCtTNw0Y_yg_dyOjE7JPm4rRZ-WMnexh+4E4mRmQ8BFPAWQ@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 12, 2017 at 8:20 PM,  <siranee.ja@tpc.co.th> wrote:

> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830
> root@192.168.45.166://var/lib/mariadb/mysql_201708090830


You need trailing / for the first directory with -a option.

rsync -a dir dir

is not the same command as

rsync -a dir/ dir

It's confusing but your command is trying to create mysql_201708090830
directory on the source, in the mysql_201708090830 on the destination.
That is why everything mismatches. To make it mean "contents of" you
need trailing slash on at least the origin.



-- 
Chris Murphy
