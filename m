Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35731 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdGVSGT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 14:06:19 -0400
Received: by mail-wm0-f53.google.com with SMTP id w126so33537399wme.0
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jul 2017 11:06:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQBidjgsg4MadAAqoy6+dQHCkgz=8pxPX2CC=6Mwj38MQ@mail.gmail.com>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
 <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com> <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
 <20170717155400.GN2866@twin.jikos.cz> <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
 <9a16f6d5-90cd-bd04-a0ea-63e88cc3faf4@gmail.com> <CAJCQCtQBidjgsg4MadAAqoy6+dQHCkgz=8pxPX2CC=6Mwj38MQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 22 Jul 2017 12:06:17 -0600
Message-ID: <CAJCQCtQohx9MYbNFYyd6HidxSE6Cm7+ptwx76HmxBFdy9_7Zuw@mail.gmail.com>
Subject: Re: btrfs device ready purpose
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just did an additional test that's pretty icky behavior.

2x HDD device Btrfs volume. Add both devices and `btrfs devices ready`
exits with 0 as expected. Physically remove both USB devices.
Reconnect one device. `btrfs device ready` still exits 0. That's
definitely not good. (If I leave that one device connected and reboot,
`btrfs device ready` exits 1).


Chris Murphy
