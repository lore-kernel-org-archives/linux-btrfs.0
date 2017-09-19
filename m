Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:55127 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbdISSW1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 14:22:27 -0400
Received: by mail-io0-f179.google.com with SMTP id h66so1128596ioh.11
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 11:22:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170915100103.GB32347@rus.uni-stuttgart.de>
References: <20170914145739.GA32347@rus.uni-stuttgart.de> <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com> <20170915100103.GB32347@rus.uni-stuttgart.de>
From: Dave <davestechshop@gmail.com>
Date: Tue, 19 Sep 2017 14:22:06 -0400
Message-ID: <CAH=dxU6DX_P8JH_VfvF1vGrH-Exm9dGceWCrGZ_AwV3fNdOWqA@mail.gmail.com>
Subject: Re: snapshots of encrypted directories?
To: linux-btrfs@vger.kernel.org
Cc: framstag@rus.uni-stuttgart.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 15, 2017 at 6:01 AM, Ulli Horlacher
<framstag@rus.uni-stuttgart.de> wrote:
>
> On Fri 2017-09-15 (06:45), Andrei Borzenkov wrote:
>
> > The actual question is - do you need to mount each individual btrfs
> > subvolume when using encfs?
>
> And even worse it goes with ecryptfs: I do not know at all how to mount a
> snapshot, so that the user has access to it.
>
> It seems snapshots are incompatible with encrypted filesystems :-(


My experience is the opposite. I use dm-crypt as well as encfs with
BTRFS and everything, including snapshots, works as I would expect it
to work.

I have been able to successfully restore snapshots that contained
encrypted data.

I think the other answers have already provided more details than I
could provide, so I just wanted to add the fact that my experience has
been positive with BTRFS snapshots and encryption.
