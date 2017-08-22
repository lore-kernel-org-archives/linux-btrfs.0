Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:48554 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbdHVSKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 14:10:10 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 753E58C22
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 20:10:09 +0200 (MEST)
Date: Tue, 22 Aug 2017 20:10:09 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
Message-ID: <20170822181009.GN14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
 <20170822142451.GI14804@rus.uni-stuttgart.de>
 <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <20170822223647.350ca27d@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170822223647.350ca27d@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (22:36), Roman Mamedov wrote:

> > My users want the snapshots locally in a .snapshot subdirectory.
> > Because Netapp do it this way - for at least 20 years and we have a
> > multi-PB Netapp storage environment.
> 
> Just a side note, you do know that only subvolumes can be snapshotted on Btrfs,
> not any regular directory? And that snapshots are not recursive, i.e. if a
> subvolume "contains" other subvolumes (hint: it really doesn't), snapshots of
> the parent one will not include content of subvolumes below that in the tree.

Yes, I know this. But thanks for your hints! (Other readers here may be
not aware of this)


> I don't know how Netapp does this

I am only a Netapp/waffle user, so I know no internals.
Netapp is not Linux based and definitly a lot older than btrfs.


> from the way you describe that setup it feels like with Btrfs you're
> still in for some bad surprises and a part of your expectations will not
> be met.

I will take care :-)


> Do you plan to make each and every directory and subdirectory a subvolume

No. My idea is to place a symlink in every subdirectory pointing to the
snapshot directory. Not yet programmed...
I was hoping someone already has implemented such a feature.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170822223647.350ca27d@natsu>
