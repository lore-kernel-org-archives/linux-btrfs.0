Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38230 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbeHUQxP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 12:53:15 -0400
Received: by mail-wm0-f67.google.com with SMTP id t25-v6so2860080wmi.3
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 06:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <ompef3$sim$1@blaine.gmane.org> <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
 <2641568.fxl50hTsRH@merkaba> <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
 <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com> <20180821120636.fatftem5qbhv22m4@angband.pl>
 <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
In-Reply-To: <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Tue, 21 Aug 2018 15:32:52 +0200
Message-ID: <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_lazytime_mount_option=E2=80=94no_support_in_Btrfs?=
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >> so pretty much everyone who wants to avoid the overhead from them can just
> >> use the `noatime` mount option.

It would be great if someone finally fixed this old bug then:
https://bugzilla.kernel.org/show_bug.cgi?id=61601
Until then, it seems practically impossible to use both noatime (this
can't be added as rootflag in the command line and won't apply if the
kernel already mounted the root as RW) and space-cache-v2 (has to be
added as a rootflag along with RW to take effect) for the root
filesystem (at least without an init*fs, which I never use, so can't
tell).
