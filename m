Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:54061 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdIPO2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 10:28:18 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 84E46899D
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 16:28:16 +0200 (MEST)
Date: Sat, 16 Sep 2017 16:28:16 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170916142816.GN32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
 <20170916101901.GM32347@rus.uni-stuttgart.de>
 <e1b1e123-67f5-6911-494e-da9ebdbd65cc@rqc.ru>
 <20170916134748.00a7e1d8@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170916134748.00a7e1d8@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-16 (13:47), Kai Krakow wrote:

> Or you do "btrfs device stats .", it shows the associated device(s).

tux@xerus:/test/tux/zz: btrfs device stats .
ERROR: getting dev info for devstats failed: Operation not permitted

Not possible for a normal user.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170916134748.00a7e1d8@jupiter.sol.kaishome.de>
