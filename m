Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:35093 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbdIOTl2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 15:41:28 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id C2A4D891E
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 21:41:26 +0200 (MEST)
Date: Fri, 15 Sep 2017 21:41:26 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: snapshots of encrypted directories?
Message-ID: <20170915194126.GF32347@rus.uni-stuttgart.de>
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
 <20170915100103.GB32347@rus.uni-stuttgart.de>
 <CAEtw4r1KUQJGZkKEA+e3J=3+4a9hW+-ZBRBfTXhwYn4Ae30CCw@mail.gmail.com>
 <20170915162825.GC32347@rus.uni-stuttgart.de>
 <6cd1ef22-7cab-4c8c-0b73-d254aeca83ad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6cd1ef22-7cab-4c8c-0b73-d254aeca83ad@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2017-09-15 (13:16), Austin S. Hemmelgarn wrote:

> >> And then mount enryptfs:
> >>
> >> mount.ecryptfs /<MOUNTPOINT_ENCRYPTED> /<MOUNTPOINT_DECRYPTED>
> > 
> > This only possible by root.
> > For a user it is not possible to have access for his own snapshots.
> > Bad.
> 
> Which is why you use EncFS (which is a FUSE module that runs in 
> userspace and requires no root privileges) instead of eCryptFS (which is 
> a kernel assisted filesystem that doesn't use FUSE, has more complicated 
> setup constraints, and requires CAP_SYS_ADMIN or root access).

I use both, encfs and ecryptfs, for different use cases.
I use ecryptfs on my notebooks for $HOME, which has some kind of
automounter on login (via pam).
This setup is not possible with encfs, which is also much slower and has
a lower security level.

But even for encfs it is very circumstantial for a user to have access to
snapshots.

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<6cd1ef22-7cab-4c8c-0b73-d254aeca83ad@gmail.com>
