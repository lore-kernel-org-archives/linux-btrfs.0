Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:63608 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdIOQ22 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 12:28:28 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 0E473242D
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 18:28:26 +0200 (MEST)
Date: Fri, 15 Sep 2017 18:28:25 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: snapshots of encrypted directories?
Message-ID: <20170915162825.GC32347@rus.uni-stuttgart.de>
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
 <20170915100103.GB32347@rus.uni-stuttgart.de>
 <CAEtw4r1KUQJGZkKEA+e3J=3+4a9hW+-ZBRBfTXhwYn4Ae30CCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEtw4r1KUQJGZkKEA+e3J=3+4a9hW+-ZBRBfTXhwYn4Ae30CCw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2017-09-15 (12:15), Peter Becker wrote:
> 2017-09-15 12:01 GMT+02:00 Ulli Horlacher <framstag@rus.uni-stuttgart.de>:
> 
> > On Fri 2017-09-15 (06:45), Andrei Borzenkov wrote:
> >
> >> The actual question is - do you need to mount each individual btrfs
> >> subvolume when using encfs?
> >
> > And even worse it goes with ecryptfs: I do not know at all how to mount a
> > snapshot, so that the user has access to it.
> 
> A snapshot is simply a subvolume.
> 
> Get the ID of the snapshot and mount it:
> 
> btrfs subvolume list /btrfs
> mount -o subvolid=<ID> /dev/<DISK> /<MOUNTPOINT_ENCRYPTED>
> 
> Or mount the snapshot directly by path:
> 
> mount -o subvol=/snapshots/home/2015-12-01 /<MOUNTPOINT_ENCRYPTED>
> 
> And then mount enryptfs:
> 
> mount.ecryptfs /<MOUNTPOINT_ENCRYPTED> /<MOUNTPOINT_DECRYPTED>

This only possible by root.
For a user it is not possible to have access for his own snapshots.
Bad.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<CAEtw4r1KUQJGZkKEA+e3J=3+4a9hW+-ZBRBfTXhwYn4Ae30CCw@mail.gmail.com>
