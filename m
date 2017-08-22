Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:55178 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbdHVVxp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 17:53:45 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id EAD1A87E2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:53:43 +0200 (MEST)
Date: Tue, 22 Aug 2017 23:53:43 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: user snapshots
Message-ID: <20170822215343.GP14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
 <20170822142451.GI14804@rus.uni-stuttgart.de>
 <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22940.31139.194399.982315@tree.ty.sabi.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (19:36), Peter Grandi wrote:

> For somewhat good reasons subvolumes including snapshots cannot be
> deleted by users though unless mount option 'user_subvol_rm_allowed' is
> used.

Also in https://btrfs.wiki.kernel.org/index.php/Mount_options
"user_subvol_rm_allowed (...) Use with caution."

Why? What is the problem?

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<22940.31139.194399.982315@tree.ty.sabi.co.uk>
