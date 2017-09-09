Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:54366 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdIITwI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 15:52:08 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 1E7062585
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 21:52:07 +0200 (MEST)
Date: Sat, 9 Sep 2017 21:52:06 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: netapp-alike snapshots?
Message-ID: <20170909195206.GA11461@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <20170909132614.GA20299@rus.uni-stuttgart.de>
 <20170909133612.7iqwr6cbjxzvfny6@merlins.org>
 <20170909134426.GB20299@rus.uni-stuttgart.de>
 <14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-09 (22:43), Andrei Borzenkov wrote:

> > Your tool does not create .snapshot subdirectories in EVERY directory like
> 
> Neither does NetApp. Those "directories" are magic handles that do not
> really exist.

I know.
But symbolic links are the next close thing (I am not a kernel programmer).


> Apart from obvious problem with recursive directory traversal (NetApp
> .snapshot are not visible with normal directory list)

Yes, they are, at least sometimes, eg tar includes the snapshots.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com>
