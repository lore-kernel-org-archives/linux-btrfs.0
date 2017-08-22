Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:51309 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751094AbdHVQ50 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 12:57:26 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id B84B16406
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 18:57:25 +0200 (MEST)
Date: Tue, 22 Aug 2017 18:57:25 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
Message-ID: <20170822165725.GL14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
 <20170822142451.GI14804@rus.uni-stuttgart.de>
 <20170822214531.44538589@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170822214531.44538589@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (21:45), Roman Mamedov wrote:

> It is beneficial to not have snapshots in-place. With a local directory of
> snapshots, issuing things like "find", "grep -r" or even "du" will take an
> inordinate amount of time and will produce a result you do not expect.

Netapp snapshots are invisible for tools doing opendir()/readdir()
One could simulate this with symlinks for the snapshot directory:
store the snapshot elsewhere (not inplace) and create a symlink to it, in
every directory.


> Personally I prefer to have a /snapshots directory on every FS

My users want the snapshots locally in a .snapshot subdirectory.
Because Netapp do it this way - for at least 20 years and we have a
multi-PB Netapp storage environment.
No chance to change this.

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170822214531.44538589@natsu>
