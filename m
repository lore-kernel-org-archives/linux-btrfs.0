Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33337 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756910AbcIWCPQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 22:15:16 -0400
Received: by mail-oi0-f50.google.com with SMTP id r126so119492745oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 19:15:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQE1ZoJ6hiwd6aeCQszDLkJ1w-M4=yD7yXtqX9boNcqng@mail.gmail.com>
References: <CAJCQCtSJhXdERkSByMfQq8gas5ESZJviB6-xa5tYc2aM4MJSZQ@mail.gmail.com>
 <CAJCQCtQE1ZoJ6hiwd6aeCQszDLkJ1w-M4=yD7yXtqX9boNcqng@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 22 Sep 2016 20:15:15 -0600
Message-ID: <CAJCQCtSe0E9XDkdT-iDn5CeWtR_hygjZpBAmwFtExwtRtZCqxw@mail.gmail.com>
Subject: Re: btrfs subvolume list and show disagree on generation
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Aha, ok part of this was user error. Same subvolume, two different
volumes. Fixed that now:



[root@f24s brick2]# btrfs sub list /brick2
ID 1208 gen 8019 top level 5 path everything-20160218
ID 1555 gen 8019 top level 5 path everything-20160226
ID 1558 gen 8019 top level 5 path everything-20160304
ID 1560 gen 8019 top level 5 path everything-20160322
ID 1567 gen 8019 top level 5 path everything-20160405
ID 1572 gen 8019 top level 5 path everything-20160405-2
ID 1573 gen 8019 top level 5 path everything-20160409
ID 1574 gen 8019 top level 5 path everything-20160410
ID 1592 gen 8019 top level 5 path everything-20160416
ID 1593 gen 8019 top level 5 path everything-20160424
ID 1600 gen 8019 top level 5 path everything-20160504
ID 1601 gen 8019 top level 5 path everything-20160608
ID 1607 gen 8019 top level 5 path everything-20160711
ID 1611 gen 8019 top level 5 path everything-20160720
ID 1614 gen 8019 top level 5 path everything-20160805
ID 1615 gen 8019 top level 5 path everything-20160831
ID 1617 gen 8025 top level 5 path everything-20160913
ID 1629 gen 8030 top level 5 path everything-20160922

[root@f24s brick2]# btrfs sub show /brick2/everything-20160218/
/brick2/everything-20160218
    Name:             everything-20160218
    UUID:             snip
    Parent UUID:         -
    Received UUID:         snip
    Creation time:         2016-02-18 21:54:38 -0700
    Subvolume ID:         1208
    Generation:         8019
    Gen at creation:     6533
    Parent ID:         5
    Top level ID:         5
    Flags:             readonly
    Snapshot(s):
                everything-20160226


OK so there is agreement between 'list' and 'show'. However, the
generation changing for read only snapshots is not something I'm
expecting. Is it supposed to happen?
