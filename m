Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35907 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdHIFqW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 01:46:22 -0400
Received: by mail-wm0-f47.google.com with SMTP id t201so22982140wmt.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Aug 2017 22:46:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21234.192.168.42.222.1502253143.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 8 Aug 2017 23:46:20 -0600
Message-ID: <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 8, 2017 at 10:32 PM,  <siranee.ja@tpc.co.th> wrote:
> Hi btrfs support team,
>
> My name is siranee jaraswachirakul. I tested btrfs incremental send and receive and
> I found something incorrect.
>
> I posted detail in the url
> http://www.linuxquestions.org/questions/showthread.php?p=5746238#post5746238
>
> Could you please help me to find the reason?

The command "btrfs sub snap mysql_201707210830 mysql" is unexpected
for two reasons:

1. This is a rw snapshot. It needs to be ro using -r flag to make it
ro, and only ro snapshots can be used with btrfs send receive.
2. The naming convention seems reversed. The subvolume you're
snapshotting should be first, and the resulting snapshot is second,
and it is the second one that you'll send. So I think really what
you'll end up wanting is:

Machine A
btrfs sub snap -r mysql mysql_20170721
btrfs send mysql_20170721

Machine B
btrfs sub snap mysql_20170721 mysql

That will make a rw snapshot from the ro snapshot.

The next problem with the post is that you say "incremental" but I do
not see the exact send receive command you're using. An incremental
send requires -p option.



Machine A
btrfs sub snap -r mysql mysql_20170721
btrfs send mysql_20170721

Machine B
btrfs sub snap mysql_20170721 mysql
Test mysql
btrfs sub del mysql

Machine A (next day)

Machine A
btrfs sub snap -r mysql mysql_20170722
btrfs send -p mysql_20170721 mysql_20170722

Machine B
btrfs sub snap mysql_20170722 mysql
Test mysql
btrfs sub del mysql

And so on. You must have the -p snapshot on both file systems for the
incremental send/receive to work.



-- 
Chris Murphy
