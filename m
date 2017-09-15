Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:55853 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdIOKPx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 06:15:53 -0400
Received: by mail-lf0-f52.google.com with SMTP id u21so1909818lfk.12
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 03:15:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170915100103.GB32347@rus.uni-stuttgart.de>
References: <20170914145739.GA32347@rus.uni-stuttgart.de> <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com> <20170915100103.GB32347@rus.uni-stuttgart.de>
From: Peter Becker <floyd.net@gmail.com>
Date: Fri, 15 Sep 2017 12:15:50 +0200
Message-ID: <CAEtw4r1KUQJGZkKEA+e3J=3+4a9hW+-ZBRBfTXhwYn4Ae30CCw@mail.gmail.com>
Subject: Re: snapshots of encrypted directories?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-15 12:01 GMT+02:00 Ulli Horlacher <framstag@rus.uni-stuttgart.de>:
> On Fri 2017-09-15 (06:45), Andrei Borzenkov wrote:
>
>> The actual question is - do you need to mount each individual btrfs
>> subvolume when using encfs?
>
> And even worse it goes with ecryptfs: I do not know at all how to mount a
> snapshot, so that the user has access to it.

A snapshot is simply a subvolume.

Get the ID of the snapshot and mount it:

btrfs subvolume list /btrfs
mount -o subvolid=<ID> /dev/<DISK> /<MOUNTPOINT_ENCRYPTED>

Or mount the snapshot directly by path:

mount -o subvol=/snapshots/home/2015-12-01 /<MOUNTPOINT_ENCRYPTED>

And then mount enryptfs:

mount.ecryptfs /<MOUNTPOINT_ENCRYPTED> /<MOUNTPOINT_DECRYPTED>
