Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:37720 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752850AbdHKPfs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 11:35:48 -0400
Received: by mail-vk0-f54.google.com with SMTP id r199so14517569vke.4
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Aug 2017 08:35:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <13031.192.168.42.222.1502431206.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 11 Aug 2017 09:35:46 -0600
Message-ID: <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 11, 2017 at 12:00 AM,  <siranee.ja@tpc.co.th> wrote:
> Sorry Chris,
>
> I forgot to send the diff from rsync -anc result
>
> the source container A start data as data on snapshot  mysql_201708040830
>
> [root@backuplogC7 tmp]# ls -l /var/lib/mariadb
> total 0
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql
> drwxrwxr-x+ 1 mysql mysql 260 Jul 12 08:29 mysql_201708040830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708050830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708060830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708070830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708080830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708090830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708100830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708110830
>
> the dest    container B start data as data on snapshot mysql_201708070830
>
> [root@joytest tmp]# ls -l /var/lib/mariadb
> total 0
> drwxrwxr-x+ 1 mysql mysql 260 Aug 11 10:24 mysql
> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708070830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708080830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708090830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708100830
> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708110830
>
>
>
> tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708110830.txt
> dest_mysql_201708110830.txt
> 1c1
> < drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708110830
> ---
>> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708110830
> 5c5
> < -rw-rwx---     5242880 2017/08/10 07:30:35 mysql_201708110830/ib_logfile1
> ---
>> -rw-rwx---     5242880 2017/08/07 07:30:36 mysql_201708110830/ib_logfile1
>

I don't really understand this. I don't see the actual rsync -anc
command, what I see is a diff of two text files whose contents I also
don't understand. So I have to guess that ib_logfile1 is a file inside
of a snapshot on machine A, that was btrfs send -p / receive to
machine B and is now different for some reason?

If the problem is that ib_logfile1 is wrong only on machine B after
Btrfs send receive, that suggests it might be a network problem. The
Btrfs send receive stream only checksums btrfs metadata (the internal
commands in the stream). The data is not checksummed so it is possible
an uncaught network error can inject silent data corruption which
Btrfs will not catch - it's just the normal TCP/IP network
checksumming happening.

Anyway, I'm still confused whether the problem is a change only during
send/receive, or if there's a change happening on a machine in
isolation just when you delete other snapshots.


-- 
Chris Murphy
