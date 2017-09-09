Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:33816 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753485AbdIINo2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 09:44:28 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id E600B8CB7
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 15:44:26 +0200 (MEST)
Date: Sat, 9 Sep 2017 15:44:26 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: netapp-alike snapshots?
Message-ID: <20170909134426.GB20299@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <20170909132614.GA20299@rus.uni-stuttgart.de>
 <20170909133612.7iqwr6cbjxzvfny6@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170909133612.7iqwr6cbjxzvfny6@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-09 (06:36), Marc MERLIN wrote:

> > On Tue 2017-08-22 (15:22), Ulli Horlacher wrote:
> > > With Netapp/waffle you have automatic hourly/daily/weekly snapshots.
> > > You can find these snapshots in every local directory (readonly).
> > 
> > I have found none, so I have implemented it by myself:
> > 
> > https://fex.rus.uni-stuttgart.de/snaprotate.html
> 
> Not sure how you looked :)
> http://marc.merlins.org/perso/btrfs/post_2014-03-21_Btrfs-Tips_-How-To-Setup-Netapp-Style-Snapshots.html
> 
> Might not be exactly what you wanted, but been using it for 3 years.

Your tool does not create .snapshot subdirectories in EVERY directory like
Netapp does.
Example:

framstag@fex:~: cd ~/Mail/.snapshot/
framstag@fex:~/Mail/.snapshot: l
lR-X - 2017-09-09 09:55 2017-09-09_0000.daily -> /local/home/.snapshot/2017-09-09_0000.daily/framstag/Mail
lR-X - 2017-09-09 14:00 2017-09-09_1400.hourly -> /local/home/.snapshot/2017-09-09_1400.hourly/framstag/Mail
lR-X - 2017-09-09 15:00 2017-09-09_1500.hourly -> /local/home/.snapshot/2017-09-09_1500.hourly/framstag/Mail
lR-X - 2017-09-09 15:18 2017-09-09_1518.single -> /local/home/.snapshot/2017-09-09_1518.single/framstag/Mail
lR-X - 2017-09-09 15:20 2017-09-09_1520.single -> /local/home/.snapshot/2017-09-09_1520.single/framstag/Mail
lR-X - 2017-09-09 15:22 2017-09-09_1522.single -> /local/home/.snapshot/2017-09-09_1522.single/framstag/Mail

My users (and I) need snapshots in this way.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170909133612.7iqwr6cbjxzvfny6@merlins.org>
