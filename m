Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:65516 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbdHaGtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 02:49:18 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 8ACF68834
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 08:49:16 +0200 (MEST)
Date: Thu, 31 Aug 2017 08:49:16 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: number of subvolumes
Message-ID: <20170831064916.GA5783@rus.uni-stuttgart.de>
References: <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822204811.GO14804@rus.uni-stuttgart.de>
 <20170823071821.GA28319@rus.uni-stuttgart.de>
 <f75e66d.7ade2c40.15e0e3ced5c@gmail.com>
 <onkbkk$qs1$1@blaine.gmane.org>
 <22943.4266.793339.528061@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22943.4266.793339.528061@tree.ty.sabi.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 2017-08-24 (18:45), Peter Grandi wrote:

> As usual with Btrfs, there are corner cases to avoid: 'defrag'
> should be done before 'balance'

Good hint. So far I did it the other way: balance before defrag. 
I will switch.


> and with compression switched off

I have filesystems with compress mount option:

framstag@fex:~: grep /local /etc/fstab
LABEL=local /local btrfs  defaults,compress,user_subvol_rm_allowed 0 2

and a weekly cronjob, which does a defrag and balance.
I cannot disable compression.
Any hint here?


> I prefer dump-and-reload.

What do you mean by this?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<22943.4266.793339.528061@tree.ty.sabi.co.uk>
