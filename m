Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:35334 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750879AbdIOKBF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 06:01:05 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 9ABB381D9
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 12:01:03 +0200 (MEST)
Date: Fri, 15 Sep 2017 12:01:03 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: snapshots of encrypted directories?
Message-ID: <20170915100103.GB32347@rus.uni-stuttgart.de>
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2017-09-15 (06:45), Andrei Borzenkov wrote:

> The actual question is - do you need to mount each individual btrfs
> subvolume when using encfs? 

And even worse it goes with ecryptfs: I do not know at all how to mount a
snapshot, so that the user has access to it.

It seems snapshots are incompatible with encrypted filesystems :-(


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
