Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54343 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753485AbdIINgX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 09:36:23 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:57422 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1dqfvh-0008PZ-Cd
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Sep 2017 06:36:18 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1dqfvg-00024Y-KE
        for linux-btrfs@vger.kernel.org; Sat, 09 Sep 2017 06:36:12 -0700
Date: Sat, 9 Sep 2017 06:36:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170909133612.7iqwr6cbjxzvfny6@merlins.org>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <20170909132614.GA20299@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170909132614.GA20299@rus.uni-stuttgart.de>
Subject: Re: netapp-alike snapshots?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 09, 2017 at 03:26:14PM +0200, Ulli Horlacher wrote:
> On Tue 2017-08-22 (15:22), Ulli Horlacher wrote:
> > With Netapp/waffle you have automatic hourly/daily/weekly snapshots.
> > You can find these snapshots in every local directory (readonly).
> 
> > I would like to have something similar with btrfs.
> > Is there (where?) such a tool?
> 
> I have found none, so I have implemented it by myself:
> 
> https://fex.rus.uni-stuttgart.de/snaprotate.html

Not sure how you looked :)
https://www.google.com/search?q=btrfs+netapp+snapshot
http://marc.merlins.org/perso/btrfs/post_2014-03-21_Btrfs-Tips_-How-To-Setup-Netapp-Style-Snapshots.html

Might not be exactly what you wanted, but been using it for 3 years.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
