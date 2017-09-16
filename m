Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:46901 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdIPJWk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 05:22:40 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id CDB5D87B9
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 11:22:38 +0200 (MEST)
Date: Sat, 16 Sep 2017 11:22:38 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170916092238.GK32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <22972.16657.822204.646994@tree.ty.sabi.co.uk>
 <20170915214434.GG32347@rus.uni-stuttgart.de>
 <20170915220201.GH32347@rus.uni-stuttgart.de>
 <20170916012248.0870f72d@jupiter.sol.kaishome.de>
 <2d343791-7b32-bd53-a03d-a5b26465d358@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2d343791-7b32-bd53-a03d-a5b26465d358@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-16 (11:04), Goffredo Baroncelli wrote:

> In the past I proposed to allow an ordinary user to remove an *empty* subvolume with a simple rmdir (if he has the permissions). This would solve this kind of problem.
> or to relax the check around "btrfs sub del", so an user can remove an _empty_ subvolume

This would help a lot!
Where can I sign this petition? :-)

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<2d343791-7b32-bd53-a03d-a5b26465d358@libero.it>
