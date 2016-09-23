Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33212 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753266AbcIWCDV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 22:03:21 -0400
Received: by mail-oi0-f53.google.com with SMTP id r126so119261086oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 19:03:21 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 22 Sep 2016 20:03:20 -0600
Message-ID: <CAJCQCtSJhXdERkSByMfQq8gas5ESZJviB6-xa5tYc2aM4MJSZQ@mail.gmail.com>
Subject: btrfs subvolume list and show disagree on generation
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

4.7.4-200.fc24.x86_64
btrfs-progs-4.7.3-1.fc26.x86_64

Bug for tracking:
https://bugzilla.kernel.org/show_bug.cgi?id=172751



I've been seeing this behavior for awhile (months, maybe a year) where
'list' generation does not match 'show' generation for a read only
snapshot. All of the items in this list are read only snapshots, and
the only one that has a valid list and show generation is the last
one. The generation 8019 is from today, but these read only snapshots
were created on their respective dates and have totally different
generations.

My expectation is that upon creating a read only snapshot, the gen for
that subvolum should be set in stone and never change again. Show
seems to agree, but list is coming up with something different.


[chris@f24s first]$ sudo btrfs sub list -t /brick2
ID    gen    top level    path
--    ---    ---------    ----
1208    8019    5        everything-20160218
1555    8019    5        everything-20160226
1558    8019    5        everything-20160304
1560    8019    5        everything-20160322
1567    8019    5        everything-20160405
1572    8019    5        everything-20160405-2
1573    8019    5        everything-20160409
1574    8019    5        everything-20160410
1592    8019    5        everything-20160416
1593    8019    5        everything-20160424
1600    8019    5        everything-20160504
1601    8019    5        everything-20160608
1607    8019    5        everything-20160711
1611    8019    5        everything-20160720
1614    8019    5        everything-20160805
1615    8019    5        everything-20160831
1617    8025    5        everything-20160913
1629    8028    5        everything-20160922

[chris@f24s first]$ sudo btrfs sub show everything-20160218
/mnt/first/everything-20160218
    Name:             everything-20160218
    UUID:             snip
    Parent UUID:         snip
    Received UUID:         -
    Creation time:         2016-02-18 21:24:03 -0700
    Subvolume ID:         673
    Generation:         1759
    Gen at creation:     1007
    Parent ID:         5
    Top level ID:         5
    Flags:             readonly
    Snapshot(s):


-- 
Chris Murphy
