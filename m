Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:48384 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbdHVSB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 14:01:57 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id CF9128B70
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 20:01:55 +0200 (MEST)
Date: Tue, 22 Aug 2017 20:01:55 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
Message-ID: <20170822180155.GM14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
 <20170822142451.GI14804@rus.uni-stuttgart.de>
 <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (19:19), A L wrote:
> Perhaps using a bind mount? It would look and work the same as a ordinary fs. Just need to make sure du uses one filesystem.
> 
> ---- From: Ulli Horlacher <framstag@rus.uni-stuttgart.de> -- Sent: 2017-08-22 - 18:57 ----
> 
> > On Tue 2017-08-22 (21:45), Roman Mamedov wrote:
> > 
> >> It is beneficial to not have snapshots in-place. With a local directory of
> >> snapshots, issuing things like "find", "grep -r" or even "du" will take an
> >> inordinate amount of time and will produce a result you do not expect.
> > 
> > Netapp snapshots are invisible for tools doing opendir()/readdir()
> > One could simulate this with symlinks for the snapshot directory:
> > store the snapshot elsewhere (not inplace) and create a symlink to it, in
> > every directory.

Not only du works recursivly, but also find and with option also ls, grep,
etc.

And it would require a bind mount for EVERY directory. There can be
hundreds... thousends!


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
