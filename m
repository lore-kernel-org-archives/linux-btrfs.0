Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:33338 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753485AbdIIN0Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 09:26:16 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id C61698A82
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 15:26:14 +0200 (MEST)
Date: Sat, 9 Sep 2017 15:26:14 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: netapp-alike snapshots?
Message-ID: <20170909132614.GA20299@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170822132208.GD14804@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (15:22), Ulli Horlacher wrote:
> With Netapp/waffle you have automatic hourly/daily/weekly snapshots.
> You can find these snapshots in every local directory (readonly).

> I would like to have something similar with btrfs.
> Is there (where?) such a tool?

I have found none, so I have implemented it by myself:

https://fex.rus.uni-stuttgart.de/snaprotate.html

In contrast to Netapp, with snaprotate the local host administrator can
create a snapshot at any time or by cronjob.

Example:

root@fex:~# snaprotate single 3 /local/home
Create a readonly snapshot of '/local/home' in '/local/home/.snapshot/2017-09-09_1518.single'
Delete subvolume '/local/home/.snapshot/2017-09-09_1255.single'

root@fex:~# snaprotate -l
/local/home/.snapshot/2017-09-08_0000.daily
/local/home/.snapshot/2017-09-09_0000.daily
/local/home/.snapshot/2017-09-09_1331.single
/local/home/.snapshot/2017-09-09_1332.single
/local/home/.snapshot/2017-09-09_1400.hourly
/local/home/.snapshot/2017-09-09_1500.hourly
/local/home/.snapshot/2017-09-09_1518.single

root@fex:~# crontab -l | grep snaprotate
0 * * * * /root/bin/snaprotate -q hourly 2 /local/home
0 0 * * * /root/bin/snaprotate -q daily  3 /local/home
0 0 * * 1 /root/bin/snaprotate -q weekly 1 /local/home

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170822132208.GD14804@rus.uni-stuttgart.de>
