Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:65081 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753342AbdHWHUt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 03:20:49 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 3FFFF88A6
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 09:20:48 +0200 (MEST)
Date: Wed, 23 Aug 2017 09:20:48 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: user snapshots
Message-ID: <20170823072048.GB28319@rus.uni-stuttgart.de>
References: <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
 <20170822142451.GI14804@rus.uni-stuttgart.de>
 <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822215343.GP14804@rus.uni-stuttgart.de>
 <124CEBB9-BF23-4688-B23C-294EDCAD27AA@demfloro.ru>
 <20170823101635.114d02d2@job>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170823101635.114d02d2@job>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 2017-08-23 (10:16), Dmitrii Tcvetkov wrote:
> > >Also in https://btrfs.wiki.kernel.org/index.php/Mount_options
> > >"user_subvol_rm_allowed (...) Use with caution."
> > >
> > >Why? What is the problem?  
> > 
> > Because with the mount option any user can delete any subvolume,
> > including root one (subvol_id=5)
> 
> Apologies, it works somewhat different:
> filesystem doesn't allow to delete subvolume with id 5 and POSIX access
> is checked before deleting subvolume with user_subvol_rm_allowed mount
> option.

I have tested it already :-)

So, still: What is the problem with user_subvol_rm_allowed?

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170823101635.114d02d2@job>
