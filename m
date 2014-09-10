Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36396 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaIJNsX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 09:48:23 -0400
Received: by mail-vc0-f176.google.com with SMTP id la4so2476947vcb.21
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 06:48:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54104CD6.3030604@gmail.com>
References: <541043B8.7010601@barrowhillfarm.org.uk>
	<54104CD6.3030604@gmail.com>
Date: Wed, 10 Sep 2014 09:48:22 -0400
Message-ID: <CAGfcS_=DKk1g87mvKBRyXmycjMjoSFbi3P6Qrrn5KQ0nD0HStg@mail.gmail.com>
Subject: Re: Is it necessary to balance a btrfs raid1 array?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Bob Williams <linux@barrowhillfarm.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 10, 2014 at 9:06 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> Normally, you shouldn't need to run balance at all on most BTRFS
> filesystems, unless your usage patterns vary widely over time (I'm
> actually a good example of this, most of the files in my home directory
> are relatively small, except for when I am building a system with
> buildroot or compiling a kernel, and on occasion I have VM images that
> I'm working with).

Tend to agree, but I do keep a close eye on free space.  If I get to
the point where I'm over 90% allocated to chunks with lots of unused
space otherwise I run a balance.  I tend to have the most problems
with my root/OS filesystem running on a 64GB SSD, likely because it is
so small.

Is there a big performance penalty running mixed chunks on an SSD?  I
believe this would get rid of the risk of ENOSPC issues if everything
gets allocated to chunks.  There are obviously no issues with random
access on an SSD, but there could be other problems (cache
utilization, etc).

I tend to watch btrfs fi sho and if the total space used starts
getting high then I run a balance.  Usually I run with -dusage=30 or
-dusage=50, but sometimes I get to the point where I just need to do a
full balance.  Often it is helpful to run a series of balance commands
starting at -dusage=10 and moving up in increments.  This at least
prevents killing IO continuously for hours.  If we can get to a point
where balancing can operate at low IO priority that would be helpful.

IO priority is a problem in btrfs in general.  Even tasks run at idle
scheduling priority can really block up a disk.  I've seen a lot of
hurry-and-wait behavior in btrfs.  It seems like the initial commit to
the log/etc is willing to accept a very large volume of data, and then
when all the trees get updated the system grinds to a crawl trying to
deal with all the data that was committed.  The problem is that you
have two queues, with the second queue being rate-limiting but the
first queue being the one that applies priority control.  What we
really need is for the log to have controls on how much it accepts so
that the updating of the trees/etc never is rate-limiting.   That will
limit the ability to have short IO write bursts, but it would prevent
low-priority writes from blocking high-priority read/writes.

--
Rich
