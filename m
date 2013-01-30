Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56009 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab3A3SXY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 13:23:24 -0500
Received: by mail-wi0-f169.google.com with SMTP id hq12so4092587wib.4
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 10:23:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120810115628.GE32103@shiny>
References: <50232A19.2010704@cn.fujitsu.com>
	<20120809180405.GC32103@shiny>
	<5024E4B7.20600@cn.fujitsu.com>
	<20120810115628.GE32103@shiny>
Date: Wed, 30 Jan 2013 20:23:22 +0200
Message-ID: <CAOcd+r0+K_hpCPYwdJzT_yyPg_1d+6YKiAU4+zvGKM3UjR1hAg@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting shared
 block reference
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,
I was following this thread in the past, but I did not understand it
fully, maybe you can explain?

>> >>  # mkfs.btrfs <partition>
>> >>  # mount <partition> <mnt>
>> >>  # cd <mnt>
>> >>  # for ((i=0;i<2400;i++)); do touch long_name_to_make_tree_more_deep$i; done
>> >>  # for ((i=0; i<4; i++))
>> >>  > do
>> >>  > mkdir $i
>> >>  > for ((j=0; j<200; j++))
>> >>  > do
>> >>  > btrfs sub snap . $i/$j
>> >>  > done &
>> >>  > done
>> >
>> > snapshot creation has a critical section.  Once we copy a given root to
>> > its snapshot, we're not allowed to change it until the transaction
>> > is fully committed.

Is the limitation that if we are creating a snap B of root A, and
placing the root of B somewhere into the tree of A, then we can do
this only once per transaction? Does this limitation still exist or
your fix fixes it?

Also, according to your reproducer, each "btrfs sub snap" will
start/join a transaction, but then it will call
btrfs_commit_transaction() and not btrfs_commit_transaction_async(),
so it will wait until the transaction commits. So how it may happen
that you create more than one snap in the same transaction with your
reproducer?

The reason I am asking, is that I want to try to write code that
creates several snaps in one transaction and only then commits. Should
this be possible or there is some limitation, like I mentioned above?

Thanks for your help,
Alex.
