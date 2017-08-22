Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:54514 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753114AbdHVUsM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 16:48:12 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 4517584D4
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 22:48:11 +0200 (MEST)
Date: Tue, 22 Aug 2017 22:48:11 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
Message-ID: <20170822204811.GO14804@rus.uni-stuttgart.de>
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

> Indeed and there is a fair description of some options for
> subvolume nesting policies here which may be interesting to the
> original poster:
> 
>   https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Layout
> 
> It is unsurprising to me that there are tradeoffs involved in
> every choice. I find the "Flat" layout particularly desirable.

My layout is already nearly "flat".
It seems my decision was right :-)



> Btrfs snapshots can only be done for a whole subvolume.

I know this.

> Subvolumes and snapshots can be created by users, but too many snapshots
> (see below) can cause trouble. For somewhat good reasons subvolumes
> including snapshots cannot be deleted by users though unless mount option
> 'user_subvol_rm_allowed' is used.

Ooops, this is new to me!

framstag@fex:~: btrfs subvolume create xx
Create subvolume './xx'

framstag@fex:~: btrfs subvolume delete xx
Delete subvolume '/local/home/framstag/xx'
ERROR: cannot delete '/local/home/framstag/xx' - Operation not permitted

This means, root has to remove the subvolme.
Is it possible to disallow creation of subvolumes for normal users?



> >>> Because Netapp do it this way - for at least 20 years and we
> >>> have a multi-PB Netapp storage environment. No chance to change
> >>> this.
> 
> Send patches :-).

For waffle or btrfs? :-)


> Assumptions that all Btrfs features such as snapshots are
> infinitely scalable at no cost may be optimistic:
> 
>   https://btrfs.wiki.kernel.org/index.php/Gotchas#Having_many_subvolumes_can_be_very_slow

"when you do device removes on file systems with a lot of snapshots, it
 is unbelievably slow ... took nearly a week to move 20GB of FS data from
 one device to the other using that method"
  
"a balance on 2TB of data that was heavily snapshotted - it took 3 months" 

ARGH!!
Thanks for this warning!
I will overthink my multi-snapshots plan!

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<22940.31139.194399.982315@tree.ty.sabi.co.uk>
