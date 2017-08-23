Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:65469 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751728AbdHWVN1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 17:13:27 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 8CABA6118
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 23:13:25 +0200 (MEST)
Date: Wed, 23 Aug 2017 23:13:25 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: user snapshots
Message-ID: <20170823211325.GC28319@rus.uni-stuttgart.de>
References: <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822215343.GP14804@rus.uni-stuttgart.de>
 <124CEBB9-BF23-4688-B23C-294EDCAD27AA@demfloro.ru>
 <20170823101635.114d02d2@job>
 <20170823072048.GB28319@rus.uni-stuttgart.de>
 <22941.27164.739577.517915@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22941.27164.739577.517915@tree.ty.sabi.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 2017-08-23 (12:42), Peter Grandi wrote:
> > So, still: What is the problem with user_subvol_rm_allowed?
> 
> As usual, it is complicated: mostly that while subvol creation
> is very cheap, subvol deletion can be very expensive. But then
> so can be creating many snapshots, as in this:

But it seems one cannot prohibit a user making snapshots?
Then root must delete them?

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<22941.27164.739577.517915@tree.ty.sabi.co.uk>
